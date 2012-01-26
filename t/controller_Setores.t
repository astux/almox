use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Almox';
use Almox::Controller::Setores;

ok( request('/setores')->is_success, 'Request should succeed' );
done_testing();
