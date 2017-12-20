#! /usr/bin/env perl
# Advent of Code 2017 Day 20 - part 2
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

        $positions{$id} = { p => \@p, v => \@v, a => \@a, };
    }
    else {
        die "cannot parse input line: $line";
    }
    $id++;
}

for my $count ( 0 .. 50 ) {    # value found from inspection
    my %collisions;

    # update positions, find collisions
    foreach my $id ( keys %positions ) {
        foreach my $m ( 0, 1, 2 ) {
            $positions{$id}->{v}->[$m] += $positions{$id}->{a}->[$m];
            $positions{$id}->{p}->[$m] += $positions{$id}->{v}->[$m];
        }
        push @{ $collisions{ join( ',', @{ $positions{$id}->{p} } ) } }, $id;
    }

    my @same;
    foreach my $key ( keys %collisions ) {
        push @same, @{ $collisions{$key} } if scalar @{ $collisions{$key} } > 1;
    }
    if (@same) {
        foreach my $el (@same) {
            delete $positions{$el};
        }

    }
}

say "2. particles remaining after collisions: ", scalar keys %positions;
