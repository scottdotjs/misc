#!/usr/bin/perl

use warnings;
use strict;

use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', 'links.csv') or die $!;
select $OUT;
$| = 1;

# TODO:
# Output number of items to process
# Do a progress bar thing (find a fancy module for it)

while (<DATA>) {
	$mech->get($_);

	if ($mech->success) {
	 	my ($target) = $mech->response->decoded_content =~ /content="0;URL=(.*?)"/;

	 	print $OUT "$target\n";
	} else {
		print STDERR $mech->response->status_line, "\n";
	}

 	sleep 2;
}

__DATA__
