#!/usr/bin/perl

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use lib 'lib';

use Getopt::Long;
use Progress::Any '$progress';
use Progress::Any::Output 'TermProgressBarColor';

use IA78s::Fetch qw(get_track_metadata);
use IA78s::Output qw(write_csv_header write_track_details);

# TODO:
# Command line options:
# - tweet URL
# - input file
# Actually get the audio file
# Write the year into it (Music::Tag looks promising)

my $app = {
	'output_file' => '78_downloads_list.csv'
};

GetOptions(
	"outputfile=s" => \$app->{'output_file'}
) or die("Error in command line arguments\n");

sub process_disc ($options) {
	my $url  = $options->{'url' };
	my $side = $options->{'side'};

	$app->{'discs_processed'}++;
	$progress->update(message => 
		qq(Processing disc $app->{'discs_processed'}/$app->{'total_discs'} side $side )
	);

	my $track = get_track_metadata($url, $side);

	write_track_details(
		$app->{'output_file'},
		$track
	);

	if ($track->{'other_side'}) {
		$progress->target(++$app->{'progress'});

		process_disc({
			url  => $track->{'other_side'},
			side => 'B'
		});
	}
}

# TODO
sub process_tweet ($url) {
	my $dom = get_dom($url);
	# $dom->querySelector('[data-testid="tweetText"]')
}

sub process_tweet_text ($text) {
	# title (year) - artist https://t.co/abcdef 
	my ($year, $link) = $text =~ m{(.*?) \((\d{4})\) .*? (https://t\.co/.*?) };

	if ($year && $link) {
		# TODO
	}
}

sub process_list (@input) {
	foreach my $item (@input) {
		if ($item =~ m{^https://twitter.com/78_sampler/status/\d+$}) {
			process_tweet($item);
		} elsif ($item =~ m{^https://archive.org/details/[\w-]+$}) {
			process_disc({
				'url'  => $item,
				'side' => 'A'
			});
		} elsif ($item =~ m{^https://t\.co/[A-Za-z0-9]+$}) {
			# TODO: deshorten and fetch $item
			# TODO: merge deshortening into fetch
		} else {
			process_tweet_text($item);
		}

		sleep 2;
	}
}

sub main {
	write_csv_header($app->{'output_file'});

	chomp(my @input = <DATA>);

	$app->{'total_discs'    } = $#input + 1;
	$app->{'progress'       } = $app->{'total_discs'};
	$app->{'discs_processed'} = 0;

	$progress->target($app->{'progress'});

	process_list(@input);

	$progress->finish(message => 'Done.');
}

main();

__DATA__
https://t.co/cFzMh3sVAt
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
the music goes round & round (1956) - paul gayton https://t.co/cFzMh3sVAt https://t.co/ignorethislink