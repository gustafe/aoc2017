# Advent of Code 2017 Day 1 - complete solution
# Problem link: http://adventofcode.com/2017/day/1
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d01
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
#!/usr/bin/perl
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum/;
use Data::Dumper;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my @list   = split( //, shift @input );
my $length = scalar @list;
my $sum_1  = 0;
my $sum_2  = 0;

# circular list, just make a copy to avoid funky rollover arithmetic
my @check = ( @list, @list );
for ( my $i = 0 ; $i <= $length - 1 ; $i++ ) {
    my $j = $i + $length / 2;
    if ( $check[$i] == $check[ $i + 1 ] ) { $sum_1 += $check[$i] }

    if ( $check[$i] == $check[$j] ) { $sum_2 += $check[$i] }
}
say "Part 1: $sum_1";
say "Part 2: $sum_2";
