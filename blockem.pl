#!/usr/bin/perl -w

use strict;
use POSIX;
use Net::Twitter;

# Needs read/write access!

my %config = do 'config.pl';

# set up our twitter connection

my @idiots;

my $nt = Net::Twitter->new(
	traits			=> [qw/API::RESTv1_1/],
	ssl			=> 1,
	consumer_key		=> $config{consumer_key},
	consumer_secret		=> $config{consumer_secret},
	access_token		=> $config{access_token},
	access_token_secret	=> $config{access_secret}
);

# get a list of idiots
open B, '<', "block_ids.txt" or die "Can't open block_ids.txt: $!\n";
foreach ( <B> ) {
	chomp;
	push @idiots, $_;
}
close B;

$| = 1;

my $counter = 1;

foreach my $idiot ( @idiots ) {
	$counter = $counter + 1;
	eval {
		$nt->create_block({ user_id => $idiot, skip_status => 1});
	};
	if ( $@ ) { 
		if ( $@->isa('Net::Twitter::Error') ) {
			warn $@->error;
		} else {
			die $@;
		}
	}
	if ($counter % 10 == 0) {
		print ".";
	}
	if ($counter % 100 == 0) { 
			print "\n";
	}
	if ($counter % 1000 == 0) { 
			print "\n";
	}
}

print "\n\nDone!\n"
