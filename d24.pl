#! /usr/bin/env perl
# Advent of Code 2017 Day 24 - complete solution
# Problem link: http://adventofcode.com/2017/day/24
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d24
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
# credit: reddit user /u/tobiasvl
# https://www.reddit.com/r/adventofcode/comments/7lte5z/2017_day_24_solutions/drpug3v/

my @connections;
while (@input) {
    my $el = shift @input;
    my @ar = split( '/', $el );
    push @connections, \@ar;
}

sub build {
    my ( $path, $components, $connection ) = @_;
    my $strongest = $path;
    my $longest   = $path;
    for my $c (@$components) {
        next unless ( $c->[0] == $connection or $c->[1] == $connection );
        my @npath = ( @$path, $c );
        my @excl = grep { !( $_ ~~ $c ) } @$components;
        my $next = $c->[0] == $connection ? $c->[1] : $c->[0];
        my ( $strong, $long ) = build( \@npath, \@excl, $next );
        if ( sum( map { sum @$_ } @$strong ) >
            ( sum( map { sum @$_ } @$strongest ) ) )
        {
            $strongest = $strong;
        }
        if ( scalar @$long > scalar @$longest ) {
            $longest = $long;
        }
        elsif ( scalar @$long == scalar @$longest ) {
            $longest = $long
              if ( sum( map { sum @$_ } @$long ) >
                sum( map { sum @$_ } @$longest ) );
        }
    }
    return ( $strongest, $longest );
}

my ( $p1, $p2 ) = build( [], \@connections, 0 );

say "1. strongest bridge has strength: ", sum( map { sum @$_ } @$p1 );
say "2.   longest bridge has strength: ", sum( map { sum @$_ } @$p2 );

