use strict;
use warnings;
use Test::More;


use Catalyst::Test 'PhoenixAPI';
use PhoenixAPI::Controller::Article;

ok( request('/article')->is_success, 'Request should succeed' );
done_testing();
