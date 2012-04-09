package Almox::Schema::Result::SolicitacaoItem;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table('solicitacoes_itens');

__PACKAGE__->add_columns(
                         'id' => { data_type => 'integer' },
                         'solicitacao_id' => { data_type => 'integer' },
                         'item_id' => { data_type => 'integer' },
                         'quantidade' => { data_type => 'integer' },
                         't_created' => { data_type => 'datetime', set_on_create => 1 },
                         't_updated' => { data_type => 'datetime', set_on_create => 1, set_on_update => 1 }
                        );
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('solicitacao', 'Almox::Schema::Result::Solicitacao', 'solicitacao_id');
__PACKAGE__->belongs_to('item', 'Almox::Schema::Result::Item', 'item_id');

__PACKAGE__->meta->make_immutable;

1;
