package IA78s::Process;

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use IA78s::Fetch qw(fetch get_dom get_track_metadata);
use IA78s::Output qw(write_track_details);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(process_list);

my $app;

sub process_list (%options) {
	$app = $options{'app'};
	
	foreach my $item ($options{'input'}->@*) {
		if ($item =~ m{^https://twitter.com/78_sampler/status/\d+$}) {
			process_tweet($item);
		} elsif (
			$item =~ m{^https://archive.org/details/[\w-]+$} ||
			$item =~ m{^https://t\.co/[A-Za-z0-9]+$}
		) {
			process_disc({
				'url'  => $item,
				'side' => 'A'
			});
		} else {
			process_tweet_text($item);
		}

		sleep 2;
	}
}

sub process_disc ($options) {
	my $url  = $options->{'url' };
	my $side = $options->{'side'};

	$app->{'discs_processed'}++;
	$app->{'progress'}->update(message => 
		qq(Processing disc $app->{'discs_processed'}/$app->{'total_discs'} side $side )
	);

	my $track = get_track_metadata($url, $side);

	write_track_details(
		$app->{'output_file'},
		$track
	);

	if ($track->{'other_side'}) {
		# Not working?
		$app->{'progress'}->target(++$app->{'target'});

		process_disc({
			url  => $track->{'other_side'},
			side => 'B'
		});
	}
}

# TODO
sub process_tweet ($url) {
	my $dom = get_dom(fetch($url));
	# $dom->querySelector('[data-testid="tweetText"]')
}

sub process_tweet_text ($text) {
	# title (year) - artist https://t.co/abcdef 
	my ($year, $link) = $text =~ m{(.*?) \((\d{4})\) .*? (https://t\.co/.*?) };

	if ($year && $link) {
		# TODO
	}
}

return 1;
