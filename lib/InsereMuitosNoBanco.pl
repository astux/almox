use Almox::Schema;
use Data::Dumper;

$schema = Almox::Schema->connect('dbi:Pg:dbname=almox', 'almox', 'almox', { AutoCommit => 1 });

$iten_rs = $schema->resultset('Iten');

foreach (1..1_000) {
    print $_ . ' ' .
      $iten_rs->create({
                        nome => rand,
                        ativacao => 't'
                       })->id
                         . "\n";

}
