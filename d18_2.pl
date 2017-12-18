#! /usr/bin/env perl
# Advent of Code 2017 Day 18 - part 2
# Problem link: http://adventofcode.com/2017/day/18
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d18
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test2.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $debug   = 0;
my @program = (
    {
        registers => { p => 0 },
        queue     => [],
    },
    {
        registers => { p => 1 },
        queue     => [],
    },
);

while (@input) {
    my @atoms = split( /\s+/, shift @input );
    for ( 0, 1 ) {
        push @{ $program[$_]->{ins} }, \@atoms;
    }
}

sub value_of;
sub dump_registers;
my %action = (
    set => \&set_register,
    snd => \&send_value,
    add => \&add_to_register,
    mul => \&multiply_register,
    mod => \&divmod_register,
    rcv => \&receive_value,
    jgz => \&jump_gt_zero,
);

my @pos = ( 0, 0 );

while ( ( $pos[0] >= 0 and $pos[1] >= 0 )
    and ( $pos[0] <= scalar @{ $program[0]->{ins} } - 1 )
    and ( $pos[1] <= scalar @{ $program[1]->{ins} } - 1 ) )
{
    my @compare = @pos;
    for my $p ( 0, 1 ) {
        my ( $cmd, $arg1, $arg2 ) = @{ $program[$p]->{ins}->[ $pos[$p] ] };
        my $ret = $action{$cmd}->( $arg1, $arg2, $p );
        $pos[$p] = $pos[$p] + $ret;
        if ($debug) {
            print "    $p: ";
            dump_registers($p);

        }
    }
    if ( $compare[0] == $pos[0] and $compare[1] == $pos[1] ) {
        last;
    }
}

say "2. number of messages sent by program 1: ",$program[1]->{sends};

###############################################################################
sub dump_registers {
    my ($p) = @_;
    for my $k ( sort { $a cmp $b } keys %{ $program[$p]->{registers} } ) {
        print "$k => $program[$p]->{registers}->{$k} ";
    }
    print "\n";
}

sub value_of {
    my ( $x, $p ) = @_;
    my $val;
    if ( exists $program[$p]->{registers}->{$x} ) {
        $val = $program[$p]->{registers}->{$x};
    }
    else {
        $val = $x;
    }
    return $val;
}

sub send_value {
    my ( $x, $dummy, $p ) = @_;
    my $rec = ( $p == 1 ? 0 : 1 );
    my $msg = value_of( $x, $p );
    push @{ $program[$rec]->{queue} }, $msg;
    say "==> $p sends $msg to $rec" if $debug;
    $program[$p]->{sends}++;
    return 1;
}

sub set_register {
    my ( $x, $y, $p ) = @_;
    $program[$p]->{registers}->{$x} = value_of( $y, $p );
    return 1;
}

sub add_to_register {
    my ( $x, $y, $p ) = @_;
    $program[$p]->{registers}->{$x} += value_of( $y, $p );
    return 1;
}

sub multiply_register {
    my ( $x, $y, $p ) = @_;
    my $factor = $program[$p]->{registers}->{$x} // 0;
    my $res = $factor * value_of( $y, $p );
    $program[$p]->{registers}->{$x} = $res;
    return 1;
}

sub divmod_register {
    my ( $x, $y, $p ) = @_;
    my $num = $program[$p]->{registers}->{$x} // 0;
    my $den = value_of( $y, $p );
    my $res = $num % $den;
    $program[$p]->{registers}->{$x} = $res;
    return 1;
}

sub receive_value {
    my ( $x, $dummy, $p ) = @_;
    my $ret = 0;
    if ( @{ $program[$p]->{queue} } ) {
        my $val = shift @{ $program[$p]->{queue} };
        set_register( $x, $val, $p );
        $ret = 1;
    }
    return $ret;
}

sub jump_gt_zero {
    my ( $x, $y, $p ) = @_;
    my $flag = value_of( $x, $p );
    my $jump = 1;
    if ( $flag > 0 ) {
        $jump = value_of( $y, $p );
    }
    return $jump;
}

