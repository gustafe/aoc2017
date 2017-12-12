#!/usr/bin/perl
# Advent of Code 2017 Day 2 - complete solution
# Problem link: http://adventofcode.com/2017/day/2
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d02
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;
use List::Util qw/max min/;

#### INIT - load input data into array
my @input;
my $file = 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $sum_1 = 0;
my $sum_2 = 0;
foreach my $line (@input) {

    # sort the values for easier division comparison down the line
    my @row = sort { $b <=> $a } split( /\s+/, $line );

    $sum_1 += $row[0] - $row[$#row];

    my $found = 0;
    while ( @row and !$found ) {
        my $a = shift @row;
	# using a reverse here slightly increases the chance of
	# finding a divisor faster
        foreach my $b ( reverse @row) {
            if ( $a % $b == 0 ) {
                $sum_2 += $a / $b;
                $found = 1;
            }
        }
    }
}
say "Checksum      : $sum_1";
say "Sum of results: $sum_2";
