package Almox::Controller::Setores;
use Moose;
use namespace::autoclean;
use utf8;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

sub base :Chained('/') :PathPart('setores') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::Setor');
}

sub object :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $object_id) = @_;

    $c->stash->{object} = $c->stash->{resultset}->find($object_id);
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect( $c->uri_for('/setores/listar') );
}

sub listar :Chained('base') :PathPart('listar') :Args(0) :FormConfig('setores/listar.yml') {
    my ( $self, $c ) = @_;

    $c->req->query_params->{page} ||= 1;
    my $entries_per_page = 20;

    my $setores_rs = $c->stash->{resultset}
      ->search_rs({}, { "order_by" => "id", rows => $entries_per_page })
        ->page($c->req->query_params->{page});

    if ($c->req->query_params->{'q'}) {
        $setores_rs = $setores_rs
          ->search_rs({ nome => { ilike => "%" . $c->req->query_params->{'q'} . "%" } });
    }

    if ($c->req->query_params->{'ativacao'}) {
        $setores_rs = $setores_rs->search_rs({ ativacao => $c->req->query_params->{'ativacao'} });
    }

    $c->stash->{form}->default_values({ q => $c->req->query_params->{'q'},
                                        ativacao => $c->req->query_params->{'ativacao'} });

    $c->stash(setores => [$setores_rs->all],
              pager => $setores_rs->pager,
              q => $c->req->query_params->{'q'},
              title_part => 'Listagem de Setores');
}

sub ver :Chained('object') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Visualização de Setor');
}

sub adicionar :Path('adicionar') :Args(0) :FormConfig('setores/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Adição de Setor');
}

sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('setores/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash->{form}->model->default_values( $c->stash->{object} );
    $c->stash(title_part => 'Edição de Setor');
}

sub salvar :Chained('base') :PathPart('salvar') :Args(0) :FormConfig('setores/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $setor;
        if ($c->req->body_params->{id}) {
            $setor = $c->stash->{resultset}->find( $c->req->body_params->{id} );
        }
        else {
            $setor = $c->stash->{resultset}->new_result({});
        }

        $form->model->update($setor);
        $c->flash->{msg_ok} = 'Setor salvo.';
        $c->res->redirect($c->uri_for('/setores/listar'));
    } else {
        $c->stash->{template} = 'setores/adicionar.tt';
        $c->flash->{msg_erro} = 'Erro na inserção.'
    }
}

sub deletar :Chained('object') :PathPart('deletar') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{object}->delete;
    $c->stash->{msg_ok} = 'Setor deletado.';
    $c->res->redirect( $c->uri_for('/setores/listar') );
}

=head1 AUTHOR

Astux L<astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
