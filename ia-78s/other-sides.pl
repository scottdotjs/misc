#!/usr/bin/perl

use warnings;
use strict;

use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', 'other_sides.csv') or die $!;
$| = 1;

# TODO:
# Output number of items to process
# Do a progress bar thing (find a fancy module for it)

while (<DATA>) {
	$mech->get($_);

	if ($mech->success) {
		my $other_side = '';
	 	my ($other_side_found) = $mech->response->decoded_content =~ m{The recording on the other side of this disc: <a href="(.*?)" rel};

	 	if ($other_side_found) {
	 		$other_side = 'https://archive.org' . $other_side_found;
	 	}

	 	chomp(my $url = $_);
	 	print $OUT "$url\t$other_side\n";
	} else {
		print STDERR $mech->response->status_line, "\n";
	}

 	sleep 2;
}

__DATA__
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
