#! /usr/bin/env perl
# Advent of Code 2017 Day 23 - part 2
# Problem link: http://adventofcode.com/2017/day/23
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d23
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;
use ntheory qw/is_prime/;
###
# credit: Reddit /u/dario_p1
# https://www.reddit.com/r/adventofcode/comments/7lms6p/2017_day_23_solutions/drnmlbk/

my $input = 67; # from the first line of the input
my $lower = $input * 100 + 100_000;
my $upper = $lower + 17_000;
my $h     = 0;

for ( my $i = $lower ; $i <= $upper ; $i += 17 ) {
    if ( !is_prime($i) ) {
        $h++;
    }
}

say "2. value of register 'h': ", $h;
