package Almox::Controller::Movimentacoes;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;
use DateTime;
BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

sub object :Chained('/') :PathPart('movimentacoes') :CaptureArgs(1) {
    my ($self, $c, $movimentacao_id) = @_;

    eval {
        $c->stash->{object} = $c->model('DB::Movimentacao')->find($movimentacao_id);
    } or do {
        $c->flash->{msg_erro} = 'Não foi possível encontrar o item referenciado.';
        $c->res->redirect($c->uri_for('/movimentacoes/listar'));
    }
}

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->res->redirect($c->uri_for('/movimentacoes/listar'));
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

    if ($c->req->params->{data_inicio}) {
        $mi_rs = $mi_rs->search_rs({ 'movimentacao.t_updated' => { '>=' => $c->req->params->{data_inicio} . ' 00:00:00' } });
    }

    if ($c->req->params->{data_fim}) {
        $mi_rs = $mi_rs->search_rs({ 'movimentacao.t_updated' => { '<=' => $c->req->params->{data_fim} . ' 23:59:59' } });
    }

    $c->stash(movimentacoes_itens => [$mi_rs->all],
              pager => $mi_rs->pager,
              title_part => 'Listagem de Movimentações');
}



sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('movimentacoes/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    $self->preenche_setores_origem_form($c, $form);

    $form->model->default_values( $c->stash->{object} );
    $c->stash->{title_part} = 'Edição de Movimentação';
}

sub adicionar :Local :Args(0) :FormConfig('movimentacoes/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    $c->stash(title_part => 'Adição de Movimentação');
}

sub salvar :Local :Args(0) :FormConfig('movimentacoes/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $salvar_sub = sub {
            my $movimentacao;

            if ($c->req->params->{id}) {
                $movimentacao = $c->model('DB::Movimentacao')->find($c->req->params->{id});
            }
            else {
                $movimentacao = $c->model('DB::Movimentacao')->new_result({
                                                                           usuario_id => $c->user->id
                                                                          });
            }

            my $datetime = DateTime->now->set_time_zone('America/Fortaleza');
            $movimentacao->t_updated($datetime->dmy("/") . " " . $datetime->hms(":"));

            $form->model->update($movimentacao);
        };

        my $schema = $c->model('DB::Movimentacao')->result_source->schema;

        eval {
            $schema->txn_do($salvar_sub);

            $c->flash->{msg_ok} = 'Movimentação salva.';
            $c->res->redirect( $c->uri_for('/movimentacoes/listar') );
        } or do {
            $c->flash->{msg_erro} = 'Erro na inserção. ' . $@;
            $c->stash->{template} = 'movimentacoes/adicionar.tt';
        };
    }
    else {
        $c->flash->{msg_erro} = 'Erro na inserção.';
        $c->stash->{template} = 'movimentacoes/adicionar.tt';
    }
}

sub ver :Chained('object') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{title_part} = 'Visualização de Movimentação';
}

__PACKAGE__->meta->make_immutable;

1;
