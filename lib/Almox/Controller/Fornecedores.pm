package Almox::Controller::Fornecedores;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

sub base :Chained('/') :PathPart('fornecedores') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::Fornecedor');
}

sub object :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $fornecedor_id) = @_;

    $c->stash->{object} = $c->stash->{resultset}->find($fornecedor_id);
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect($c->uri_for('/fornecedores/listar'));
}

sub listar :Chained('base') :PathPart('listar') :Args(0) :FormConfig {
    my ( $self, $c ) = @_;

    $c->req->params->{page} ||= 1;
    my $entries_per_page = 20;

    my $fornecedores_rs = $c->stash->{resultset}
      ->search_rs({
                   nome => { ilike => "%" . $c->req->params->{'q'} . "%" },
                  },
                  { "order_by" => "id", rows => $entries_per_page })
        ->page($c->req->params->{page});

    if ($c->req->params->{'ativacao'}) {
        $fornecedores_rs = $fornecedores_rs->search_rs({ ativacao => $c->req->params->{'ativacao'} });
    }

    $c->stash->{form}->default_values({ q => $c->req->params->{'q'},
                                        ativacao => $c->req->params->{'ativacao'} });

    $c->stash(fornecedores => [$fornecedores_rs->all],
              pager => $fornecedores_rs->pager,
              q => $c->req->params->{'q'},
              title_part => 'Listagem de Fornecedores');
}

sub adicionar :Local :Args(0) :FormConfig('fornecedores/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Adição de Fornecedor');
}

sub salvar :Chained('base') :PathPart('salvar') :Args(0) :FormConfig('fornecedores/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $fornecedor;
        if ($c->req->params->{id}) {
            $fornecedor = $c->stash->{resultset}->find( $c->req->params->{id} );
        }
        else {
            $fornecedor = $c->stash->{resultset}->new_result({});
        }

        $form->model->update($fornecedor);
        $c->flash->{msg_ok} = 'Fornecedor salvo.';
        $c->res->redirect($c->uri_for('/fornecedores/listar'));
    } else {
        $c->stash->{template} = 'fornecedores/adicionar.tt';
        $c->flash->{msg_erro} = 'Erro na inserção.'
    }
}

sub ver :Chained('object') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Visualização de Fornecedor');
}

sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('fornecedores/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash->{form}->model->default_values( $c->stash->{object} );
    $c->stash(title_part => 'Edição de Fornecedor');
}

sub deletar :Chained('object') :PathPart('deletar') :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{object}->delete;
    $c->stash->{msg_ok} = 'Fornecedor deletado.';
    $c->res->redirect( $c->uri_for('/fornecedor/listar') );
}

=head1 AUTHOR

Astux L<astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
