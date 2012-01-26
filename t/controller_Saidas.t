use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Almox';
use Almox::Controller::Saidas;

ok( request('/saidas')->is_success, 'Request should succeed' );
done_testing();
