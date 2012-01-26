package Almox::View::Web;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    WRAPPER => 'wrapper.tt',
    ENCODING => 'UTF-8'
);

=head1 NAME

Almox::View::Web - TT View for Almox

=head1 DESCRIPTION

TT View for Almox.

=head1 SEE ALSO

L<Almox>

=head1 AUTHOR

sgrs,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
