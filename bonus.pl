#!/usr/bin/perl
# Advent of Code 2016 - Bonus problem, part 1
# Problem link: https://www.reddit.com/r/adventofcode/comments/72aizu/bonus_challenge/
# based on 2016 day 12
# input: file called 'input.txt', from the link above
# output: pipe to file 'input2.txt', for input to part 2
#      License: http://gerikson.com/files/AoC2016/UNLICENSE
###########################################################
use 5.016;    # implies strict, provides 'say'
use warnings;
use autodie;
use Data::Dumper;
#### INIT - load input data into array
my $testing = 0;
my $part    = 1;
my $debug   = 0;
my $print   = 0;
my @input;

my $file = $testing ? 'test.txt' : 'input.txt';

{
    open( my $fh, '<', "$file" );
    while (<$fh>) { chomp; s/\r//gm; push @input, $_; }
}

### CODE
my %reg = map { $_ => 0 } qw(a b c d);

my @instr;
while (@input) {
    my ( $cmd, $arg1, $arg2 );
    my $line = shift @input;
    if ( $line =~ m/^(inc|dec|out) (.*)$/ ) {
	push @instr, [ $1, $2, undef ]
    }    elsif ( $line =~ /^cpy (\S+) (\S+)$/ ) {
	push @instr, [ 'cpy', $1, $2 ]
    }
    elsif ( $line =~ /^jnz (\S+) (\S+)$/ ) {
        push @instr, [ 'jnz', $1, $2 ];
    } else {
        die "cannot parse $line";
    }
}
if ($print) {
    my $ln = 0;
    foreach my $el (@instr) {
        printf "%4d: %3s %5s %5s\n", $ln,
            map { defined($_) ? $_ : '_' } @{$el};
        $ln++;
    }
    exit 0;
}
my %freq;

sub dump_state {
    my ( $count, $instr, $next_pos ) = @_;
    printf( "%5d: %3s %5s %5s => [%5d %5d %5d %5d] next=%5d\n",
            $count,
            map { defined $_ ? $_ : '_' } @{$instr},
            ( map { $reg{$_} } qw/a b c d/ ), $next_pos );
    $freq{$next_pos}++;

}

my $pos   = 0;
my $count = 0;
while ( $pos >= 0 and $pos <= $#instr ) {
    my $curr_instruction = $instr[$pos];
    my ( $cmd, $a1, $a2 ) = @{$curr_instruction};

    $count++;
    if ( $cmd eq 'inc' ) {
        $reg{$a1} += 1;
        $pos++;

    } elsif ( $cmd eq 'dec' ) {
        $reg{$a1} -= 1;
        $pos++;
    } elsif ( $cmd eq 'out' ) {
        $a1 = $a1 =~ /[a-d]/ ? $reg{$a1} : $a1;
        print chr($a1);
        $pos++;

    } elsif ( $cmd eq 'cpy' ) {

        # can either copy integer or content of other register
        if   ( $a1 =~ /\-?\d+/ ) { $reg{$a2} = $a1 }
        else                     { $reg{$a2} = $reg{$a1} }
        $pos++;

    } elsif ( $cmd eq 'jnz' ) {

        # first argument determines if to jump - if it's not zero
        # second argument: relative position
        # both arguments can be either natural numbers or content of registers
        ( $a1, $a2 ) = map { $_ =~ /[a-d]/ ? $reg{$_} : $_ } ( $a1, $a2 );
        if ( $a1 != 0 ) {
            $pos = $pos + $a2;
        } else {
            $pos++;
        }
    } else {
        die "unknown command: $cmd!";
    }

    dump_state( $count, $curr_instruction, $pos ) if $debug;
}

