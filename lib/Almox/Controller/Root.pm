package Almox::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Almox::Controller::Root - Root Controller for Almox

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 auto

Cuida da rota do usuário, dependendo ele estar logado ou não etc.

=cut

sub auto :Private {
    my ( $self, $c ) = @_;

    if ($c->action eq 'auth/login' || $c->action eq 'auth/login_do') {
        return 1;
    }

    unless ($c->user_exists) {
        $c->res->redirect( $c->uri_for('/auth/login') );
        return 0;
    }

    return 1;
}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $movimentacoes_itens = $c->model('DB::MovimentacaoItem')->search_rs(undef,
                                                                           {
                                                                            prefetch => [ { 'movimentacao' => [qw/setor_destino setor_origem usuario fornecedor/] }, 'item'  ],
                                                                            rows => 10
                                                                           });

    $c->stash(movimentacoes_itens => [$movimentacoes_itens->all]);
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Astux

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
