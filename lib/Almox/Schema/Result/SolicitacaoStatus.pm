package Almox::Schema::Result::SolicitacaoStatus;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table('solicitacao_status');

__PACKAGE__->add_columns(
                         'id', { data_type => 'integer' },
                         'nome', { data_type => 'varchar' },
                         'ativacao', { data_type => 'boolean' },
                        );
__PACKAGE__->set_primary_key("id");
__PACKAGE__->meta->make_immutable;

1;
