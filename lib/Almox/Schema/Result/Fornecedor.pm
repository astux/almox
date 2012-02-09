package Almox::Schema::Result::Fornecedor;

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

Almox::Schema::Result::Fornecedore

=cut

__PACKAGE__->table("fornecedores");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'fornecedores_id_seq'

=head2 nome

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 ativacao

  data_type: 'boolean'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "fornecedores_id_seq",
  },
  "nome",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "ativacao",
  { data_type => "boolean", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 entradas

Type: has_many

Related object: L<Almox::Schema::Result::Entrada>

=cut

=for lembrar

__PACKAGE__->has_many(
  "entradas",
  "Almox::Schema::Result::Entrada",
  { "foreign.fornecedor_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=cut

# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-11 15:18:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qznk/SGH48weD7a9oCZZsw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
