#!/usr/bin/perl

=pod

=head1 NYT Spelling Bee Solver

=head2 SYNOPSIS

This program solves the New York Times' daily wordsearch puzzle
L<Spelling Bee|https://www.nytimes.com/puzzles/spelling-bee>, which gives you
seven letters arranged as a hexagon, and challenges you to find as many words
as possible that are four or more letters, only made from the seven letters,
and contain the center letter.

=cut

use warnings;
use strict;

use feature 'say'; # I can't believe you still have to do this in 2021

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

use constant LETTERS_REQUIRED => 7;
use constant DICTIONARY_PATH => '/usr/share/dict/words';

my $args = process_arguments(@ARGV);

my @all_matches = get_all_matches();

print_header();

if ($args->{nyt_mode}) {
	show_matches_alphabetically(@all_matches);
} else {
	show_matches_by_length(@all_matches);
}

# ----------------------------------------------------------------------------

sub get_all_matches {
	my $center_letter = $args->{center_letter};
	my @other_letters = $args->{other_letters}->@*;
	my @all_letters   = ($center_letter, @other_letters);

	open(my $DICTIONARY, '<', DICTIONARY_PATH) or die $!;
	chomp(my @all_words = <$DICTIONARY>);
	close $DICTIONARY;

	return
		map { length > 3 ? $_ : () }
		grep { /^[@all_letters]+$/ }
		grep { /[$center_letter]+/ } @all_words;
}

# Me: Mom can we have argument parsing?
# Mom: We have argument parsing at home.
# Argument parsing at home:
sub process_arguments {
	my @arguments = @_;
	my (@letters, $nyt_mode, $letter_list);

	if (scalar @arguments == 2 && $arguments[0] ne '--nyt') {
		error('Invalid option. Try --nyt.');
	} elsif (scalar @arguments == 2) {
		$nyt_mode = 1;
		$letter_list = $arguments[1];
	} elsif (scalar @arguments == 1) {
		$letter_list = $arguments[0];
	} else {
		error(
			"Specify a list of ${\LETTERS_REQUIRED} letters starting with center letter.\n" .
			'For NYT-style output specify --nyt first.'
		);
	}

	validate_letters($letter_list);
	@letters = split '', lc $letter_list;

	return {
		center_letter => $letters[0],
		other_letters => [ @letters[1..6] ],
		nyt_mode      => $nyt_mode
	};
}

sub validate_letters {
	my $letters = $_[0];

	error("Please specify ${\LETTERS_REQUIRED} letters.")
		if $letters !~ /^[A-Za-z]{7}$/;

	my %seen_letters = map { $_ => 1 } split '', lc $letters;

	error('All letters must be different.')
		if scalar keys %seen_letters < LETTERS_REQUIRED;
}

sub error {
	say BRIGHT_RED $_[0];
	exit;
}

sub print_header {
	print BOLD BRIGHT_RED uc $args->{center_letter}, ' ';
	print BOLD CYAN uc $_, ' ' foreach sort $args->{other_letters}->@*;
	print "\n";
}

sub is_pangram {
	my @all_letters = ( $args->{center_letter}, $args->{other_letters}->@* );

	return scalar keys { map { $_ => 1 } split '', $_[0] }->%* == scalar @all_letters;
}

sub show_matches_alphabetically {
	my (@pangrams, @normal);

	is_pangram($_) ? push @pangrams, ucfirst $_ : push @normal, ucfirst $_ foreach @_;

	say BRIGHT_YELLOW $_ foreach sort @pangrams;
	say foreach sort @normal;
}

sub show_matches_by_length {
	my %matches;
	$matches{length $_}{$_} = 1 foreach @_;

	foreach my $length (sort { $b <=> $a } keys %matches) {
		say BOLD "$length letters";

		say join ', ',
			map { is_pangram($_) ? BRIGHT_YELLOW $_ : $_ }
			sort keys $matches{$length}->%*;
	}
}

=pod

=head2 USAGE

The program takes a basic argument of a list of seven letters. Specify the
center letter from the puzzle first. Case doesn't matter.

 ./spelling-bee.pl wahorty
 ./spelling-bee.pl WAHORTY

Find words for the specified letters, of which the center letter is W. The
results will be shown grouped by length. Pangrams (words that include all the
letters) are highlighted in yellow. Note that the results you get will be
whatever's in your system's dictionary file, but the actual answers to the
puzzle are curated by hand to not include anything obscure or saucy.

You can also optionally specify the flag C<--nyt> to show the results in the
style that the NYT shows the solution to the preceding day's puzzle - pangrams
first, followed by all other words in alphabetical order. Also capitalized,
because the NYT loves that.

 ./spelling-bee.pl --nyt wahorty

=head2 SYSTEM REQUIREMENTS

This program expects to to find a dictionary file at C</usr/share/dict/words>.
If your system keeps its dictionary somewhere else, you can change the path
defined at the start of the program.

=head2 LICENSE

This software is released under the L<MIT License|https://opensource.org/licenses/MIT>:

Copyright 2021 Scott Martin.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=head2 AUTHOR

L<Scott Martin|https://github.com/scottdotjs/>

=cut
