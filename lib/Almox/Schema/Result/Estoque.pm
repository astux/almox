package Almox::Schema::Result::Estoque;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table("estoque");

__PACKAGE__->add_columns(qw/setor_id setor_nome item_id item_nome quantidade/);
__PACKAGE__->set_primary_key('setor_id');

__PACKAGE__->meta->make_immutable;

1;
