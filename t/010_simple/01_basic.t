use strict;
use warnings;
use args;
use Test::More;

foo(pi => 3.14);
done_testing;
exit;

sub foo {
    my $pi; # XXX
    args $pi;
    is $pi, 3.14;
}
