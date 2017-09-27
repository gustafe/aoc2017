#!/usr/bin/perl
# Advent of Code 2016 - Bonus problem, part 2
# Problem link: https://www.reddit.com/r/adventofcode/comments/72aizu/bonus_challenge/
# based on the 2016 day 8
# input: file 'input2.txt' in same directory, produced by part 1
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input2.txt';
{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my ( $max_col, $max_row ) = $testing ? ( 7, 3 ) : ( 50, 6 );

my $M;
for my $r ( 0 .. $max_row - 1 ) {
    for my $c ( 0 .. $max_col - 1 ) {
        $M->[$c]->[$r] = 0;
    }
}

sub rect {
    my ( $col, $row ) = @_;
    for my $r ( 0 .. $row - 1 ) {
        for my $c ( 0 .. $col - 1 ) {
            $M->[$r]->[$c] = 1;
        }
    }
}

sub rotate_row {
    my ( $row, $shift ) = @_;
    my @current_row = @{ $M->[$row] };
    my @new_row;
    for my $i ( 0 .. $#current_row ) {
        $new_row[ ( $i + $shift ) % $max_col ]
            = $current_row[$i] ? $current_row[$i] : 0;
    }
    $M->[$row] = \@new_row;
}

sub rotate_col {
    my ( $col, $shift ) = @_;
    my @current_col;
    for my $r ( 0 .. $max_row - 1 ) {
        push @current_col, $M->[$r]->[$col];
    }
    my @new_col;
    for my $i ( 0 .. $#current_col ) {
        $new_col[ ( $i + $shift ) % $max_row ]
            = $current_col[$i] ? $current_col[$i] : 0;
    }
    for my $r ( 0 .. $max_row - 1 ) {
        $M->[$r]->[$col] = $new_col[$r];
    }
}

sub display {
    for my $r ( 0 .. $max_row - 1 ) {
        print '    ';
        for my $c ( 0 .. $max_col - 1 ) {
            if ( defined( $M->[$r]->[$c] ) and $M->[$r]->[$c] == 1 ) {
                print '0';
            } else {
                print ' ';
            }
        }
        print "\n";
    }
}

sub count_cells {
    my $count = 0;
    for my $r ( 0 .. $max_row - 1 ) {
        for my $c ( 0 .. $max_col - 1 ) {
            if ( defined( $M->[$r]->[$c] ) and $M->[$r]->[$c] == 1 ) {
                $count++;
            }
        }
    }
    return $count;
}

foreach my $line (@input) {
    if ( $line =~ m/^rect (\d+)x(\d+)/ ) {
        rect( $1, $2 );
    } elsif ( $line =~ m/^rotate column x=(\d+) by (\d+)/ ) {
        rotate_col( $1, $2 );
    } elsif ( $line =~ m/^rotate row y=(\d+) by (\d+)/ ) {
        rotate_row( $1, $2 );
    } else {
        die "can't parse $line";
    }
}
say "    Lit pixels: ", count_cells();
display();
