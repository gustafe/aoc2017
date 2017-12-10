#! /usr/bin/env perl
# Advent of Code 2017 Day 10 - part 1 
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
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my @array = $testing ? (0..4) : (0..255);
my @lengths = split(/\,/, shift @input);

my $skip =0;
my $pos = 0;
my $len = 0;

sub dump_state {
    printf("curr length: %d curr skip: %d next pos: %d\n", $len, $skip, $pos);
    my @copy = @array;
    if ($testing) {
	say join(' ', map { sprintf("%2d", $_)} @copy);
    } else {
	while (@copy) {
	    my @row = splice(@copy,0,16);
	    say join(' ',map{sprintf("%3d",$_)} @row);
	}
    }
}
dump_state;
while (@lengths) {
    $len = shift @lengths;
    my $end = $pos + $len-1;
    my $overlap = $end % @array;

    # do we overlap?
    if ($overlap == $end) { #no
	my @segment = @array[$pos..$end];
	@array[$pos..$end] = reverse @segment;
    } else {
	my @seg1 = @array[$pos..$#array];
	my @seg2 = @array[0..$overlap];
	say join(' ',@seg1,@seg2) if $testing;
	my @replace = reverse (@seg1, @seg2);
	say join(' ',@replace) if $testing;
	@array[$pos..$#array] = @replace[0..($#array-$pos)];
	@array[0..$overlap]=@replace[($#replace-$overlap)..$#replace];
    }

    $pos = ($pos+$len+$skip) % @array;
    $skip++;
    dump_state;
}
say $array[0]*$array[1];
