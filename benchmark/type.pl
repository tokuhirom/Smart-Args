#!perl -w
use strict;
use Benchmark qw(:all);

use Params::Validate qw(:all);
use Smart::Args;

foreach my $mod (qw(Params::Validate Smart::Args)) {
    print $mod, "/", $mod->VERSION, "\n";
}

sub pv_add {
    my %args = validate( @_ =>
        {
            x => { type => SCALAR },
            y => { type => SCALAR },
        });
    return $args{x} + $args{y};
}

sub sa_add {
    args my $x => 'Value', my $y => 'Value';
    return $x + $y;
}

sub sa_isa_add {
    args my $x => { isa => 'Value' }, my $y => { isa => 'Value' };
    return $x + $y;
}

print "with type constraints: SCALAR / Value\n";
cmpthese -1, {
    'P::Validate' => sub {
        foreach my $i(1 .. 100) {
            my $x = pv_add({ x => $i, y => $i });
            $x == ($i * 2) or die $x;
        };
    },
    'S::Args' => sub {
        foreach my $i(1 .. 100) {
            my $x = sa_add({ x => $i, y => $i });
            $x == ($i * 2) or die $x;
        }
    },
    'S::Args/isa' => sub {
        foreach my $i(1 .. 100) {
            my $x = sa_isa_add({ x => $i, y => $i });
            $x == ($i * 2) or die $x;
        }
    },
};

