package Almox::Controller::Auth;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub login :Local :Args(0) {
    my ( $self, $c ) = @_;
}

sub login_do :Local :Args(0) {
    my ( $self, $c ) = @_;

    my $username = $c->req->params->{nome_de_usuario};
    my $password = $c->req->params->{senha};

    if ( $c->authenticate({ nome_de_usuario => $username, senha => $password }) ) {
        $c->res->redirect( $c->uri_for('/') );
    }
    else {
        $c->flash->{msg_erro} = 'Usuário/senha não válidos.';
        $c->res->redirect( $c->uri_for('/auth/login') );
    }
}

sub logout :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->logout;
    $c->res->redirect( $c->uri_for('/auth/login') );
}

=head1 AUTHOR

Astux

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
