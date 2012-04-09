package Almox::Schema::Result::Perfil;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table("perfis");

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "perfis_id_seq",
  },
  "nome",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "usuarios_perfis",
  "Almox::Schema::Result::UsuarioPerfil",
  { "foreign.perfil_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many('usuarios', 'usuarios_perfis' => 'usuario');

__PACKAGE__->meta->make_immutable;

1;
