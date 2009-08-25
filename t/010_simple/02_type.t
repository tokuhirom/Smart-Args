use strict;
use warnings;
use args;
use Test::More;
use Test::Exception;

lives_ok { foo(foo => 3) }; # yutori is good
is foo(foo => 3), 6;
throws_ok { foo(foo => 3.14) } qr/Validation failed for 'Int' failed with value 3.14/;
done_testing;
exit;

sub foo {
    args my $foo => 'Int';
    $foo*2;
}
