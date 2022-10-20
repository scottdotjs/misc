package IA78s::Fetch;

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_track_metadata);

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

sub deshorten ($url) {
	my $content = fetch($url);
	 
	my ($destination) = $content =~ /content="0;URL=(.*?)"/;

	return $destination;
}

sub get_dom ($url) {
	return HTML5::DOM->new->parse(fetch($url));
}

sub get_track_metadata ($url, $side) {
	my $dom = get_dom($url);

	my $download = 'https://archive.org' . $dom->querySelector('#quickdown1 > .format-file a')->attr('href');
	my ($flac_file) = uri_unescape($download) =~ m{.*/(.*?)\.flac$};
	my ($title, $artist) = split(/ - /, $flac_file);

	my $track = {
		'url'     => $url, 
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
