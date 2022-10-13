#!/usr/bin/perl

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use HTML5::DOM;
use WWW::Mechanize;

use constant TRUE => 1;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', 'other_sides.csv') or die $!;
$| = 1;

# TODO:
# Output number of items to process
# Do a progress bar thing (find a fancy module for it)

my $parser = HTML5::DOM->new;

sub get_html ($url) {
	$mech->get($url);

	if ($mech->success) {
		return $mech->response->decoded_content;
	} else {
		die $mech->response->status_line;
	}
}

sub fetch ($url, $get_other_side = 0) {
	print "Fetch: $url\n";

	my $html = get_html($url);
	my $tree = $parser->parse($html);

	my $download = 'https://archive.org' . $tree->querySelector('#quickdown1 > .format-file a')->attr('href');

	print "$download\n\n";
	print $OUT "$url\t$download\n";

	if ($get_other_side) {
		my $other_side_found = $tree->querySelector('p.content')->nextSibling->querySelector('a')->attr('href');

		if ($other_side_found) {
			fetch('https://archive.org' . $other_side_found);
		}
	}

}

while (<DATA>) {
	chomp;

	fetch($_, TRUE);

	sleep 2;
}

__DATA__
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
https://archive.org/details/78_aint-it-a-crime_julia-lee-and-her-boy-friends-julia-lee-baby-lovett-vic-dickenson_gbia0206089b
