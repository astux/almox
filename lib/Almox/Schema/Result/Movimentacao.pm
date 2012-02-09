package Almox::Schema::Result::Movimentacao;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table("movimentacoes");

__PACKAGE__->add_columns(
                         'id' => { data_type => 'integer',  },
                         origem_setor_id => { data_type => 'integer', is_nullable => 1 },
                         destino_setor_id  => { data_type => 'integer' },
                         nota_fiscal  => { data_type => 'varchar' },
                         empenho  => { data_type => 'varchar' },
                         t_created  => { data_type => 'datetime', set_on_create => 1 },
                         t_updated => { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
                         usuario_id  => { data_type => 'integer' },
                         fornecedor_id  => { data_type => 'integer' }
                        );

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to('usuario',
                        'Almox::Schema::Result::Usuario',
                        { 'foreign.id' => 'self.usuario_id' });
__PACKAGE__->belongs_to('fornecedor',
                        'Almox::Schema::Result::Fornecedor',
                        { 'foreign.id' => 'self.fornecedor_id' });
__PACKAGE__->belongs_to('setor_origem',
                        'Almox::Schema::Result::Setor',
                        { 'foreign.id' => 'self.origem_setor_id' },
                        { join_type => 'left' });
__PACKAGE__->belongs_to('setor_destino',
                        'Almox::Schema::Result::Setor',
                        { 'foreign.id' => 'self.destino_setor_id' });
__PACKAGE__->has_many('movimentacoes_itens',
                      'Almox::Schema::Result::MovimentacaoItem',
                      { 'foreign.movimentacao_id' => 'self.id' });
__PACKAGE__->many_to_many('itens' => 'movimentacoes_itens', 'item');

__PACKAGE__->resultset_class('Almox::Schema::ResultSet::Movimentacao');

__PACKAGE__->meta->make_immutable;

1;
