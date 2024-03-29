package Almox;
use Moose;
use namespace::autoclean;
use utf8;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/-Debug
                ConfigLoader
                Static::Simple

                Unicode::Encoding

                Breadcrumbs

                Session
                Session::Store::FastMmap
                Session::State::Cookie

                Authentication
                Authorization::Roles
               /;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in almox.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
                    name => 'Almox',
                    # Disable deprecated behavior needed by old applications
                    disable_component_resolution_regex_fallback => 1,
                    enable_catalyst_header => 1,
                    breadcrumbs => {
                                    hide_index => 0,
                                    hide_home => 0,
                                    labels => {
                                               '/' => 'Início',
                                               '/movimentacoes' => 'Movimentações',
                                               '/solicitacoes' => 'Solicitações'
                                              }
                                   },
                    'Controller::HTML::FormFu' => {
                                                   model_stash => {
                                                                   schema => 'DB'
                                                                  }
                                                  },
                    default_model => 'DBIC', # Pesquisar. FormFu?
                    default_view => 'TT',
                    'Plugin::Authentication' => {
                                                 default => {
                                                             credential => {
                                                                            class => 'Password',
                                                                            password_type => 'clear',
                                                                            password_field => 'senha'
                                                                           },
                                                             store => {
                                                                       class => 'DBIx::Class',
                                                                       user_model => 'DB::Usuario',
                                                                       role_relation => 'perfis',
                                                                       role_field => 'nome'
                                                                      },
                                                            }
                                                },
                    'View::Wkhtmltopdf' => {
                                            command   => '/usr/bin/wkhtmltopdf',
                                            tmpdir    => '/tmp',
                                            stash_key => 'wkhtmltopdf'
                                           },
                   );

# Start the application
__PACKAGE__->setup();

=head1 NAME

Almox - Catalyst based application

=head1 SYNOPSIS

    script/almox_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Almox::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Astux L<http://astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
