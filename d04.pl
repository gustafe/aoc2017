#!/usr/bin/perl
# Advent of Code 2017 Day 4 - complete solution
# Problem link: http://adventofcode.com/2017/day/4
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d04
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my @input;
my $file = 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my ( $count_1, $count_2 ) = ( 0, 0 );
foreach my $line (@input) {
    my @passphrase = split( /\s+/, $line );
    my %dupe_words;
    map { $dupe_words{$_}++ } @passphrase;
    my %anagrams;
    map { $anagrams{ join( '', sort( split( //, $_ ) ) ) }++ } @passphrase;
    $count_1++ if ( scalar @passphrase == scalar keys %dupe_words );
    $count_2++ if ( scalar @passphrase == scalar keys %anagrams );
}

say "Part 1: $count_1\nPart 2: $count_2";
