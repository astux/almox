package Almox::Schema::Result::Usuario;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';



=head1 NAME

Almox::Schema::Result::Usuario

=cut

__PACKAGE__->table("usuarios");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'usuarios_id_seq'

=head2 nome_de_usuario

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 senha

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 ativacao

  data_type: 'boolean'
  is_nullable: 1

=cut

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
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 entradas

Type: has_many

Related object: L<Almox::Schema::Result::Entrada>

=cut

__PACKAGE__->has_many(
  "entradas",
  "Almox::Schema::Result::Entrada",
  { "foreign.usuario_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 saidas

Type: has_many

Related object: L<Almox::Schema::Result::Saida>

=cut

__PACKAGE__->has_many(
  "saidas",
  "Almox::Schema::Result::Saida",
  { "foreign.usuario_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-01-11 15:18:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FJ2yF9ZWuB0lfylz9/VE5g

__PACKAGE__->has_many(
  "usuarios_perfis",
  "Almox::Schema::Result::UsuarioPerfil",
  { "foreign.usuario_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many('perfis', 'usuarios_perfis' => 'perfil');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
