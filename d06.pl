#!/usr/bin/perl
# Advent of Code 2017 Day 6 - complete solution
# Problem link: http://adventofcode.com/2017/day/6
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d06
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;
use List::Util qw/max/;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE

my @state = split( /\t/, $input[0] );
my %seen_states;

sub debug {
    say join( ',', @state );
}

my $count = 0;
$seen_states{ "@state" } = $count;

# let's loop!
while (1) {
    my $largest_el = max @state;
    my @positions  = grep { $state[$_] == $largest_el } (0 .. $#state);
    # we might have more than one position with the same number of elements
    # choose the first
    my $start      = shift @positions;
    my $blocks     = $state[$start];
    $state[$start] = 0;
    my $next = $start + 1;
    while ( $blocks > 0 ) {
	# do we need to wrap around?
        if ( $next >= scalar @state ) { $next = 0 }
        $state[$next]++;
        $blocks--;
        $next++;
    }
    $count++;
    if ( exists $seen_states{ "@state" } ) {
        last;
    }
    else {
        $seen_states{ "@state" } = $count;
    }
}
say "1. number of cycles: $count";
say "2. size of loop    : ", $count - $seen_states{ "@state" };

