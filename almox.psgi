use strict;
use warnings;

use Almox;

my $app = Almox->apply_default_middlewares(Almox->psgi_app);
$app;

