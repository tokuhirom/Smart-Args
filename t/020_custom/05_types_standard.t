use strict;
use warnings;
use Test::Requires { 'Types::Standard' => '1.0' };
use Smart::Args;
use Test::More;
use t::Util;
use Types::Standard qw(Int);
use Type::Tiny;
use Scalar::Util qw(looks_like_number);

lives_ok { foo(foo => 3) };
is foo(foo => 3), 6;
throws_ok { foo(foo => 3.14) } qr/Value "3.14" did not pass type constraint "Int"/;
done_testing;
exit;

sub foo {
    args my $foo => Int;
    $foo*2;
}

