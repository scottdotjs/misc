#!/usr/bin/perl

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use Getopt::Long;
use HTML5::DOM;
use Progress::Any '$progress';
use Progress::Any::Output 'TermProgressBarColor';
use URI::Escape;
use WWW::Mechanize;

# TODO:
# Command line options:
# - tweet URL
# - tweets list
# - IA disc URLs list
# Actually get the audio file
# Write the year into it (Audio::Metadata looks promising)

my $OUTPUT_FILE = '78_downloads_list.csv';

GetOptions(
	"outputfile=s" => \$OUTPUT_FILE
) or die("Error in command line arguments\n");

my $app = {};

sub fetch (%options) {
	my $mech = $app->{'mech'};
	my $url  = $options{'url'  };
	my $side = $options{'side' };

	die "Not an IA URL: $url" if $url !~ m{https://archive.org/};

	$progress->update(message => 
		'Processing disc ' . $app->{'discs_processed'} . '/' . $app->{'total_discs'}
		. " side $side "
	);

	my $html = get_html($url);
	my $tree = HTML5::DOM->new->parse($html);

	my $download = 'https://archive.org' . $tree->querySelector('#quickdown1 > .format-file a')->attr('href');
	my ($track_info) = uri_unescape($download) =~ m{.*/(.*?)\.flac$};
	my ($title, $artist) = split(/ - /, $track_info);

	open (my $OUT, '>>', $OUTPUT_FILE) or die $!;
	print $OUT "$url\t$artist\t$title\t$download\n";
	close $OUT;

	if ($side eq 'A') {
		my $other_side_found = $tree->querySelector('p.content')->nextSibling->querySelector('a')->attr('href');

		if ($other_side_found) {
			$progress->target(++$app->{'target'});

			fetch((
				url   => 'https://archive.org' . $other_side_found,
				side  => 'B'
			));
		}
	}
}

sub get_html ($url) {
	my $mech = $app->{'mech'};
	$mech->get($url);

	if (!$mech->success) {
		die $mech->response->status_line;
	}

	return $mech->response->decoded_content;
}

sub write_csv_header {
	open (my $OUT, '>', $OUTPUT_FILE) or die $!;
	print $OUT "Track page URL\tArtist\tTitle\tDownload URL\n";
	close $OUT;
}

sub deshorten ($url) {
	my $mech = $app->{'mech'};
	$mech->get($url);

	if (!$mech->success) {
		die $mech->response->status_line;
	}
	 
	my ($destination) = $mech->response->decoded_content =~ /content="0;URL=(.*?)"/;

	return $destination;
}

sub main {
	my $mech = WWW::Mechanize->new();
	$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');	
	$app->{'mech'} = $mech;

	write_csv_header();

	chomp(my @input = <DATA>);

	$app->{'total_discs'    } = $#input + 1;
	$app->{'target'         } = $app->{'total_discs'};
	$app->{'discs_processed'} = 0;

	$progress->target($app->{'target'});

	foreach my $disc (@input) {
		$app->{'discs_processed'}++;

		fetch((
			url   => ($disc =~ /t\.co/) ? deshorten($disc) : $disc,
			side  => 'A'
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
