package Almox::Controller::Itens;
use Moose;
use namespace::autoclean;
use utf8;
use Data::Dumper;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

sub base :Chained('/') :PathPart('itens') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{resultset} = $c->model('DB::Item');
}

sub object :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $item_id) = @_;

    eval {
        $c->stash->{object} = $c->stash->{resultset}->find($item_id);
    } or do {
        $c->flash->{msg_erro} = 'Não foi possível encontrar o item referenciado.';
        $c->res->redirect($c->uri_for('/itens/listar'));
    };
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect($c->uri_for('/itens/listar'));
}

sub listar :Chained('base') :PathPart('listar') :Args(0) :FormConfig {
    my ( $self, $c ) = @_;

    my $page = $c->req->params->{page} || 1;
    my $entries_per_page = 20;

    my $itens_rs = $c->stash->{resultset}
      ->search_rs(undef,
                  { "order_by" => "id", rows => $entries_per_page })
      ->page($page);

    if ($c->req->params->{'ativacao'}) {
        $itens_rs = $itens_rs->search_rs({ ativacao => $c->req->params->{'ativacao'} });
    }

    if ($c->req->params->{'q'}) {
        $itens_rs = $itens_rs->search_rs({
                                          nome => { ilike => "%" . $c->req->params->{'q'} . "%" }
                                         });
    }

    $c->stash->{form}->default_values({ q => $c->req->params->{'q'},
                                        ativacao => $c->req->params->{'ativacao'} });

    $c->stash(itens => [$itens_rs->all],
              pager => $itens_rs->pager,
              title_part => 'Listagem de Itens');
}

sub ver :Chained('object') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Visualização de Item');
}

sub adicionar :Local :Args(0) :FormConfig('itens/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash(title_part => 'Adição de Item');
}

sub editar :Chained('object') :PathPart('editar') :Args(0) :FormConfig('itens/formulario.yml') {
    my ($self, $c) = @_;

    $c->stash->{form}->model->default_values( $c->stash->{object} );
    $c->stash(title_part => 'Edição de Item');
}

sub salvar :Chained('base') :PathPart('salvar') :Args(0) :FormConfig('itens/formulario.yml') {
    my ($self, $c) = @_;

    my $form = $c->stash->{form};

    if ($form->submitted_and_valid) {
        my $item;

        if ($c->req->params->{id}) {
            eval {
                $item = $c->stash->{resultset}->find( $c->req->params->{id} )
            } or do {
                $c->flash->{msg_erro} = 'Não foi possível encontrar o item referenciado.';
                $c->res->redirect($c->uri_for('/itens/listar'));
            };
        }
        else {
            $item = $c->stash->{resultset}->new_result({});
        }

        eval {
            $form->model->update($item);
        } or do {
            $c->flash->{msg_erro} = 'Erro na inserção. ' . $@;
            $c->res->redirect($c->uri_for('/itens/listar'));
        };

        $c->flash->{msg_ok} = 'Item salvo.';
        $c->res->redirect($c->uri_for('/itens/listar'));
    } else {
        $c->stash->{template} = 'itens/adicionar.tt';
        $c->flash->{msg_erro} = 'Erro na inserção.'
    }
}

sub deletar :Chained('object') :PathPart('deletar') :Args(0) {
    my ($self, $c) = @_;

    eval {
        $c->stash->{object}->delete;
    } or do {
        $c->flash->{msg_erro} = 'Erro na deleção. ' . $@;
        $c->res->redirect($c->uri_for('/itens/listar'));
    };

    $c->stash->{msg_ok} = 'Item deletado.';
    $c->res->redirect( $c->uri_for('/itens/listar') );
}

=head1 AUTHOR

Astux L<astux.com.br>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
