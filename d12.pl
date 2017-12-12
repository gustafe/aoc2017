#! /usr/bin/env perl
# Advent of Code 2017 Day 12 - complete solution
# Problem link: http://adventofcode.com/2017/day/12
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d12
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
my %pipes;
while (@input) {
    my $line = shift @input;
    if ( $line =~ /^(\d+)\ \<\-\>\ (.*)$/ ) {
        my @inputs = ($1);
        my @rhs = split( ', ', $2 );
        $pipes{$1} = \@rhs;
    }
    else {
        die "cannot recognize input line: $line";
    }
}

my %seen;
my %groups;
foreach my $id ( keys %pipes ) {
    next if $seen{$id};
    my %connections = ( $id => 1 );
    my @list = @{ $pipes{$id} };
    while (@list) {
        my $p = shift @list;
        $seen{$p}++;
        next if exists $connections{$p};
        $connections{$p}++;
        push @list, @{ $pipes{$p} };
    }
    $groups{$id} = \%connections;
}
say "Part 1: ", scalar keys %{ $groups{'0'} }, " connections to 0";
say "Part 2: ", scalar keys %groups, " total groups";
