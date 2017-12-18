#! /usr/bin/env perl
# Advent of Code 2017 Day 18 - part 1
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
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $debug = 1;
my %registers;
my @sounds;
my @ins;
while (@input) {
    my @atoms = split( /\s+/, shift @input );
    push @ins, \@atoms;
}

sub value_of;
sub dump_registers;
my %action = (
    set => \&set_register,
    snd => \&play_sound,
    add => \&add_to_register,
    mul => \&multiply_register,
    mod => \&divmod_register,
    rcv => \&recover_freq,
    jgz => \&jump_gt_zero,
);

my $pos = 0;

while ( $pos >= 0 and $pos <= $#ins ) {
    my ( $cmd, $arg1, $arg2 ) = @{ $ins[$pos] };

    my $ret = $action{$cmd}->( $arg1, $arg2 );
    if ( $cmd eq 'rcv' and scalar @sounds and $ret > 1 ) {

        last;
    }
    $pos = $pos + $ret;
}

say "1. last sound played: $sounds[-1]";

###############################################################################
sub dump_registers {
    for my $k (sort {$a cmp $b} keys %registers) {
	print "$k => $registers{$k} ";
    }
    print "\n";
}
sub value_of {
    my ($x) = @_;
    my $val;
    if ( exists $registers{$x} ) {
        $val = $registers{$x};
    }
    else {
        $val = $x;
    }
    return $val;
}

sub play_sound {
    my ( $x, $dummy ) = @_;
    push @sounds, value_of($x);
    return 1;
}

sub set_register {
    my ( $x, $y ) = @_;
    $registers{$x} = value_of($y);
    return 1;
}

sub add_to_register {
    my ( $x, $y ) = @_;
    $registers{$x} += value_of($y);
    return 1;
}

sub multiply_register {
    my ( $x, $y ) = @_;
    my $factor = $registers{$x} // 0;
    my $res    = $factor * value_of($y);
    $registers{$x} = $res;
    return 1;
}

sub divmod_register {
    my ( $x, $y ) = @_;
    my $num = $registers{$x} // 0;
    my $den = value_of($y);
    my $res = $num % $den;
    $registers{$x} = $res;
    return 1;
}

sub recover_freq {
    my ( $x, $dummy ) = @_;
    my $val = value_of($x);
    my $ret = 1;
    if ( $val != 0 ) {
        $ret = 2;
    }
    return $ret;
}

sub jump_gt_zero {
    my ( $x, $y ) = @_;
    my $flag = value_of($x);
    my $jump = 1;
    if ( $flag > 0 ) {
        $jump = value_of($y);
    }
    return $jump;
}

