#! /usr/bin/env perl
# Advent of Code 2017 Day 19 - complete solution
# Problem link: http://adventofcode.com/2017/day/19
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d19
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
my $map;
my ( $maxrow, $maxcol ) = ( 0, 0 );
while (@input) {
    my @line = split( //, shift @input );
    $maxcol = max( $maxcol, scalar @line );
    push @{$map}, \@line;
    $maxrow++;
}

# add buffer row
push @{$map}, [ ' ' x $maxcol ];
my %dirs = (
    up    => [ -1, 0 ],
    down  => [ 1,  0 ],
    left  => [ 0,  -1 ],
    right => [ 0,  1 ]
);

my @sequence;

# sensible dependence on initial starting condition
my $row = 0;
my ($col) =
  grep { $map->[$row]->[$_] eq '|' } ( 0 .. scalar @{ $map->[$row] } - 1 );

my $dir   = 'down';
push @sequence, '|';

# traverse the tubes!
while ( $row >= 0 and $row < $maxrow and $col >= 0 and $col < $maxcol ) {

    my $nextr = $row + $dirs{$dir}->[0];
    my $nextc = $col + $dirs{$dir}->[1];
    my $nextdir;
    my $char = $map->[$nextr]->[$nextc] // ' ';

    if ( $char =~ m/\-|\||[A-Z]/ ) {

        # grab them all, let grep sort 'em out
        push @sequence, $char;
        $nextdir = $dir;
    }
    elsif ( $char eq '+' ) {    # change dir
	push @sequence, $char;
        foreach my $d ( sort keys %dirs ) {
            next if ( $d eq $dir );
            next
              if ( $dirs{$d}->[0] + $dirs{$dir}->[0] == 0
                or $dirs{$d}->[1] + $dirs{$dir}->[1] == 0 );
            my $neighbor =
              $map->[ $nextr + $dirs{$d}->[0] ]->[ $nextc + $dirs{$d}->[1] ]
              // ' ';
            next if ( $neighbor eq ' ' );
            $nextdir = $d;
        }

    }
    elsif ( $char eq ' ' ) {
        last;
    }
    $row = $nextr;
    $col = $nextc;
    $dir = $nextdir;
}

say '1. string: ', join '', grep { $_ =~ m/[A-Z]/ } @sequence;
say '2. count : ', scalar @sequence;

