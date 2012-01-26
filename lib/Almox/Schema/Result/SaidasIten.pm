package Almox::Schema::Result::SaidasIten;

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

Almox::Schema::Result::SaidasIten

=cut

__PACKAGE__->table("saidas_itens");

=head1 ACCESSORS

=head2 saida_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 item_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "saida_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "item_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("saida_id", "item_id");

=head1 RELATIONS

=head2 saida

Type: belongs_to

Related object: L<Almox::Schema::Result::Saida>

=cut

__PACKAGE__->belongs_to(
  "saida",
  "Almox::Schema::Result::Saida",
  { id => "saida_id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e5vw/tpHO7nd2uPT3QVq6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
