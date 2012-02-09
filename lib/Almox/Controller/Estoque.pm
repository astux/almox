package Almox::Controller::Estoque;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

sub index :Path :Args(0) :FormConfig {
    my ($self, $c) = @_;
    my $estoque_rs = $c->model('DB::Estoque');

    my $setor = $c->req->params->{setor};
    my $item = $c->req->params->{item};

    my $entries_per_page = 20;
    my $page = $c->req->params->{page} || 1;

    $estoque_rs = $estoque_rs->search_rs({
                                          setor_nome => { ilike => '%' . $setor . '%' },
                                          item_nome => { ilike => '%' . $item . '%' }
                                         },
                                         { order_by => 'setor_id', rows => $entries_per_page }
                                        )
      ->page($page);

    $c->stash(estoque => [$estoque_rs->all],
              pager => $estoque_rs->pager);
}

__PACKAGE__->meta->make_immutable;

1;
