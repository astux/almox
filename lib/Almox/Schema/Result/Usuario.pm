package Almox::Schema::Result::Usuario;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("PassphraseColumn");

__PACKAGE__->table("usuarios");

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "usuarios_id_seq",
  },
  "nome_de_usuario",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "senha",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "ativacao",
  { data_type => "boolean", is_nullable => 1 },
  'nome',
  { data_type => 'varchar' }
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "usuarios_perfis",
  "Almox::Schema::Result::UsuarioPerfil",
  { "foreign.usuario_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many('perfis', 'usuarios_perfis' => 'perfil');

__PACKAGE__->meta->make_immutable;

1;
