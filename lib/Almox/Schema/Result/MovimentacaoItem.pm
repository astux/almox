package Almox::Schema::Result::MovimentacaoItem;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

__PACKAGE__->table("movimentacoes_itens");

__PACKAGE__->add_columns(
                         id => { data_type => 'integer' },
                         movimentacao_id  => { data_type => 'integer' },
                         item_id  => { data_type => 'integer' },
                         quantidade  => { data_type => 'integer' },
                         tombamento => { data_type => 'varchar', is_nullable => 1 }
                        );

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('movimentacao',
                      'Almox::Schema::Result::Movimentacao',
                      { 'foreign.id' => 'self.movimentacao_id' });
__PACKAGE__->belongs_to('item',
                      'Almox::Schema::Result::Item',
                      { 'foreign.id' => 'self.item_id' });

__PACKAGE__->meta->make_immutable;

1;
