package Almox::Schema::Result::Solicitacao;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table('solicitacoes');

__PACKAGE__->add_columns(
                         'id' => { data_type => 'integer' },
                         'solicitacao_status_id' => { data_type => 'integer' },
                         'usuario_id' => { data_type => 'integer' },
                         'anotacoes' => { data_type => 'text' },
                         'setor_id' => { data_type => 'integer' },
                         't_created' => { data_type => 'datetime', set_on_create => 1 },
                         't_updated' => { data_type => 'datetime', set_on_create => 1, set_on_update => 1 }
                        );

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('solicitacao_status', 'Almox::Schema::Result::SolicitacaoStatus', 'solicitacao_status_id');
__PACKAGE__->belongs_to('usuario', 'Almox::Schema::Result::Usuario', 'usuario_id');
__PACKAGE__->belongs_to('setor', 'Almox::Schema::Result::Setor', 'setor_id');

__PACKAGE__->has_many('solicitacoes_itens',
                      'Almox::Schema::Result::SolicitacaoItem',
                      { 'foreign.solicitacao_id' => 'self.id' });
__PACKAGE__->many_to_many('itens', 'solicitacoes_itens', 'item');

__PACKAGE__->meta->make_immutable;

1;
