#! /usr/bin/env perl
# Advent of Code 2017 Day 13 - part 2
# Problem link: http://adventofcode.com/2017/day/13
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d13
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

# useful modules
use List::Util qw/max/;
use Storable qw/dclone/;
#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
# parse input

my %depths;
my $max = 0;
while (@input) {
    my ( $pos, $depth ) = split( /: /, shift @input );
    $depths{$pos} = $depth;
    $max = max( $max, $pos );
}

# these are from the chapter on iterators in HOP, but not in a
# separate module
sub NEXTVAL      { $_[0]->() }
sub Iterator (&) { return $_[0] }

# an iterator for states
sub states {
    my ($m) = @_;
    return Iterator {
        for my $i ( 0 .. scalar @$m - 1 ) {
            if ( exists $depths{$i} ) {
                my $new = $m->[$i] + 1;
                $m->[$i] = $new % ( 2 * $depths{$i} - 2 );
            }
        }
        return $m;
    }
}

my $initial = [ (0) x ( $max + 1 ) ];
my $iter1   = states($initial);
my $starter = NEXTVAL($iter1);

my $delay = 1;
while (1) {
    my $curr     = 0;
    my $hit      = 0;
    my $firewall = dclone $starter;
    my $iter2    = states($firewall);
  INNER: while ( $curr <= $max ) {
        if ( exists $depths{$curr} and $firewall->[$curr] == 0 ) {
            $hit = 1;
            last INNER;
        }
        $firewall = NEXTVAL($iter2);
        $curr++;
    }
    last if ( $hit == 0 );
    $delay++;
    $starter = NEXTVAL($iter1);
}

say $delay;
