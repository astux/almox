package Almox::Schema::Result::Estoque;

use Moose;

extends 'DBIx::Class::Core';

__PACKAGE__->table('estoque');
__PACKAGE__->add_columns(qw/id nome total/);
__PACKAGE__->set_primary_key('id');

1;
