#! /usr/bin/env perl
# Advent of Code 2017 Day 17 - part 2
# Problem link: http://adventofcode.com/2017/day/17
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d17
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
my $steps = $input[0];

my $val     = 1;
my $size    = 1;
my $pos = 1;
my $index_1;
while ( $val <= 50_000_000 ) {
    $pos = ( ( $pos + $steps ) % $size ) + 1;
    $size++;
    if ( $pos == 1 ) {
        $index_1 = $val;
    }
    $val++;
}
say "2. value after    0 is: $index_1";
