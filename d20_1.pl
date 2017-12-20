#! /usr/bin/env perl
# Advent of Code 2017 Day 20 - part 1
# Problem link: http://adventofcode.com/2017/day/20
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d20
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

# useful modules
use List::Util qw/sum/;

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my $id = 0;
my %positions;
while (@input) {
    my $line = shift @input;
    if ( $line =~ m/^p\=\<(.*)\>, v=\<(.*)\>, a=\<(.*)\>/ ) {
        my @p = split( /,/, $1 );
        my @v = split( /,/, $2 );
        my @a = split( /,/, $3 );
        my $d = sum map { abs $_ } @p;
        $positions{$id} = { p => \@p, v => \@v, a => \@a, d => $d };
    }
    else {
        die "cannot parse input line: $line";
    }
    $id++;
}

my $closest =
  ( sort { $positions{$a}->{d} <=> $positions{$b}->{d} } keys %positions )[0];
my $compare = -1;

for my $count ( 0 .. 391 ) {    # limit found by inspection
    $compare = $closest;
    foreach my $id ( keys %positions ) {
        foreach my $m ( 0, 1, 2 ) {
            $positions{$id}->{v}->[$m] += $positions{$id}->{a}->[$m];
            $positions{$id}->{p}->[$m] += $positions{$id}->{v}->[$m];
        }
        $positions{$id}->{d} = sum map { abs $_ } @{ $positions{$id}->{p} };
    }
    $closest =
      ( sort { $positions{$a}->{d} <=> $positions{$b}->{d} } keys %positions )
      [0]

}

say "1. closest particle: ", $closest;
