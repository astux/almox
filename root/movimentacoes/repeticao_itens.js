/*

Sobre a adição e deleção de itens de uma movimentação

On document ready, pega o primeiro formulário de item da página carregada, clona,
limpa todos os campos e a copia fora do <form>. Essa cópia será a matriz que
gerará novos formulários de item quando o usuário clicar em "Adicionar
Novo Item".

Há uma particularidade na deleção. Para o sistema entender que um item
relacionado a uma movimentação está sendo deletado, ele deve ser submitado
com um campo (por exemplo, 'delete_item') tendo valor 'true', onde esse
campo, ao ser definido no .yml para o formfu, tem uma marcação específica,
como o exemplo que segue:

- type: Hidden
  name: delecao_de_item
  model_config:
    delete_if_true: 1

Notar a marcação "delete_if_true: 1".

Tendo em vista essa particularidade,
a deleção de item é feita da seguinte forma: quando o usuário clica no
botão "Remover Item", sistema vê se o item a ser removido tem "id".

Um item que acabou de ser adicionado ao formulário não terá "id", pois
ainda não foi submitado; já um item que aparece no formulário porque
o usuário está editando uma movimentação tem um "id" no banco -- ele
aparece automaticamente na hora da edição exatamente porque está no
banco.

Logo, ao pressionar o botão "Remover item", o sistema checa se o item
tem um id. Se tiver, o sistema não faz um .remove() na <div> que envolve
o item, mas apenas deixa-o "display: none". E marca seu campo de deleção
para "true". Na hora do submit então esse item vai ser deletado da
movimentação.

E, se o item a ser removido não tem id, o sistema simplesmente faz um
.remove() na <div> que envolve aquele item.

*/

$(document).ready(function() {
    var repeatable = $('.repeatable')[0];
    var cloned = $(repeatable).parent().clone(true).css('display', 'none');
    resetar_item(cloned);
    var form = $('form')[0];
    $(form).after(cloned);
});

// Resetar Item

function resetar_item(item) {
    $(item).find('[type="hidden"], [type="text"]').each(function(index, element) {
        $(element).removeAttr('value');
    });

    $(item).find('select option').each(function(index, element) {
        $(element).removeAttr('selected');
    });
}

// Adicionar Item
$('[name="adicionar_item"]').click(function() {
    increase_counter();
    var repeatable = $('.repeatable:last');
    var cloned = $(repeatable).parent().clone(true).css('display', 'block');

    $(cloned).find('input, select').each(function(index, element) {
        change_elements_name_number(element, $('[name="itens_counter"]')[0].value);
    });

    $('form fieldset:last').parent().after(cloned);

});

// Remover Item
$('[name$="remover_item"]').click(function() {
    /* TODO
       Checar se item a ser deletado tem id. Se tiver, seguir a documentação
       disposta no início do arquivo */
    if (decrease_counter()) {
        $(this).parent().parent().parent().remove();
        recount_repeatable();
    }
    else {
        alert('Há apenas um item. Não é possível deletá-lo.');
    }
});

// Após a deleção de um item do formulário,
// refaz os índices dos nomes dos elementos inputs e selects do formulário
function recount_repeatable() {
    $('form .repeatable').each(function(index, element) {
        $(element).find('input, select').each(function(i_index, i_element) {
            change_elements_name_number(i_element, index+1);
        });
    });
}

function change_elements_name_number(element, index) {
    var name = $(element).attr('name').replace(/\d+/, index);
    $(element).attr('name', name);
}

function increase_counter() {
    if ($('[name="itens_counter"]')[0].value) {
        $('[name="itens_counter"]')[0].value = parseInt($('[name="itens_counter"]')[0].value, 10) + 1
    }
    else {
        // Primeira vez que botão 'Adicionar Item' é pressionado, valor de contador é undefined.
        // Como botão foi pressionado pela primeira vez, contador = 2
        $('[name="itens_counter"]')[0].value = '2'
    }
}

function decrease_counter() {
    if ($('[name="itens_counter"]')[0].value == 1 || !$('[name="itens_counter"]')[0].value) {
        return false;
    }
    else if ($('[name="itens_counter"]')[0].value > 1) {
        $('[name="itens_counter"]')[0].value = parseInt($('[name="itens_counter"]')[0].value, 10) - 1
        return true;
    }
}
