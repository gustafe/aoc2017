#! /usr/bin/env perl
# Advent of Code 2017 Day 10 - part 2
# Problem link: http://adventofcode.com/2017/day/10
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d10
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my @array = ( 0 .. 255 );
my @key;
my @salt = ( 17, 31, 73, 47, 23 );
my $teststring = '1,2,3';
if ($testing) {
    my @convert = map { ord($_) } split( //, $teststring );
    @key = ( @convert, @salt );
}
else {
    my @in = map { ord($_) } split( //, shift @input );
    @key = ( @in, @salt );
}
my $skip = 0;
my $pos  = 0;
my $len  = 0;
sub array_to_hex;

foreach my $round ( 1 .. 64 ) {
    my @lengths = @key;
    while (@lengths) {
        $len = shift @lengths;
        my $end     = $pos + $len - 1;
        my $overlap = $end % @array;

        # do we overlap?
        if ( $overlap == $end ) {    #no
            my @segment = @array[ $pos .. $end ];
            @array[ $pos .. $end ] = reverse @segment;
        }
        else {
            my @seg1    = @array[ $pos .. $#array ];
            my @seg2    = @array[ 0 .. $overlap ];
            my @replace = reverse( @seg1, @seg2 );
            @array[ $pos .. $#array ] = @replace[ 0 .. ( $#array - $pos ) ];
            @array[ 0 .. $overlap ] =
              @replace[ ( $#replace - $overlap ) .. $#replace ];
        }

        $pos = ( $pos + $len + $skip ) % @array;
        $skip++;
    }
}
say array_to_hex;

########################################

sub array_to_hex {
    my $string;
    while (@array) {
        my @row = splice( @array, 0, 16 );
        my $xor;
        my $el_1 = shift @row;
        while (@row) {
            my $el_2 = shift @row;
            $xor  = $el_1 ^ $el_2;
            $el_1 = $xor;
        }
        $string .= sprintf( "%02x", $xor );
    }
    return $string;
}
