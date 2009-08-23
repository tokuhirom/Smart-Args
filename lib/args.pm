package args;
use strict;
use warnings;
our $VERSION = '0.01';
use PadWalker ();
use Smart::Comments;
use Scalar::Util qw/refaddr/;
use Exporter 'import';
use Mouse::Util::TypeConstraints;

our @EXPORT = qw/args MODIFY_SCALAR_ATTRIBUTES/;

my $compiled_rules;

sub args {
    package DB;
    my @c = caller(1);
    my @args = @DB::args;
    my $args;
    if (ref $args[0] && @args == 1) {
        $args = $args[0];
    } else {
        if (@args%2 == 0) {
            $args = {@args};
        } else {
            Carp::croak("oops");
        }
    }
    my $upper_my = PadWalker::peek_my(1);
    for my $i (0..@_-1) {
        my $rule = $compiled_rules->{Scalar::Util::refaddr(\$_[$i])};
        my $var_name = PadWalker::var_name(1,\$_[$i]);
        (my $name = $var_name) =~ s/^\$//;
        for my $r (@$rule) {
            my $constraint = Mouse::Util::TypeConstraints::find_type_constraint($r);
            unless ($constraint->check($args->{$name})) {
                Carp::croak($constraint->get_message($args->{$name}));
            }
        }
        ${$upper_my->{PadWalker::var_name(1, \$_[$i])}} = $args->{$name};
    }
}

sub MODIFY_SCALAR_ATTRIBUTES {
    my ($pkg, $ref, @attrs) = @_;
    $compiled_rules->{refaddr($ref)} = \@attrs;
    return;
}

1;
__END__

=head1 NAME

args - proof of concept

=head1 SYNOPSIS

  use args;
  sub func {
    argsp my $p:Int;
  }
  func(3);

  sub func2 {
    args my $p:Int,
         my $q:Int :Optional;
  }
  func2(p => 3, q => 4); # p => 3, q => 4
  func2(p => 3);         # p => 3, q => undef

  package F;
  use Moose;
  sub method {
    args my $self,
         my $p: Int;
  }

  my $f = F->new();
  $f->method(p => 3);

=head1 DESCRIPTION

args is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

L<http://rt.cpan.org/Public/Bug/Display.html?id=48944>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
