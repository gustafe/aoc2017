#! /usr/bin/env perl
# Advent of Code 2017 Day 16 - complete solution
# Problem link: http://adventofcode.com/2017/day/16
#   Discussion: http://gerikson.com/blog/comp/Advent-of-Code-2017.html#d16
#      License: http://gerikson.com/files/AoC2017/UNLICENSE
###########################################################
use 5.016;
use warnings;
use autodie;

#### INIT - load input data from file into array
my @input;
my $file = 'input.txt';
open( my $fh, '<', "$file" );
while (<$fh>) { chomp; s/\r//gm; push @input, $_; }

### CODE

my @list = 'a' .. 'p';

my %actions = (
    s => \&spin,
    x => \&exchange,
    p => \&partner,
);

my @seq;
for my $el ( split( /,/, $input[0] ) ) {
    if    ( $el =~ m/s(\d+)/ )        { push @seq, [ 's', $1, undef ] }
    elsif ( $el =~ m/x(\d+)\/(\d+)/ ) { push @seq, [ 'x', $1, $2 ] }
    elsif ( $el =~ m/p(\S+)\/(\S+)/ ) { push @seq, [ 'p', $1, $2 ] }
    else                              { die "can't parse: $el" }
}

my $count = 1;
my $period;
my $LIMIT = 1_000_000_000;

# find answer to part 1, and the recurrence period;
while ( $count <= $LIMIT ) {
    say "==> $count" if $count % 100 == 0;
    foreach my $el (@seq) {
        $actions{ $el->[0] }->( $el->[1], $el->[2] );
    }
    say "1. result after 1  round : ", join( '', @list ) if $count == 1;
    if ( join( '', @list ) eq join( '', 'a' .. 'p' ) ) {
        $period = $count;
        last;
    }
    $count++;
}

# find part 2;
$count = 1;
@list  = 'a' .. 'p';
while ( $count <= $LIMIT % $period ) {
    foreach my $el (@seq) {
        $actions{ $el->[0] }->( $el->[1], $el->[2] );
    }
    $count++;
}

say "2. result after 1B rounds: ", join( '', @list );

###############################################################################

sub spin {
    my ( $x, $_0 ) = @_;
    my @tail = @list[ -$x .. -1 ];
    my @head = @list[ 0 .. $#list - $x ];
    @list = ( @tail, @head );
}

sub exchange {
    my ( $p, $q ) = @_;
    my $newp = $list[$q];
    my $newq = $list[$p];
    $list[$p] = $newp;
    $list[$q] = $newq;
}

sub partner {
    my ( $r, $s ) = @_;
    my ($r_idx) = grep { $list[$_] eq $r } ( 0 .. $#list );
    my ($s_idx) = grep { $list[$_] eq $s } ( 0 .. $#list );
    $list[$s_idx] = $r;
    $list[$r_idx] = $s;
}
