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
	
	plan tests => @subs_to_test + 2;
}

use Secure::UID;

ok(1);	# Module loaded.

# Ensure that attempting to check a non-existant subroutine fails.
# This is a sanity check.

{
	no warnings 'once';
	ok(defined(*{Secure::UID::no_such_sub}{CODE}),"",
		"no_such_sub appears defined.\n");
}

foreach my $sub (@subs_to_test) {
	no strict 'refs';
	ok(defined(*{"Secure::UID::$sub"}{CODE}),1,"$sub is not defined");
}
