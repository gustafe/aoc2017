#! /usr/bin/env perl
# Advent of Code 2017 Day 11 - complete solution
# Problem link: http://adventofcode.com/2017/day/11
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d11
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;
use List::Util qw/max/;

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
# x,y,z coordinates - see https://www.redblobgames.com/grids/hexagons/
my %move = (
    n  => sub { [  0,  1, -1 ] },
    ne => sub { [  1,  0, -1 ] },
    se => sub { [  1, -1,  0 ] },
    s  => sub { [  0, -1,  1 ] },
    sw => sub { [ -1,  0,  1 ] },
    nw => sub { [ -1,  1,  0 ] },
);

my @dirs = split( /,/, shift @input );
my @path;

#         x, y, z
my $M = [ 0, 0, 0 ];
my $max_dist = 0;
while (@dirs) {
    my $ins = shift @dirs;
    push @path, $ins;
    my $d = $move{$ins}->();

    for my $coord ( 0, 1, 2 ) {
        $M->[$coord] = $M->[$coord] + $d->[$coord];
    }
    my $curr_dist = max( map { abs($_) } @$M );
    if ( $curr_dist > $max_dist ) {
        $max_dist = $curr_dist;
    }
}
if ($testing) {
    print join( ' -> ', @path ), ' ';
}
say "End position: ", join( ',', @$M );
say "      Part 1: ", max( map { abs($_) } @$M );
say "      Part 2: ", $max_dist;

