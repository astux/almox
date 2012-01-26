use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Almox';
use Almox::Controller::Estoque;

ok( request('/estoque')->is_success, 'Request should succeed' );
done_testing();
