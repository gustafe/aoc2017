#!/usr/bin/perl
# Advent of Code 2017 Day 7 - complete solution
# Problem link: http://adventofcode.com/2017/day/7
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d07
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %towers;

sub total_weight;
sub compare_levels;

# construct a hash holding values - weights and children
foreach my $line (@input) {
    if ( $line =~ m/^(?<tower>.*) \((?<weight>\d+)\) \-\> (?<list>.*)$/ ) {
        my  $tower  = $+{tower};
        $towers{$tower}->{weight} = $+{weight};
        foreach my $el ( split( /\,/, $+{list} ) ) {
            $el =~ s/^\s+|\s+$//g;    # trim whitespace
            $towers{$el}->{held_by} = $tower;
            push @{ $towers{$tower}->{holding} }, $el;
        }
    }
    elsif ( $line =~ m/^(?<tower>.*) \((?<weight>\d+)\)$/ ) {
        $towers{$+{tower}}->{weight} = $+{weight};
    }
    else {
        die "can't parse input line: $line\n";
    }
}

# find the root (part 1)
my $root;
foreach my $tower ( keys %towers ) {
    if ( !exists $towers{$tower}->{held_by} ) {
        $root = $tower;
        last;
    }
}
say "1. name of root disk: $root";
say "2. adjusted weight  : ", compare_levels( $root, 0 );

########################################

# recursively calculate the weight of a tower, given a base
sub total_weight {
    my ($base) = @_;
    my $weight;

    if ( !exists $towers{$base}->{holding} ) {    # leaf
        $weight = $towers{$base}->{weight};
    }
    else {
        $weight = $towers{$base}->{weight};
        foreach my $child ( @{ $towers{$base}->{holding} } ) {
            $weight += total_weight($child);
        }
    }
    return $weight;
}

# compare the weights of a base tower's children, return corrected
# weight
sub compare_levels {
    my ( $base, $diff ) = @_;
    my %values;
    foreach my $child ( @{ $towers{$base}->{holding} } ) {
        push @{ $values{ total_weight($child) } }, $child;
    }

    # do we have any diffs?
    if ( scalar keys %values == 1 )
    {    # no diffs, return corrected weight of parent
        return $towers{$base}->{weight} - $diff;
    }
    else {    # calculate new diff (should be the same for each step
              # but we might as well have the latest value...
        my ( $lo, $hi ) = sort { $a <=> $b } keys %values;
        $diff = $hi - $lo;
    }

    # find the outlier to send on to the next level
    my $differing;
    foreach my $val ( keys %values ) {
        if ( scalar @{ $values{$val} } == 1 ) {
            $differing = $values{$val}->[0];
        }
    }
    compare_levels( $differing, $diff );
}
