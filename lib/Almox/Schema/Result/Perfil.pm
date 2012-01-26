package Almox::Schema::Result::Perfil;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table('perfis');
__PACKAGE__->add_columns(qw/id nome/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->meta->make_immutable;

1;
