#!/usr/bin/perl -w
use strict;
use Test;
my @subs_to_test;
BEGIN { 

	my $EXTRA_TESTS = 6;

	@subs_to_test= qw(
		getruid geteuid getrgid getegid
		setruid seteuid setrgid setegid
		getsuid getsgid
		setsuid
		setuid_permanent
	);
	
	plan tests => @subs_to_test + $EXTRA_TESTS;
}

use Secure::UID;

# Extra Test 1.
ok(1);	# Module loaded.

# Extra Test 2.
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

# Extra Test 3 & 4
# Test getting our saved UID.

ok(Secure::UID::getsuid() != -1,1,"Failed call to getsuid");
ok(Secure::UID::getsuid(),$<,"Saved UID is not equal to Real UID");

# Extra Test 3 & 4
# Test getting our saved GID.

ok(Secure::UID::getsgid() != -1,1,"Failed call to getsgid");
ok(Secure::UID::getsgid(),$(+0,"Saved GID is not equal to Real GID");
