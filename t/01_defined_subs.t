#!/usr/bin/perl -w
use strict;
use Test;
my @subs_to_test;
BEGIN { 
	@subs_to_test= qw(
		getruid geteuid getrgid getegid
		setruid seteuid setrgid setegid
		setsuid
		setuid_permanent
	);
	
	plan tests => @subs_to_test + 1 
}

use Secure::UID;

ok(1);	# Module loaded.

foreach my $sub (@subs_to_test) {
	no strict 'refs';
	ok(defined(*{"Secure::UID::$sub"}{CODE}),1,"$sub is not defined");
}
