#!/usr/bin/env perl

use strict;
use warnings;

use Algorithm::Munkres;

my $input_matrix = [];
my $match_vector = [];

while(my $line = <STDIN>) {

	chomp $line;

	push @{$input_matrix}, [ map { int($_); } split(/\s+/, $line) ];
}

assign($input_matrix, $match_vector);

my $i = 0;

while($i < scalar(@{$match_vector})) {

	my $j = $match_vector->[$i];
	my $w = $input_matrix->[$i]->[$j];

	printf("%d,%d,%d\n",$i,$j,$w);

	$i++;
}
