#!/usr/bin/perl
# Advent of Code 2017 Day 3 - part 1
# Problem link: http://adventofcode.com/2017/day/3
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d03
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/min/;

#### INIT - load input data into array
my @input;
my $file = 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $target = $input[0];

sub diagonal_values {
    # from Project Euler 28, the values of numbers on diagonals
    my ($x) = @_;
    my $n = 2 * $x + 1;
    return [
        $n * $n - 3 * $n + 3,
        $n * $n - 2 * $n + 2,
        $n * $n - $n + 1,
        $n * $n
    ];
}

my $x        = 0;
my $distance = 0;
while (1) {
    my $diags = diagonal_values($x);

    # find the "ring" where the target value lies
    if ( $target >= $diags->[0] and $target <= $diags->[3] ) {

        # the diagonal values represent the largest Manhattan distance 2x
        # find the minimum distance to the diagonals
        my $min = min( map { abs( $target - $diags->[$_] ) } ( 0, 1, 2, 3 ) );
        $distance = 2 * $x - $min;
        last;
    }
    $x++;
}

say $distance;
