package Almox::Schema::Result::Saida;

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

Almox::Schema::Result::Saida

=cut

__PACKAGE__->table("saidas");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'saidas_id_seq'

=head2 quantidade

  data_type: 'integer'
  is_nullable: 1

=head2 data_saida

  data_type: 'timestamp with time zone'
  is_nullable: 1

=head2 usuario_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 setor_id

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
    sequence          => "saidas_id_seq",
  },
  "quantidade",
  { data_type => "integer", is_nullable => 1 },
  "data_saida",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "usuario_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "setor_id",
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

=head2 setor

Type: belongs_to

Related object: L<Almox::Schema::Result::Setore>

=cut

__PACKAGE__->belongs_to(
  "setor",
  "Almox::Schema::Result::Setore",
  { id => "setor_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 saidas_itens

Type: has_many

Related object: L<Almox::Schema::Result::SaidasIten>

=cut

__PACKAGE__->has_many(
  "saidas_itens",
  "Almox::Schema::Result::SaidasIten",
  { "foreign.saida_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-11 15:18:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DizzN0FZ/PHsJL5ETKZrWA

__PACKAGE__->many_to_many(itens => 'saidas_itens', 'item');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
