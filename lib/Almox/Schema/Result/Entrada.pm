package Almox::Schema::Result::Entrada;

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

Almox::Schema::Result::Entrada

=cut

__PACKAGE__->table("entradas");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'entradas_id_seq'

=head2 quantidade

  data_type: 'integer'
  is_nullable: 1

=head2 nota_fiscal

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 data_entrada

  data_type: 'timestamp with time zone'
  is_nullable: 1

=head2 valor

  data_type: 'double precision'
  is_nullable: 1

=head2 empenho

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 fornecedor_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 usuario_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "entradas_id_seq",
  },
  "nota_fiscal",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "data_entrada",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "empenho",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "fornecedor_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "usuario_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 usuario

Type: belongs_to

Related object: L<Almox::Schema::Result::Usuario>

=cut

__PACKAGE__->belongs_to(
  "usuario",
  "Almox::Schema::Result::Usuario",
  { id => "usuario_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 fornecedor

Type: belongs_to

Related object: L<Almox::Schema::Result::Fornecedore>

=cut

__PACKAGE__->belongs_to(
  "fornecedor",
  "Almox::Schema::Result::Fornecedore",
  { id => "fornecedor_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 entradas_itens

Type: has_many

Related object: L<Almox::Schema::Result::EntradasIten>

=cut

__PACKAGE__->has_many(
  "entradas_itens",
  "Almox::Schema::Result::EntradasIten",
  { "foreign.entrada_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-11 15:18:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tsl3cOaQE2+r/1baZfEZKA

__PACKAGE__->many_to_many(itens => 'entradas_itens', 'item');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
