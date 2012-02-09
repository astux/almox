package Almox::Schema::ResultSet::Movimentacao;
use base 'DBIx::Class::ResultSet';

sub historico_detalhado {
    my $self = shift;
    $self->search({},
                  { join => [qw/movimentacoes_itens/] });
}

1;
