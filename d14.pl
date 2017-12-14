#! /usr/bin/env perl
# Advent of Code 2017 Day 14 - complete solution
# Problem link: http://adventofcode.com/2017/day/14
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d14
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

my $max_dim = 127;
my $group_count = 0;
sub knot_hash_bin;
sub fill_flood;

my $seed    = $input[0];

my $sum = 0;
my $Map;
foreach my $idx ( 0 .. $max_dim ) {
    my $binrow = knot_hash_bin( $seed . '-' . $idx );

    my @ones = grep { $_ == 1 } split( //, $binrow );
    $sum += scalar @ones;

    # populate map
    foreach my $el ( split( //, $binrow ) ) {
        push @{ $Map->[$idx] }, { val => $el, seen => 0 };
    }
}

# process the map

foreach my $row ( 0 .. scalar @$Map - 1 ) {
    foreach my $col ( 0 .. scalar @{ $Map->[$row] } - 1 ) {
        next if $Map->[$row]->[$col]->{val} == 0;
        next if $Map->[$row]->[$col]->{seen} > 0;
	# fill flood the ones
        $group_count++;
        fill_flood( $row, $col );
    }
}

say "1. number of used squares   : ", $sum;
say "2. number of distinct groups: ", $group_count;

###############################################################################

sub fill_flood {
    my ( $r, $c ) = @_;
    my @dirs = ( [ -1, 0 ], [ 1, 0 ], [ 0, -1 ], [ 0, 1 ] );
    foreach my $d (@dirs) {
        my $new_r = $r + $d->[0];
        my $new_c = $c + $d->[1];
        next
          if ( $new_r < 0
            or $new_r > $max_dim
            or $new_c < 0
            or $new_c > $max_dim );
        next
          if ( $Map->[$new_r]->[$new_c]->{val} == 0
            or $Map->[$new_r]->[$new_c]->{seen} > 0 );
        $Map->[$new_r]->[$new_c]->{seen} = $group_count;
        fill_flood( $new_r, $new_c );
    }
}

# code adapted from day 10, part 2
sub knot_hash_bin {
    my ($string) = @_;
    my @salt = ( 17, 31, 73, 47, 23 );
    my @convert = map { ord($_) } split( //, $string );
    my @key = ( @convert, @salt );

    my @array = ( 0 .. 255 );
    my $skip  = 0;
    my $pos   = 0;
    my $len   = 0;
    foreach my $round ( 1 .. 64 ) {
        my @lengths = @key;
        while (@lengths) {
            $len = shift @lengths;
            my $end     = $pos + $len - 1;
            my $overlap = $end % @array;

            # do we overlap?
            if ( $overlap == $end ) {    #no
                my @segment = @array[ $pos .. $end ];
                @array[ $pos .. $end ] = reverse @segment;
            }
            else {
                my @seg1    = @array[ $pos .. $#array ];
                my @seg2    = @array[ 0 .. $overlap ];
                my @replace = reverse( @seg1, @seg2 );
                @array[ $pos .. $#array ] = @replace[ 0 .. ( $#array - $pos ) ];
                @array[ 0 .. $overlap ] =
                  @replace[ ( $#replace - $overlap ) .. $#replace ];
            }

            $pos = ( $pos + $len + $skip ) % @array;
            $skip++;
        }
    }
    my $hexstring;
    while (@array) {
        my @row = splice( @array, 0, 16 );
        my $xor;
        my $el_1 = shift @row;
        while (@row) {
            my $el_2 = shift @row;
            $xor  = $el_1 ^ $el_2;
            $el_1 = $xor;
        }
        $hexstring .= sprintf( "%02x", $xor );
    }
    my @chars = split( //, $hexstring );
    my $out;
    while (@chars) {
        $out .= sprintf( "%04b", hex( shift @chars ) );
    }
    return $out;
}
