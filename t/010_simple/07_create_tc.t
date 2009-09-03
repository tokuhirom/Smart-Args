use strict;
use warnings;
use args;
use Test::More;
use Test::Exception;


sub foo{
    args my $x => "ArrayRef[Int]";
    return $x;
}

lives_and{
    is_deeply foo(x => [10]), [10];
};

throws_ok{
    foo(x => { foo => 42 });
} qr/Validation failed/;

throws_ok{
    foo(x => [3.14]);
} qr/Validation failed/;


done_testing;
