#!/usr/bin/perl -wT
use strict;
use Test;

# These tests are to ensure that Proc::UID's functions operate
# correctly when running as true root (as opposed to suid root).

BEGIN {
	if ($< == 0 and $> == 0) {
		plan tests => 1;
	} else {
		print "1..0 # Skipped, this file must be run as root.\n";
		exit 0;
	}
}

use Proc::UID;

ok(1);	# Loaded Proc::UID.

