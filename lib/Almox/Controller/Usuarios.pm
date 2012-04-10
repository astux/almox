package Almox::Controller::Usuarios;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

sub auto :Private {
    my ($self, $c) = @_;

    unless ( $c->check_user_roles('administrador') ) {
        $c->flash->{msg_erro} = 'Você não tem permissão para a página que tentou acessar.';
        $c->res->redirect( $c->uri_for('/') );
    }
}

sub base :Chained('/') :PathPart('usuarios') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::Usuario');
}

sub object :Chained('/') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    eval {
        $c->stash->{object} = $c->stash->{resultset}->find($id);
    } or do {
        $c->flash->{msg_erro} = 'Não foi possível encontrar o usuário referenciado.';
        $c->res->redirect($c->uri_for('/usuarios'));
    };
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect($c->uri_for('/usuarios/listar'));
}

sub listar :Chained('base') :PathPart('listar') :Args(0) :FormConfig {
    my ( $self, $c ) = @_;

    my $entries_per_page = 20;
    my $page = $c->req->params->{page} || 1;

    my $usuarios_rs = $c->stash->{resultset}->search_rs(undef,
                                                        {
                                                         rows => $entries_per_page,
                                                         order_by => 'me.nome_de_usuario'
                                                        })
      ->page($page);

    $c->stash(usuarios => [$usuarios_rs->all],
              pager => $usuarios_rs->pager,
              title_part => 'Listagem de Usuários');
}

sub ver :Chained('object') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
}

sub adicionar :Local :Args(0) {
    my ( $self, $c ) = @_;
}

sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('usuarios/formulario.yml') {
    my ( $self, $c ) = @_;
}

sub salvar :Chained('base') :PathPart('salvar') :Args(0) :FormConfig('usuarios/formulario.yml') {
    my ( $self, $c ) = @_;
}

sub deletar :Chained('object') :PathPart('deletar') :Args(0) {
    my ( $self, $c ) = @_;
}

=head1 AUTHOR

Astux L<astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
