#!/usr/bin/perl
# Advent of Code 2017 Day 9 - complete solution
# Problem link: http://adventofcode.com/2017/day/9
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d09
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

# useful modules
use List::Util qw/sum/;
use Data::Dumper;

#### INIT - load input data from file into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE

my ( $score, $invalid_flag, $garbage_count ) = ( 0, 0, 0 );
my @groups;
my @garbage;

sub open_group {
    if ( !@garbage ) {
        push @groups, '{';
        $score += scalar @groups;
    }
    else {
        $garbage_count++;
    }
}

sub close_group {
    if ( !@garbage ) {
        pop @groups;
    }
    else {
        $garbage_count++;
    }
}

sub garbage_in {
    if ( !@garbage ) {
        push @garbage, '<';
    }
    else {
        $garbage_count++;
    }
}

# dispatch table
my %act = (
    '{' => \&open_group,
    '}' => \&close_group,
    '<' => \&garbage_in,
    '>' => sub { pop @garbage },
    '!' => sub { $invalid_flag = 1 if @garbage },
);

# process the stream
my @stream = split( //, shift @input );
my $char;
while (@stream) {
    $char = shift @stream;
    if ($invalid_flag) {
        $invalid_flag = 0;
        next;
    }
    if ( defined $act{$char} ) {
        $act{$char}->();
    }
    else {
        $garbage_count++ if @garbage;
    }
}
say "Part 1: $score";
say "Part 2: $garbage_count";
