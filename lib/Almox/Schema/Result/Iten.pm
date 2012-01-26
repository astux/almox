package Almox::Schema::Result::Iten;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 NAME

Almox::Schema::Result::Iten

=cut

__PACKAGE__->table("itens");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'itens_id_seq'

=head2 nome

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 descricao

  data_type: 'text'
  is_nullable: 1

=head2 ativacao

  data_type: 'boolean'
  is_nullable: 1

=head2 marca

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=cut

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
  "marca",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 entradas_itens

Type: has_many

Related object: L<Almox::Schema::Result::EntradasIten>

=cut

__PACKAGE__->has_many(
  "entradas_itens",
  "Almox::Schema::Result::EntradasIten",
  { "foreign.item_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 saidas_itens

Type: has_many

Related object: L<Almox::Schema::Result::SaidasIten>

=cut

__PACKAGE__->has_many(
  "saidas_itens",
  "Almox::Schema::Result::SaidasIten",
  { "foreign.item_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-11 18:06:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5RrNNO7yT+05qP78GOxS8w

__PACKAGE__->many_to_many(entradas => 'entradas_itens', 'entrada');
__PACKAGE__->many_to_many(saidas => 'saidas_itens', 'saida');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
