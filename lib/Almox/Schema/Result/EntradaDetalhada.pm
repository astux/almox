package Almox::Schema::Result::EntradaDetalhada;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table("entradas_detalhadas");

__PACKAGE__->add_columns(
  "entrada_id",
  { data_type => "integer", is_nullable => 1 },
  "quantidade",
  { data_type => "integer", is_nullable => 1 },
  "nota_fiscal",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "data_entrada",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "valor_unitario",
  { data_type => "double precision", is_nullable => 1 },
  'valor_total',
  { data_type => 'double precision', is_nullable => 1 },
  "empenho",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },

  "item_id",
  { data_type => "integer", is_nullable => 1 },
  "item_nome",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "item_descricao",
  { data_type => "text", is_nullable => 1 },
  "item_marca",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "item_ativacao",
  { data_type => "boolean", is_nullable => 1 },

  "fornecedor_id",
  { data_type => "integer", is_nullable => 1 },
  "fornecedor_nome",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "fornecedor_ativacao",
  { data_type => "boolean", is_nullable => 1 },
  'usuario_nome', { data_type => 'text' },
  'nome_de_usuario', { data_type => 'text' },
  'usuario_ativacao', { data_type => 'boolean' },
);

__PACKAGE__->meta->make_immutable;

1;
