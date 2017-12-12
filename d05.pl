#!/usr/bin/perl
# Advent of Code 2017 Day 5 - complete solution
# Problem link: http://adventofcode.com/2017/day/5
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d05
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE

sub debug {
    say join ' ', @input;
}
# pass a non-false argument to enable part 2
my $part2 = shift || 0;

my $steps   = 0;
my $pointer = 0;

while ( $pointer >= 0 and $pointer < scalar @input ) {
    my $jump = $input[$pointer];
    if ( $jump == 0 ) {
        $steps++;
        $input[$pointer]++;
        next;
    }
    else {
        my $pos  = $pointer;
        $pointer = $pointer + $jump;
        $steps++;
        if ( $jump >= 3 and $part2 ) {
            $input[$pos]--;
        }
        else {
            $input[$pos]++;
        }
    }
    debug if $testing;
}
print 'Part ' , $part2 ? '2' : '1' ,  '. ';
say "number of steps: $steps";
