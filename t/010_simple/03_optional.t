use strict;
use warnings;
use args;
use Test::More;
use Test::Exception;

is foo(p => 3, q => 2), 3;
is foo(q => 2), 2;
throws_ok {foo(p => 2)} qr/missing mandatory parameter named '\$q'/;

done_testing;
exit;

sub foo {
    my $p;
    my $q; # XXX
    args $p => { is => 'Int', optional => 1 },
         $q => { is => 'Int', };
    return $p ? $p : $q;
}
