#! /usr/bin/env perl
# Advent of Code 2017 Day 17 - part 1
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
my $steps  = $input[0];
my @buffer = (0);

my $pos = 0;
my $val = 1;

while ( $val <= 2017 ) {
    my $count = 0;
    my $newpos;
    while ( $count < $steps ) {
        $newpos = $pos + 1;
        if ( $newpos > $#buffer ) {
            $newpos = 0;
        }
        $pos = $newpos;
        $count++;
    }
    my @head = splice( @buffer, 0, $pos + 1 );
    @buffer = ( @head, $val, @buffer );
    $pos = scalar @head;
    $val++;
}
my ($last_pos) = grep { $buffer[$_] == 2017 } ( 0 .. $#buffer );
say "1. value after 2017 is: ", $buffer[ $last_pos + 1 ];
