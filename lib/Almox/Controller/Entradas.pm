package Almox::Controller::Entradas;
use Moose;
use namespace::autoclean;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }
use utf8;

=head1 NAME

Almox::Controller::Entradas - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base :Chained('/') :PathPart('entradas') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::EntradaDetalhada');
}

sub object :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $object_id) = @_;

    $c->stash->{object} = $c->model('DB::Entrada')->find($object_id);
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect( $c->uri_for('/entradas/listar') );
}

sub listar :Chained('base') :PathPart('listar') :Args(0) :FormConfig {
    my ($self, $c) = @_;

    $c->req->params->{page} ||= 1;
    my $entries_per_page = 20;

    my $entradas_rs = $c->stash->{resultset}
      ->search_rs({}, { rows => $entries_per_page })
        ->page( $c->req->params->{page} );

    $c->stash(entradas => [$entradas_rs->all],
              title_part => 'Listagem de Entradas',
              pager => $entradas_rs->pager);
}

sub adicionar :Local :FormConfig('entradas/formulario.yml') {
    my ($self, $c) = @_;
#    my $form = $c->stash->{form}->default_values();
#    $form->get_all_element({ type => 'Repeatable' })->repeat(2);
#    $form->get_all_element('entradas_itens_counter')->default(2);
#    $form->process;
   $c->stash(title_part => 'Adição de Entrada');
}

sub salvar :Chained('base') :PathPart('salvar') :Args(0) :FormConfig('entradas/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $entrada;
        if ($c->req->params->{id}) {
            $entrada = $c->model('DB::Entrada')->find( $c->req->params->{id} );
        }
        else {
            $entrada = $c->model('DB::Entrada')->new_result({});
        }

        my $schema = $c->model('DB::Entrada')->result_source->schema;
        my $form_update = sub { $form->model->update( $entrada ); };

        if (eval { $schema->txn_do($form_update) }) {
            $c->flash->{msg_ok} = 'Entrada salva.';
            $c->res->redirect( $c->uri_for('/entradas/listar') );
        }
        else {
            $c->stash->{msg_erro} = 'Erro na inserção. ' . $@;
            $c->stash->{template} = 'entradas/adicionar.tt';
        }
    }
    else {
        $c->stash->{msg_erro} = 'Erro na inserção.';
        $c->stash->{template} = 'entradas/adicionar.tt';
    }
}

sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('entradas/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash->{form}->model->default_values( $c->stash->{object} );
    $c->stash(title_part => 'Edição de Entrada',
             template => 'entradas/adicionar.tt');
}

sub ver :Chained('object') PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $entradas_detalhadas = $c->model('DB::EntradaDetalhada')->search_rs({ entrada_id => $c->stash->{object}->id });

    $c->stash(title_part => 'Visualização de Entrada',
              entradas_detalhadas => [$entradas_detalhadas->all]);
}

=head1 AUTHOR

Astux L<astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
