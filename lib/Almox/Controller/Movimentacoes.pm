package Almox::Controller::Movimentacoes;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;
BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->req->redirect('/movimentacoes/listar');
}

sub listar :Local :Args(0) :FormConfig {
    my ($self, $c) = @_;

    my $entries_per_page = 20;
    my $page = $c->req->params->{page} || 1;

    my $mi_rs = $c->model('DB::MovimentacaoItem')->search_rs(undef,
                                                             {
                                                              prefetch => [ { 'movimentacao' => [qw/setor_destino setor_origem usuario fornecedor/] }, 'item'  ],
                                                              rows => $entries_per_page,
                                                              order_by => 'me.id'
                                                             })
      ->page($page);

    if ($c->req->params->{setor_origem}) {
        $mi_rs = $mi_rs->search_rs({ 'setor_origem.nome' => { ilike => '%' . $c->req->params->{setor_origem} . '%' } });
    }

    if ($c->req->params->{tombamento}) {
        $mi_rs = $mi_rs->search_rs({ 'me.tombamento' => { ilike => '%' . $c->req->params->{tombamento} . '%' } });
    }

    if ($c->req->params->{setor_destino}) {
        $mi_rs = $mi_rs->search_rs({ 'setor_destino.nome' => { ilike => '%' . $c->req->params->{setor_destino} . '%' } });
    }

    if ($c->req->params->{item}) {
        $mi_rs = $mi_rs->search_rs({ 'item.nome' => { ilike => '%' . $c->req->params->{item} . '%' } });
    }

    if ($c->req->params->{usuario}) {
        $mi_rs = $mi_rs->search_rs({ 'usuario.nome' => { ilike => '%' . $c->req->params->{usuario} . '%' } });
    }

    $c->stash(movimentacoes_itens => [$mi_rs->all],
              pager => $mi_rs->pager,
              title_part => 'Listagem de Movimentações');
}

sub adicionar :Local :Args(0) :FormConfig {
    my ($self, $c) = @_;

    my @setores = $c->model('DB::Setor')->search({ ativacao => 1})->all;

    my @setores_options;

    push @setores_options, [undef, 'Nenhum'];

    foreach (@setores) {
        push @setores_options, [$_->id, $_->nome];
    }

    my $form = $c->stash->{form};
    my $element = $form->get_element({ name => 'origem_setor_id'});
    $element->options(\@setores_options);

    $c->stash(title_part => 'Adição de Movimentação');
}

sub salvar :Local :Args(0) :FormConfig('movimentacoes/adicionar.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $movimentacao = $c->model('DB::Movimentacao')->new_result({
                                                                      usuario_id => $c->user->id
                                                                     });

        $form->model->update($movimentacao);
        $c->flash->{msg_ok} = 'Movimentação salva.';
        $c->res->redirect( $c->uri_for('/movimentacoes/listar') );
    }
    else {
        $c->flash->{msg_erro} = 'Erro na inserção.';
        $c->stash->{template} = 'movimentacoes/adicionar.tt';
    }
}

__PACKAGE__->meta->make_immutable;

1;
