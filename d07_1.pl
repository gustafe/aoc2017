#!/usr/bin/perl
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use List::Util qw/sum/;
use Data::Dumper;

#### INIT - load input data into array
my $testing = 0;
my @input;
my $file = $testing ? 'test.txt' : 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE
my %towers;
foreach my $line (@input) {
    my ( $tower, $weight, $list );
    if ( $line =~ m/^(.*) \((\d+)\) \-\> (.*)$/ ) {
        $tower  = $1;
        $weight = $2;
        $list   = $3;

        $towers{$tower}->{weight} = $weight;
        foreach my $el ( split( /\,/, $list ) ) {
            $el =~ s/^\s+|\s+$//g;    # trim whitespace
            $towers{$el}->{held_by} = $tower;
        }
    }
    elsif ( $line =~ m/^(.*) \((\d+)\)$/ ) {
        $towers{$1}->{weight} = $2;
    }
    else {
        die "can't recognize input line: $line\n";
    }
}

foreach my $tower ( keys %towers ) {
    if ( scalar keys %{ $towers{$tower} } < 2 ) {
        say $tower;
        last;
    }
}
