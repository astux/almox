package Almox::Schema::Result::SaidaDetalhada;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table("saidas_detalhadas");

__PACKAGE__->add_columns('saida_id', { data_type => 'integer' },
                         'data_saida', { data_type => 'timestamp with time zone' },
                         'usuario_id',  { data_type => 'integer' },
                         'setor_id', { data_type => 'integer' },
                         'item_id', { data_type => 'integer' },
                         'quantidade', { data_type => 'double precision' },
                         'item_nome', { data_type => 'text' },
                         'item_descricao', { data_type => 'text' },
                         'item_marca', { data_type => 'text' },
                         'item_ativacao', { data_type => 'boolean' },
                         'usuario_nome', { data_type => 'text' },
                         'nome_de_usuario', { data_type => 'text' },
                         'usuario_ativacao', { data_type => 'boolean' },
                         'setor_nome', { data_type => 'text' },
                         'setor_ativacao', { data_type => 'boolean' });

__PACKAGE__->meta->make_immutable;

1;
