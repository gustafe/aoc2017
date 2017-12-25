#! /usr/bin/env perl
# Advent of Code 2017 Day 23 - part 1
# Problem link: http://adventofcode.com/2017/day/23
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d23
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

my %registers;
my @ins;
my $line = 0;
while (@input) {
    my @atoms = split( /\s+/, shift @input );
    push @ins, \@atoms;
    $line++;
}

sub value_of;
my %action = (
    set => \&set_register,
    sub => \&decrease_register,
    mul => \&multiply_register,
    jnz => \&jump_not_zero,
);
map { $registers{$_} = 0 } ( 'a' .. 'h' );

#$registers{a} = 0;

my $pos = 0;
my $multiplies;
while ( $pos >= 0 and $pos <= $#ins ) {
    my ( $cmd, $arg1, $arg2 ) = @{ $ins[$pos] };
    my $ret = $action{$cmd}->( $arg1, $arg2 );
    $multiplies++ if $cmd eq 'mul';
    $pos = $pos + $ret;
}

say "1. number of multiplications: ", $multiplies;

###############################################################################
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

sub decrease_register {
    my ( $x, $y ) = @_;
    $registers{$x} -= value_of($y);
    return 1;
}

sub multiply_register {
    my ( $x, $y ) = @_;
    my $factor = $registers{$x} // 0;
    my $res = $factor * value_of($y);
    $registers{$x} = $res;
    return 1;
}

sub jump_not_zero {
    my ( $x, $y ) = @_;
    my $flag = value_of($x);
    my $jump = 1;
    if ( $flag != 0 ) {
        $jump = value_of($y);
    }
    return $jump;
}

