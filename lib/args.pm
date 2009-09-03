package args;
use strict;
use warnings;
our $VERSION = '0.01_02';
use Exporter 'import';
use PadWalker qw/var_name/;

use Any::Moose;
use Any::Moose '::Util::TypeConstraints';

*_get_type_constraint = any_moose('::Util::TypeConstraints')->can('find_or_create_isa_type_constraint');

our @EXPORT = qw/args/;

my %is_invocant = map{ $_ => undef } qw($self $class);

sub args {
    {
        package DB;
        # call of caller in DB package sets @DB::args,
        # which requires list context, but does not use return values
        () = caller(1);
    }

    # method call
    if(exists $is_invocant{ var_name(1, \$_[0]) || '' }){
        $_[0] = shift @DB::args;
        shift;
        # XXX: should we provide ways to check the type of invocant?
    }

    my $args = ( @DB::args == 1 && ref($DB::args[0]) )
            ?    $DB::args[0]  # must be hash
            : +{ @DB::args };  # must be key-value list

    ### $args
    ### @_

    # args my $var => TYPE
    #         ~~~~    ~~~~
    #         undef   defined

    for(my $i = 0; $i < @_; $i++){

        (my $name = var_name(1, \$_[$i]))
            or  Carp::croak('usage: args my $var => TYPE, ...');

        ### $i
        ### $name

        $name =~ s/^\$//;

        my $rule = _compile_rule($_[$i+1]);

        if(exists $args->{$name}){
            if(my $tc = $rule->{type} ){
                if(!$tc->check($args->{$name})){
                    Carp::croak($tc->get_message($args->{$name}));
                }
            }

            $_[$i] = $args->{$name};
        }
        else{
            if(exists $rule->{default}){
                $_[$i] = $rule->{default};
            }
            elsif(!exists $rule->{optional}){
                Carp::croak("missing mandatory parameter named '\$$name'");
            }
            else{
                # noop
            }
        }
        $i++ if defined $_[$i+1]; # discard type info
    }
}

sub _compile_rule {
    my ($rule) = @_;
    if (!defined $rule) {
        return +{ };
    }
    elsif (!ref $rule) { # single, non-ref parameter is a type name
        my $tc = _get_type_constraint($rule) or Carp::croak("cannot find type constraint '$rule'");
        return +{ type => $tc };
    }
    else {
        my %ret;
        if ($rule->{isa}) {
            my $tc = _get_type_constraint($rule->{isa}) or Carp::croak("cannot find type constraint '$rule'");
            $ret{type} = $tc;
        }
        for my $key (qw/optional default/) {
            if (exists $rule->{$key}) {
                $ret{$key} = $rule->{$key};
            }
        }
        return \%ret;
    }
}

1;
__END__

=head1 NAME

args - argument validation for you

=head1 SYNOPSIS

  use args;

  sub func2 {
    args my $p => 'Int',
         my $q => { isa => 'Int', optional => 1 };
  }
  func2(p => 3, q => 4); # p => 3, q => 4
  func2(p => 3);         # p => 3, q => undef

  sub func3 {
    args my $p => {isa => 'Int', default => 3},
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

args is yet another argument validation library.
This module makes your module more readable, and writable =)

=head1 TODO

coercion support?

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

L<Params::Validate>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
