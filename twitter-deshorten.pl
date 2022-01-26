#!/usr/bin/perl

use warnings;
use strict;

use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', 'links.csv') or die $!;
select $OUT;
$| = 1;

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
https://t.co/B8fpHEV7b2
https://t.co/uGkZ7XpSDZ
https://t.co/0URYUZvSAp