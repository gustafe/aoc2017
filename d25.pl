#! /usr/bin/env perl
# Advent of Code 2017 Day 25 - complete solution
# Problem link: http://adventofcode.com/2017/day/25
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d25
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

### CODE
my $tape;

my %actions = (
    A  => \&stateA,
    B  => \&stateB,
    C  => \&stateC,
    D  => \&stateD,
    E  => \&stateE,
    F  => \&stateF,
    tA => \&testA,
    tB => \&testB,
);

my $limit = $testing ? 6 : 12794428;

my $steps = 0;
my $pos   = 0;
my $state = $testing ? 'tA' : 'A';

while ( $steps < $limit ) {
    ( $pos, $state ) = @{ $actions{$state}->($pos) };
    $steps++;
}

my $checksum = 0;
foreach my $h ( keys %$tape ) {
    $checksum++ if $tape->{$h} == 1;
}
say $checksum;
###############################################################################
sub value_of {
    my ($p) = @_;
    if ( exists $tape->{$p} ) {
        return $tape->{$p};
    }
    else {
        $tape->{$p} = 0;
        return 0;
    }
}

sub stateA {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 1;
        $p = $p - 1;
        return [ $p, 'B' ];
    }
    else {
        $tape->{$p} = 0;
        $p = $p + 1;
        return [ $p, 'F' ];
    }
}

sub stateB {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 0;
        $p = $p - 1;
        return [ $p, 'C' ];
    }
    else {
        $tape->{$p} = 0;
        $p = $p - 1;
        return [ $p, 'D' ];
    }
}

sub stateC {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 1;
        $p = $p + 1;
        return [ $p, 'D' ];
    }
    else {
        $tape->{$p} = 1;
        $p = $p - 1;
        return [ $p, 'E' ];
    }
}

sub stateD {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 0;
        $p = $p + 1;
        return [ $p, 'E' ];
    }
    else {
        $tape->{$p} = 0;
        $p = $p + 1;
        return [ $p, 'D' ];
    }
}

sub stateE {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 0;
        $p = $p - 1;
        return [ $p, 'A' ];
    }
    else {
        $tape->{$p} = 1;
        $p = $p - 1;
        return [ $p, 'C' ];
    }
}

sub stateF {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 1;
        $p = $p + 1;
        return [ $p, 'A' ];
    }
    else {
        $tape->{$p} = 1;
        $p = $p - 1;
        return [ $p, 'A' ];
    }
}

sub testA {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 1;
        $p = $p - 1;
        return [ $p, 'tB' ];
    }
    else {
        $tape->{$p} = 0;
        $p = $p + 1;
        return [ $p, 'tB' ];
    }
}

sub testB {
    my ($p) = @_;
    my $v = value_of($p);
    if ( $v == 0 ) {
        $tape->{$p} = 1;
        $p = $p - 1;
        return [ $p, 'tA' ];
    }
    else {
        $tape->{$p} = 1;
        $p = $p + 1;
        return [ $p, 'tA' ];
    }
}
