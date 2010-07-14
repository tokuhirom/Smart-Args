use strict;
use warnings;
use args;
use Test::More;
use Test::Exception;

{
    package Foo;
    use Mouse;
    use args;

    sub bar{
        args my $self, my $x, my $y => 'Int'; # omit to set the type of $x
        return($x, $y);
    }
}

my $foo = Foo->new;

lives_and{
    my($x, $y) = $foo->bar(x => 10, y => 20);

    is $x, 10;
    is $y, 20;

    ($x, $y) = $foo->bar(y => 20, x => 10);

    is $x, 10;
    is $y, 20;
};

throws_ok{
    $foo->bar(x => 10, y => 3.14);
} qr/Validation failed/;

throws_ok{
    $foo->bar(y => 10,);
} qr/missing mandatory parameter/;

done_testing;
