package Almox::Schema::Result::Item;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

__PACKAGE__->table("itens");

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "itens_id_seq",
  },
  "nome",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "descricao",
  { data_type => "text", is_nullable => 1 },
  "ativacao",
  { data_type => "boolean", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

=for lembrar

__PACKAGE__->has_many(
  "entradas_itens",
  "Almox::Schema::Result::EntradasIten",
  { "foreign.item_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

  { "foreign.item_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->many_to_many(entradas => 'entradas_itens', 'entrada');
__PACKAGE__->many_to_many(saidas => 'saidas_itens', 'saida');

=cut

__PACKAGE__->meta->make_immutable;
1;
