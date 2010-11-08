#!perl -w
use strict;
use Test::More;
use Smart::Args;
my $warn = '';
local $SIG{__WARN__} = sub {
    $warn .= "@_";
};

sub foo {
    args my $bar, my $baz;
}

foo(bar => 1, baz => 2);
is $warn, '';

$warn = '';
foo(bar => 1, baz => 2, qux => 3);
like $warn, qr/unknown arguments: qux/;

$warn = '';
foo(bar => 1, baz => 2, aaa => 3, bbb => 4);
like $warn, qr/unknown arguments: aaa, bbb/;


sub bar {
    use warnings FATAL => 'void';
    args my $baz;
}

eval {
    bar( baz => 1, qux => 2 );
};
like $@, qr/unknown arguments: qux/;

done_testing;

