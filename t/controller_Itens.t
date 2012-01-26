use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Almox';
use Almox::Controller::Itens;

ok( request('/itens')->is_success, 'Request should succeed' );
done_testing();
