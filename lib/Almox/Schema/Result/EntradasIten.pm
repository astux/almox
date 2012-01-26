package Almox::Schema::Result::EntradasIten;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

=head1 NAME

Almox::Schema::Result::EntradasIten

=cut

__PACKAGE__->table("entradas_itens");

__PACKAGE__->add_columns('id',
                         { data_type => 'integer',
                           is_nullable => 0,
                           is_auto_increment => 1,
                           sequence => 'entradas_itens_id_seq'
                         },
                         "entrada_id",
                         { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
                         "item_id",
                         { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
                         "quantidade", { data_type => 'integer' },
                         "valor_unitario", { data_type => 'integer' }
);
__PACKAGE__->set_primary_key('id');

=head1 RELATIONS

=head2 entrada

Type: belongs_to

Related object: L<Almox::Schema::Result::Entrada>

=cut

__PACKAGE__->belongs_to(
  "entrada",
  "Almox::Schema::Result::Entrada",
  { id => "entrada_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 item

Type: belongs_to

Related object: L<Almox::Schema::Result::Iten>

=cut

__PACKAGE__->belongs_to(
  "item",
  "Almox::Schema::Result::Iten",
  { id => "item_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-11 15:18:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SY2H92QUAInW5o0YKiigRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
