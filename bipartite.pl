#!/usr/bin/env perl

use strict;
use warnings;

use Algorithm::Munkres;

my $lf = {};
my $rf = {};

my $lfr = {};
my $rfr = {};

my $im = [];
my $om = [];

my $lnext = 0;
my $rnext = 0;

my $maxweight = 0;

while(my $line = <STDIN>) {

	chomp $line;

	my ( $weight, $l, $r ) = split(/(?<!\\),/, $line);

	$l =~ s/\\,/,/g;
	$r =~ s/\\,/,/g;

	unless(exists $lfr->{$l}) {
		$lfr->{$l} = $lnext;
		$lf->{$lnext} = $l;
		$im->[$lnext] = [];
		$lnext++;
	}

	unless(exists $rfr->{$r}) {
		$rfr->{$r} = $rnext;
		$rf->{$rnext} = $r;
		$rnext++;
	}

	my $li = $lfr->{$l};
	my $ri = $rfr->{$r};

	$im->[$li]->[$ri] = $weight;

	$maxweight = $weight if($weight > $maxweight);
}

foreach my $row (@$im) {
	foreach my $item (@$row) {
		$item //= $maxweight;
		#$item = $maxweight - $item;
	}
}

assign($im, $om);

foreach my $li (0..$#$om) {

	my $ri = $om->[$li];

	my $l = $lf->{$li};
	my $r = $rf->{$ri};

	$l //= "";
	$r //= "";

	$l =~ s/"/\\"/g;
	$r =~ s/"/\\"/g;

	print "\"$l\" => \"$r\"\n";
}
