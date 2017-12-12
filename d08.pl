#!/usr/bin/perl
# Advent of Code 2017 Day 8 - complete solution
# Problem link: http://adventofcode.com/2017/day/8
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d08
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;
use List::Util qw/max/;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %registers;
my $max_val = 0;

sub value_of;
sub compare;
foreach my $line (@input) {
    my @args = split( /\s+/, $line );

    my ( $target, $inc_dec, $val_1, $if, $source, $cmp, $val_2 ) = @args;

    my $curr = value_of($target);

    if ( compare( $source, $cmp, $val_2 ) ) {
        if ( $inc_dec eq 'inc' ) {
            $curr = $curr + $val_1;
        }
        else {
            $curr = $curr - $val_1;
        }
        $max_val = $curr if ( $curr > $max_val );
        $registers{$target} = $curr;
    }
}
say "1. largest value when done : ", max values %registers;
say "2. largest value during run: ", $max_val;

#################################################################

sub value_of {
    my ($v) = @_;
    my $ret;
    if ( exists $registers{$v} ) {
        $max_val = $registers{$v} if ( $registers{$v} > $max_val );
        $ret = $registers{$v};
    }
    else {
        $registers{$v} = 0;
        $ret = 0;
    }
    return $ret;
}

sub compare {
    my ( $src, $cmp, $arg_2 ) = @_;
    my $arg_1 = value_of($src);
    my $ret   = undef;

    # from stats, we have: != < <= == > >=
    if    ( $cmp eq '!=' ) { $ret = ( $arg_1 != $arg_2 ) }
    elsif ( $cmp eq '<'  ) { $ret = ( $arg_1 <  $arg_2 ) }
    elsif ( $cmp eq '<=' ) { $ret = ( $arg_1 <= $arg_2 ) }
    elsif ( $cmp eq '==' ) { $ret = ( $arg_1 == $arg_2 ) }
    elsif ( $cmp eq '>'  ) { $ret = ( $arg_1 >  $arg_2 ) }
    elsif ( $cmp eq '>=' ) { $ret = ( $arg_1 >= $arg_2 ) }
    die "can't set return value based on args" unless defined $ret;
    return $ret;
}
