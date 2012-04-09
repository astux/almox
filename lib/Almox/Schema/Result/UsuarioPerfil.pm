package Almox::Schema::Result::UsuarioPerfil;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table("usuarios_perfis");

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "perfis_id_seq",
  },
  "usuario_id",
  {
    data_type   => "int",
    is_nullable => 0,
  },
  "perfil_id",
  {
    data_type   => "integer",
    is_nullable => 0,
  },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
                        'usuario',
                        'Almox::Schema::Result::Usuario',
                        { 'foreign.id' => 'self.usuario_id' }
                       );

__PACKAGE__->belongs_to(
                        'perfil',
                        'Almox::Schema::Result::Perfil',
                        { 'foreign.id' => 'self.perfil_id' }
                       );

__PACKAGE__->meta->make_immutable;

1;
