package IA78s::Output;

use warnings;
use strict;

use utf8;
use open qw(:std :utf8);

use feature 'signatures';
no warnings 'experimental::signatures';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(write_csv_header write_track_details);

sub write_csv_header ($output_file) {
	open (my $OUT, '>', $output_file) or die $!;

	print $OUT "Track page URL\tArtist\tTitle\tYear\tDownload URL\n";

	close $OUT;
}

sub write_track_details ($output_file, $track) {
	open (my $OUT, '>>', $output_file) or die $!;

	foreach (qw(url artist title year download)) {
		print $OUT "$track->{$_}\t" if $track->{$_};
	}

	close $OUT;
}
