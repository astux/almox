package Almox::Controller::Estoque;
use Moose;
use namespace::autoclean;
use utf8;
BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

sub base : Chained('/') PathPart('estoque') CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::Estoque');
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $object_id) = @_;
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect( $c->uri_for('/estoque/geral') );
}

sub geral :Chained('base') :PathPart('geral') :Args(0) :FormConfig {
    my ($self, $c) = @_;

    my $entries_per_page = 20;
    $c->req->params->{page} ||= 1;

    my $estoque_rs = $c->stash->{resultset}
      ->search_rs({ nome => { ilike => "%" . $c->req->params->{'q'}  . "%" } })
        ->page( $c->req->params->{page}  );

    $c->stash->{form}->default_values({ q => $c->req->params->{'q'} });

    $c->stash(title_part => 'Estoque',
              estoque => [$estoque_rs->all],
              pager => $estoque_rs->pager);
}

=head1 AUTHOR

Astux L<astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
