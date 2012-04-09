package Almox::Controller::Solicitacoes;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

sub index :Path Args(0) {
    my ($self, $c) = @_;

    $c->res->redirect($c->uri_for('/solicitacoes/listar'));
}

sub base :Chained('/') PathPart('solicitacoes') CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::Solicitacao');
}

sub object :Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $solicitacao_id) = @_;

    eval {
        $c->stash->{object} = $c->stash->{resultset}->find($solicitacao_id);
    } or do {
        $c->flash->{msg_erro} = 'Não foi possível encontrar a solicitação referenciada.';
        $c->res->redirect($c->uri_for('/solicitacoes/listar'));
    }
}

sub adicionar :Local Args(0) FormConfig('solicitacoes/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    my $usuario_id_element = $form->get_element({ name => 'usuario_id' });
    $usuario_id_element->value($c->user->id);

    $c->stash(title_part => 'Adição de Solicitação');
}

sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('solicitacoes/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash->{form}->model->default_values( $c->stash->{object} );
    $c->stash(title_part => 'Edição de Solicitação');
}

sub ver :Chained('object') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Visualização de Solicitação');
}

sub deletar :Chained('object') :PathPart('deletar') :Args(0) {
    my ($self, $c) = @_;

    eval {
        $c->stash->{object}->delete;
    } or do {
        $c->flash->{msg_erro} = 'Erro na deleção. ' . $@;
        $c->res->redirect($c->uri_for('/solicitacoes/listar'));
    };

    $c->stash->{msg_ok} = 'Solicitação deletada.';
    $c->res->redirect( $c->uri_for('/solicitacoes/listar') );
}

sub listar :Chained('base') :PathPart('listar') :Args(0) :FormConfig {
    my ( $self, $c ) = @_;

    my $page = $c->req->params->{page} || 1;
    my $entries_per_page = 20;

    my $solicitacoes_rs = $c->stash->{resultset}
      ->search_rs(undef,
                  {
                   prefetch => [qw/setor solicitacao_status usuario/],
                   "order_by" => "me.id",
                   rows => $entries_per_page
                  })
        ->page($page);

    $c->stash(solicitacoes => [$solicitacoes_rs->all],
              pager => $solicitacoes_rs->pager,
              title_part => 'Listagem de Solicitações');
}

sub salvar :Chained('base') PathPart('salvar') FormConfig('solicitacoes/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $solicitacao;

        if ($c->req->params->{id}) {
            eval {
                $solicitacao = $c->stash->{resultset}->find( $c->req->params->{id} )
            } or do {
                $c->flash->{msg_erro} = 'Não foi possível encontrar a solicitação referenciada.';
                $c->res->redirect($c->uri_for('/solicitacoes/listar'));
            };
        }
        else {
            $solicitacao = $c->stash->{resultset}->new_result({});
        }

        eval {
            $c->model('DB::Solicitacao')->result_source->schema->txn_do(
                                                                        sub {
                                                                            $form->model->update($solicitacao);
                                                                        }
                                                                       );

            $c->flash->{msg_ok} = 'Solicitação salva.';
            $c->res->redirect($c->uri_for('/solicitacoes/listar'));
        } or do {
            $c->flash->{msg_erro} = 'Erro na inserção. ' . $@;
            $c->stash->{template} = 'solicitacoes/adicionar.tt';
        };
    } else {
        $c->stash->{template} = 'solicitacoes/adicionar.tt';
        $c->flash->{msg_erro} = 'Erro na inserção.'
    }
}

__PACKAGE__->meta->make_immutable;

1;
