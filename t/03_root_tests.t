#!/usr/bin/perl -wT
use strict;
use Test;

# These tests are to ensure that Proc::UID's functions operate
# correctly when running as true root (as opposed to suid root).

BEGIN {
	if ($< == 0 and $> == 0) {
		plan tests => 16;
	} else {
		print "1..0 # Skipped, this file must be run as root.\n";
		exit 0;
	}
}

my $TEST_UID = 1000;	# Any non-root UID.

use Proc::UID qw(geteuid getruid getsuid
		 seteuid setruid setsuid);

ok(1);	# Loaded Proc::UID.

# 3 tests
# First, make sure we really look like root.
ok(geteuid(),0,"Effective UID not 0");
ok(getruid(),0,"Real UID not 0");
ok(getsuid(),0,"Saved UID not 0");

# 12 tests
# Now, let's try changing our UIDs around.
# We take each UID, change it, then change it back again.

ok(eval {seteuid($TEST_UID); "ok"},"ok","Could not set effective UID");
ok($>,$TEST_UID,"Effective UID not changed.");
ok(eval {seteuid(0); "ok"},"ok","Could not reset effective UID");
ok($>,0,"Effective UID not reset.");

ok(eval {setruid($TEST_UID); "ok"},"ok","Could not set real UID");
ok($<,$TEST_UID,"Real UID not changed.");
ok(eval {setruid(0); "ok"},"ok","Could not reset effective UID");
ok($<,0,"Real UID not reset.");

ok(eval {setsuid($TEST_UID); "ok"},"ok","Could not set saved UID");
ok(getsuid(),$TEST_UID,"Saved UID not changed.");
ok(eval {setsuid(0); "ok"},"ok","Could not reset effective UID");
ok(getsuid(),0,"Saved UID not reset.");
