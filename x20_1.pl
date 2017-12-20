#! /usr/bin/env perl
# Advent of Code 2017 Day 20 - alternative part 1 - closed form
# Problem link: http://adventofcode.com/2017/day/20
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d20
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;
use List::Util qw/sum/;

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $id = 0;
my %positions;
while (@input) {
    my $line = shift @input;
    if ( $line =~ m/^p\=\<(.*)\>, v=\<(.*)\>, a=\<(.*)\>/ ) {
        my $p = sum map { abs $_ } split( /,/, $1 );
        my $v = sum map { abs $_ } split( /,/, $2 );
        my $a = sum map { abs $_ } split( /,/, $3 );
        $positions{$id} = { p => $p, v => $v, a => $a };
    }
    else {
        die "cannot parse input line: $line";
    }
    $id++;
}

# Select the particle with the lowest absolute acceleration. This
# works for my input, but maybe not for all. In that case the tie
# needs to be broken by absolute velocity.

say "1. closest particle: ",
  ( sort { $positions{$a}->{a} <=> $positions{$b}->{a} } keys %positions )[0];
