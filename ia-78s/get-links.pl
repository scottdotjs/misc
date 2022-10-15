#!/usr/bin/perl

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use HTML5::DOM;
use Progress::Any '$progress';
use Progress::Any::Output 'TermProgressBarColor';
use URI::Escape;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', '78_downloads_list.csv') or die $!;
$| = 1;

# TODO:
# Actually get the audio file
# Write the year into it (Audio::Metadata looks promising)

my $parser = HTML5::DOM->new;

my $target;

sub get_html ($url) {
	$mech->get($url);

	if (!$mech->success) {
		die $mech->response->status_line;
	}

	return $mech->response->decoded_content;
}

sub fetch (%options) {
	my $url   = $options{'url'  };
	my $side  = $options{'side' };
	my $disc  = $options{'disc' };
	my $total = $options{'total'};

	die "Not an IA URL: $url" if $url !~ m{https://archive.org/};

	$progress->update(message => "Processing disc $disc/$total side $side ");

	my $html = get_html($url);
	my $tree = $parser->parse($html);

	my $download = 'https://archive.org' . $tree->querySelector('#quickdown1 > .format-file a')->attr('href');
	my ($track_info) = uri_unescape($download) =~ m{.*/(.*?)\.flac$};
	my ($title, $artist) = split(/ - /, $track_info);

	print $OUT "$url\t$artist\t$title\t$download\n";

	if ($side eq 'A') {
		my $other_side_found = $tree->querySelector('p.content')->nextSibling->querySelector('a')->attr('href');

		if ($other_side_found) {
			$progress->target(++$target);

			fetch((
				url   => 'https://archive.org' . $other_side_found,
				side  => 'B',
				disc  => $disc,
				total => $total
			));
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

sub main {
	chomp(my @input = <DATA>);

	my $total = $#input + 1;
	$target = $total;

	$progress->target($target);

	my $disc = 0;

	print $OUT "Track page URL\tArtist\tTitle\tDownload URL\n";

	foreach my $item (@input) {
		fetch((
			url   => ($item =~ /t\.co/) ? deshorten($item) : $item,
			side  => 'A',
			disc  => ++$disc,
			total => $total
		));

		sleep 2;
	}

	$progress->finish(message => 'Done.');
}

main();

# Example tweet format:
# the music goes round & round (1956) - paul gayton https://t.co/cFzMh3sVAt https://t.co/ignorethislink

__DATA__
https://t.co/cFzMh3sVAt
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
