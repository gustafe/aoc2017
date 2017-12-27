#! /usr/bin/env perl
# Advent of Code 2017 Day 21 - complete solution
# Problem link: http://adventofcode.com/2017/day/21
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d21
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

# useful modules
use List::Util qw/sum max/;
use Storable qw/dclone/;
#### INIT - load input data from file into array
my $testing = 0;
my $debug   = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
sub string_to_pattern;
sub pattern_to_string;
sub pretty_print;
sub transform_2;
sub transform_3;

my %patterns;
my $id = 1;
foreach my $line (@input) {
    my ( $in, $out ) = $line =~ m/^(.*)\ \=\>\ (.*)$/;
    my $keys;
    if ( length $in == 5 ) {
        $keys = transform_2($in);
    }
    else {
        $keys = transform_3($in);
    }
    foreach my $k (@$keys) {
        if ( exists $patterns{$k} ) {
            say "==> already seen key $k, skipping";
            next;
        }
        $patterns{$k} = { id => $id, pat => $out };
    }
    $id++;
}
my $part2 = shift || 0;
my $grid = [ '.#.', '..#', '###' ];
my $iter = 0;

my $limit = $part2 ? 18 : 5;
while ( $iter < $limit ) {

    my $subgrids;

    my $div;
    if    ( scalar @$grid % 2 == 0 ) { $div = 2 }
    elsif ( scalar @$grid % 3 == 0 ) { $div = 3 }
    else                             { die "weird grid size: scalar @$grid" }
    printf(
        "==> Gridsize: %d  | size / 2 = %.3f  | size / 3 = %.3f | div = %d\n",
        scalar @$grid,
        ( scalar @$grid / 2 ),
        ( scalar @$grid / 3 ), $div
    ) if $debug;

    my ( $mrow, $mcol ) = ( 0, 0 );
    for ( my $i = 0 ; $i < scalar @$grid ; $i += $div ) {
        $mcol = 0;

        for ( my $j = 0 ; $j < length $grid->[$i] ; $j += $div ) {
            for my $offset ( 0 .. $div - 1 ) {
                push @{ $subgrids->[$mrow]->[$mcol]->{array} },
                  substr $grid->[ $i + $offset ], $j, $div;
            }

            $mcol++;
        }
        $mrow++;
    }
    if ($debug) {

        say "grid: ";
        foreach my $r (@$grid) {
            say $r;
        }
    }
    my $newgrid;

    for my $r ( 0 .. $mrow - 1 ) {
        for my $c ( 0 .. $mcol - 1 ) {
            my $count = 0;
            my $string = join( '/', @{ $subgrids->[$r]->[$c]->{array} } );
            say "$r $c $string -> $patterns{$string}->{pat}" if $debug;
            my @repl = split( /\//, $patterns{$string}->{pat} );
            my $size = max map { length $_ } @repl;

            #	    say join( ' ', $size, @repl);
            for my $idx ( 0 .. $size - 1 ) {
                $newgrid->[ $r * $size + $count ] .= shift @repl;
                $count++;
            }
        }
    }
    $grid = dclone $newgrid;
    $iter++;
}
my $count;
foreach my $r (@$grid) {
    $count += grep { $_ eq '#' } split( //, $r );
}

if ($part2) {
    say "2. number of lit pixels: $count"
} else {
    say "1. number of lit pixels: $count"
}


###############################################################################

sub pretty_print {
    my ($str) = @_;
    $str =~ s/\//\n/g;
    say $str;
    print "\n";
}

sub string_to_pattern {
    my ($str) = @_;
    my @rows = split( /\//, $str );
    my $out;
    foreach my $r (@rows) {
        foreach my $el ( split( //, $r ) ) {
            push @{$out}, $el;
        }
    }
    return $out;
}

sub pattern_to_string {
    my ($pat) = @_;
    my $out;
    my $group;

    # we can have 2x2 or 3x3 patterns
    if ( scalar @$pat == 4 ) {
        $group = 2;
    }
    elsif ( scalar @$pat == 9 ) {
        $group = 3;
    }
    else {
        die "can't parse pattern: ", join( '', @{$pat} );
    }

    #    my $group = scalar @$pat ;
    my $idx = 0;
    foreach my $el ( @{$pat} ) {
        if ( !defined $el ) {
            die "bad value";
        }
        $out .= $el;
        $idx++;
        if ( $idx % $group == 0 ) {
            $out .= '/';
        }
    }
    $out =~ s/\/$//gm;
    return $out;
}

sub transform_2 {
    my ($str) = @_;
    my $p = string_to_pattern($str);
    my $transforms;
    $transforms->{ pattern_to_string( [ $p->[0], $p->[1], $p->[2], $p->[3], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[0], $p->[2], $p->[1], $p->[3], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[1], $p->[0], $p->[3], $p->[2], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[1], $p->[3], $p->[0], $p->[2], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[2], $p->[0], $p->[3], $p->[1], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[2], $p->[3], $p->[0], $p->[1], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[3], $p->[1], $p->[2], $p->[0], ] )
    }++;
    $transforms->{ pattern_to_string( [ $p->[3], $p->[2], $p->[1], $p->[0], ] )
    }++;

    return [ keys %{$transforms} ];
}

sub transform_3 {
    my ($str) = @_;
    my $p = string_to_pattern($str);
    my $transforms;
    $transforms->{
        pattern_to_string(
            [
                $p->[0], $p->[1], $p->[2], $p->[3], $p->[4],
                $p->[5], $p->[6], $p->[7], $p->[8],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[0], $p->[3], $p->[6], $p->[1], $p->[4],
                $p->[7], $p->[2], $p->[5], $p->[8],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[2], $p->[1], $p->[0], $p->[5], $p->[4],
                $p->[3], $p->[8], $p->[7], $p->[6],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[2], $p->[5], $p->[8], $p->[1], $p->[4],
                $p->[7], $p->[0], $p->[3], $p->[6],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[6], $p->[3], $p->[0], $p->[7], $p->[4],
                $p->[1], $p->[8], $p->[5], $p->[2],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[6], $p->[7], $p->[8], $p->[3], $p->[4],
                $p->[5], $p->[0], $p->[1], $p->[2],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[8], $p->[5], $p->[2], $p->[7], $p->[4],
                $p->[1], $p->[6], $p->[3], $p->[0],
            ]
        )
    }++;
    $transforms->{
        pattern_to_string(
            [
                $p->[8], $p->[7], $p->[6], $p->[5], $p->[4],
                $p->[3], $p->[2], $p->[1], $p->[0],
            ]
        )
    }++;

    return [ keys %{$transforms} ];
}
