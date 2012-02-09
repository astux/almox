use Almox;
use Data::Dumper;

eval { Almox->authenticate({ "nome_de_usuario" => 'admin',
                             "senha" => 'admin' }) }
  or print Dumper $@ . 'ewqeqw';

print $c->user;
