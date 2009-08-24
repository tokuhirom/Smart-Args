package args;
use strict;
use warnings;
our $VERSION = '0.01';
use PadWalker ();
use Smart::Comments;
use Scalar::Util qw/refaddr/;
use Exporter 'import';
use Mouse::Util::TypeConstraints;
use Carp::Assert;

our @EXPORT = qw/args/;
# our @EXPORT = qw/args MODIFY_SCALAR_ATTRIBUTES/;

my $compiled_rules;

sub args {
    my $args = do {
        my @args = do {
            package DB;
            my @c = caller(1);
            @DB::args;
        };
        if (ref $args[0] && @args == 1) {
            $args[0];
        } else {
            if (@args%2 == 0) {
                +{@args};
            } else {
                Carp::croak("oops");
            }
        }
    };

    for (my $i=0; $i<@_; $i+=2) {
        my $rule = compile_rule($_[$i+1]);
        my $var_name = PadWalker::var_name(1,\$_[$i]);
        assert($var_name);
        (my $name = $var_name) =~ s/^\$//;
        if (! exists $args->{$name} && ! $rule->{optional}) {
            Carp::croak("missing mandatory parameter named '$var_name'");
        }
        if (exists $args->{$name} && defined $rule->{type}) {
            unless ($rule->{type}->check($args->{$name})) {
                Carp::croak($rule->{type}->get_message($args->{$name}));
            }
        }
        $_[$i] = $args->{$name};
    }
}

sub compile_rule {
    my ($rule) = @_;
    if (!defined $rule) {
        return +{ }
    } if (!ref $rule) {
        +{ type => Mouse::Util::TypeConstraints::find_type_constraint($rule) };
    } else {
        my $ret = +{ };
        if ($rule->{is}) {
            $ret->{type} = Mouse::Util::TypeConstraints::find_type_constraint($rule->{is});
        }
        if ($rule->{optional}) {
            $ret->{optional}++;
        }
        return $ret;
    }
}

1;
__END__

=head1 NAME

args - proof of concept

=head1 SYNOPSIS

  use args;
  sub func {
    argsp my $p => 'Int';
  }
  func(3);

  sub func2 {
    args my $p => 'Int',
         my $q => { is => 'Int', optional => 1 };
  }
  func2(p => 3, q => 4); # p => 3, q => 4
  func2(p => 3);         # p => 3, q => undef

  sub func3 {
    args my $p => {is => 'Int', default => 3},
  }
  func3(p => 4); # p => 4
  func3();       # p => 4

  package F;
  use Moose;
  sub method {
    args my $self,
         my $p => 'Int';
  }
  sub class_method {
    args my $class,
         my $p => 'Int';
  }

  my $f = F->new();
  $f->method(p => 3);

  F->class_method(p => 3);

=head1 DESCRIPTION

args is

=head1 TODO

coercion support?

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

L<http://rt.cpan.org/Public/Bug/Display.html?id=48944>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut