# Advent of Code 2017 Day 3 - part 2
# Problem link: http://adventofcode.com/2017/day/3
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d03
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
#!/usr/bin/perl
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum/;
use Data::Dumper;

#### INIT - load input data into array
my @input;
my $file = 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE

my $M;
my $dirs = [ [ 1, 0 ], [ 0, 1 ], [ -1, 0 ], [ 0, -1 ] ];
sub adjacent_sum {
    my ( $x, $y ) = @_;
    my $sum = 0;
    foreach my $i ( $x - 1, $x, $x + 1 ) {
        foreach my $j ( $y - 1, $y, $y + 1 ) {
            if ( defined $M->{$i}->{$j} ) {
                $sum += $M->{$i}->{$j};
            }
        }
    }
    return $sum;
}

my $target = $input[0];

my $current_val = 1;
my ( $x, $y ) = ( 0, 0 );
$M->{$x}->{$y} = $current_val;

# should really use an iterator here but eff it...
# just generate a bunch of steps (1,1,2,2,3,3,4,4,5,5...)
# each element represents number of steps to take before changing direction
# (max value found by inspection of output during development)
my @steplengths;
foreach my $step ( 1 .. 25 ) {
    push @steplengths, $step;
    push @steplengths, $step;
}

my $dir_idx = 0;
LOOP: while (@steplengths) {

    my $step = shift @steplengths;
    if ( $dir_idx == 4 ) { $dir_idx = 0 }
    while ( $step > 0 ) {
        ( $x, $y ) =
          ( $x + $dirs->[$dir_idx]->[0], $y + $dirs->[$dir_idx]->[1] );
        $current_val = adjacent_sum( $x, $y );
        if ( $current_val >= $target ) {
            last LOOP;
        }
        $M->{$x}->{$y} = $current_val;
        $step--;
    }
    $dir_idx++;

}
say $current_val;
