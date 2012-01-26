use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Almox';
use Almox::Controller::Usuarios;

ok( request('/usuarios')->is_success, 'Request should succeed' );
done_testing();
