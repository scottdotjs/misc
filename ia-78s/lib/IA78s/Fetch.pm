package IA78s::Fetch;

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(fetch get_dom get_track_metadata);

use HTML5::DOM;
use URI::Escape;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');	

sub fetch ($url) {
	$mech->get($url);

	die $mech->response->status_line if !$mech->success;

	return $mech->response->decoded_content;
}

sub get_dom ($html) {
	return HTML5::DOM->new->parse($html);
}

sub get_track_metadata ($url, $side) {
	my $fetch_url;

	if ($url =~ m{^https://t\.co/[A-Za-z0-9]+$}) {
		$mech->get($url);
		($fetch_url) = $mech->response->decoded_content =~ /content="0;URL=(.*?)"/;
	} else {
		$fetch_url = $url;
	}

	my $dom = get_dom(fetch($fetch_url));

	my $download = 'https://archive.org' . $dom->querySelector('#quickdown1 > .format-file a')->attr('href');
	my ($flac_file) = uri_unescape($download) =~ m{.*/(.*?)\.flac$};
	my ($title, $artist) = split(/ - /, $flac_file);

	my $track = {
		'url'     => $fetch_url, 
		'artist'  => $artist,
		'title'   => $title,
		'download' => $download
	};

	my $date_published = $dom->querySelector('span[itemprop="datePublished"]')->innerHTML();
	my ($year) = $date_published =~ /^(\d{4})/;

	$track->{'year'} = $year if $year;

	if ($side eq 'A') {
		my $other_side_found = $dom->querySelector('p.content')->nextSibling->querySelector('a')->attr('href');
	
		if ($other_side_found) {
			$track->{'other_side'} = 'https://archive.org' . $other_side_found;
		}
	}

	return $track;
}

return 1;
