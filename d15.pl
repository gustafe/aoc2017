#! /usr/bin/env perl
# Advent of Code 2017 Day 15 - complete solution
# Problem link: http://adventofcode.com/2017/day/15
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d15
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

# pass a non-false value for part 2
my $part2 = shift || 0;

my @start;
my @factors = ( 16807, 48271 );
my @evendivs = $part2 ? ( 4, 8 ) : ( undef, undef );
my $divisor  = 2147483647;
my $mask     = 0xFFFF;

while (@input) {
    my $str = shift @input;
    if ( $str =~ m/(\d+)$/ ) {
        push @start, $1;
    }
    else {
        die "can't parse input: $str";
    }
}

# cribbed from HOP
sub NEXTVAL      { $_[0]->() }
sub Iterator (&) { return $_[0] }

sub generator {
    my ( $start, $factor, $divide_by ) = @_;
    return Iterator {
        my $nextval;
        if ( defined $divide_by ) {

            do {
                $nextval = ( $start * $factor ) % $divisor;
                $start   = $nextval;
            } until ( $nextval % $divide_by == 0 );
            return $start;
        }
        else {
            $nextval = ( $start * $factor ) % $divisor;
            $start   = $nextval;
            return $start;
        }
    }
}

my $count = 1;
my $match = 0;

my $gen_A = generator( $start[0], $factors[0], $evendivs[0] );
my $gen_B = generator( $start[1], $factors[1], $evendivs[1] );

my $LIMIT = 1_000_000 * ( $part2 ? 5 : 40 );

while ( $count <= $LIMIT ) {
    $match++ if ( ( NEXTVAL($gen_A) & $mask ) == ( NEXTVAL($gen_B) & $mask ) );
    $count++;
}
printf "No. of matches for part %d: %d\n", $part2 ? 2 : 1, $match;
