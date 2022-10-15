#!/usr/bin/perl

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use HTML5::DOM;
use URI::Escape;
use WWW::Mechanize;

use constant TRUE => 1;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', '78_downloads_list.csv') or die $!;
$| = 1;

# TODO:
# Actually get the audio file
# Write the year into it (Audio::Metadata looks promising)

my $parser = HTML5::DOM->new;

sub get_html ($url) {
	$mech->get($url);

	if ($mech->success) {
		return $mech->response->decoded_content;
	} else {
		die $mech->response->status_line;
	}
}

sub fetch_side_a($url) {
	fetch($url, 'A', TRUE);
}

sub fetch_side_b($url) {
	fetch($url, 'B')
}

sub fetch ($url, $side, $get_other_side = 0) {
	die "Not an IA URL: $url" if $url !~ m{https://archive.org/};

	my $html = get_html($url);
	my $tree = $parser->parse($html);

	my $download = 'https://archive.org' . $tree->querySelector('#quickdown1 > .format-file a')->attr('href');
	my ($track_title) = uri_unescape($download) =~ m{.*/(.*?)\.flac$};

	print "$side. $track_title\n";
	print $OUT "$url\t$download\n";

	if ($get_other_side) {
		my $other_side_found = $tree->querySelector('p.content')->nextSibling->querySelector('a')->attr('href');

		if ($other_side_found) {
			fetch_side_b('https://archive.org' . $other_side_found);
		}
	}

}

sub deshorten ($url) {
	$mech->get($url);

	if ($mech->success) {
	 	my ($target) = $mech->response->decoded_content =~ /content="0;URL=(.*?)"/;

	 	return $target;
	} else {
		die $mech->response->status_line;
	}
}

chomp(my @input = <DATA>);

print $#input + 1 . " discs to process.\n";

my $count = 0;

foreach my $item (@input) {
	$count++;

	print "\n[$count]\n";

	my $url = $item;

	$url = deshorten($url) if ($url =~ /t\.co/);

	fetch_side_a($url);

	sleep 2;
}

# Example tweet format:
# the music goes round & round (1956) - paul gayton https://t.co/cFzMh3sVAt https://t.co/ignorethislink

__DATA__
https://t.co/cFzMh3sVAt
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
