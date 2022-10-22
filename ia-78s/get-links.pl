#!/usr/bin/perl

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

use lib 'lib';

use Getopt::Long;
use Progress::Any;
use Progress::Any::Output 'TermProgressBarColor';

use IA78s::Output qw(write_csv_header);
use IA78s::Process qw(process_list);

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

sub main {
	write_csv_header($app->{'output_file'});

	chomp(my @input = <DATA>);

	$app->{'progress'       } = Progress::Any->get_indicator(task => 'dl');
	$app->{'total_discs'    } = $#input + 1;
	$app->{'target'         } = $app->{'total_discs'};
	$app->{'discs_processed'} = 0;

	$app->{'progress'}->target($app->{'target'});

	process_list(
		app   => $app,
		input => \@input
	);

	$app->{'progress'}->finish(message => 'Done.');
}

main();

__DATA__
https://t.co/cFzMh3sVAt
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
the music goes round & round (1956) - paul gayton https://t.co/cFzMh3sVAt https://t.co/ignorethislink