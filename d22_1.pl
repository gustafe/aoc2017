#! /usr/bin/env perl
# Advent of Code 2017 Day 22 - part 1
# Problem link: http://adventofcode.com/2017/day/22
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d22
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
my $map;

sub pretty_print;
my $row   = 0;
my $lastc = 0;
while (@input) {
    my @line = split( //, shift @input );
    foreach my $c ( 0 .. $#line ) {
        $map->{$row}->{$c} = $line[$c];
    }
    $row++;
    $lastc = scalar @line;
}

# inspection show midpoint
my $pos = $testing ? [ 1, 1 ] : [ 12, 12 ];

# our coordinate system is row/cols: "up" is negative 1st coord
my $dir      = [ -1, 0 ];
my $limit    = 10_000;
my $moves    = 0;
my $infected = 0;
while ( $moves < $limit ) {

    # does node exist? if not create it
    my $state;
    if ( exists $map->{ $pos->[0] }->{ $pos->[1] } ) {
        $state = $map->{ $pos->[0] }->{ $pos->[1] };
    }
    else {
        $map->{ $pos->[0] }->{ $pos->[1] } = '.';
        $state = '.';
    }

    # inspect current node, turn, and act on node
    if ( $state eq '#' ) {
        $dir = turn_right($dir);
        $map->{ $pos->[0] }->{ $pos->[1] } = '.';
    }
    else {
        $dir = turn_left($dir);
        $map->{ $pos->[0] }->{ $pos->[1] } = '#';
        $infected++;
    }

    # move
    $pos = [ $pos->[0] + $dir->[0], $pos->[1] + $dir->[1] ];
    $moves++;
}
say $infected;
###############################################################################
sub turn_left {
    my ($in) = @_;
    my $out;

    if ( $in->[0] == -1 and $in->[1] == 0 ) {    #up
        $out = [ 0, -1 ];
    }
    elsif ( $in->[0] == 0 and $in->[1] == -1 ) {    #left
        $out = [ 1, 0 ];
    }
    elsif ( $in->[0] == 1 and $in->[1] == 0 ) {     #down
        $out = [ 0, 1 ];
    }
    elsif ( $in->[0] == 0 and $in->[1] == 1 ) {     #right
        $out = [ -1, 0 ];
    }
    else {
        die "can't parse direction: [ $in->[0], $in->[1] ]";
    }
    return $out;
}

sub turn_right {
    my ($in) = @_;
    my $out;

    if ( $in->[0] == -1 and $in->[1] == 0 ) {    #up
        $out = [ 0, 1 ];
    }
    elsif ( $in->[0] == 0 and $in->[1] == -1 ) {    #left
        $out = [ -1, 0 ];
    }
    elsif ( $in->[0] == 1 and $in->[1] == 0 ) {     #down
        $out = [ 0, -1 ];
    }
    elsif ( $in->[0] == 0 and $in->[1] == 1 ) {     #right
        $out = [ 1, 0 ];
    }
    else {
        die "can't parse direction: [ $in->[0], $in->[1] ]";
    }
    return $out;
}

sub pretty_print {
    foreach my $r ( sort { $a <=> $b } keys %{$map} ) {
        foreach my $c ( sort { $a <= $b } keys %{ $map->{$r} } ) {
            if ( exists $map->{$r}->{$c} ) {
                print $map->{$r}->{$c};
            }
            else {
                print '.';
            }

        }
        print "\n";
    }
    print "\n";
}
