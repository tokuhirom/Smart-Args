use strict;
use warnings;
use args;
use Test::More;
use Test::Exception;

{
    package Foo;
    use Mouse;
    use args;
    sub class_method {
	args my $class,
	     my $ppp => 'Str';
	return "CLASS_METHOD: $class, $ppp";
    }
    sub instance_method {
	args my $self,
	     my $ppp => 'Str';
	return sprintf("INSTANCE_METHOD: %s, $ppp", ref($self));
    }
}

is( Foo->class_method(ppp => "YAY"), "CLASS_METHOD: Foo, YAY");
is(Foo->new->instance_method(ppp => "PEY"), "INSTANCE_METHOD: Foo, PEY");
done_testing;
