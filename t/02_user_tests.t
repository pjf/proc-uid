#!/usr/bin/perl -wT
use strict;
use Test;

# These tests are to ensure that Proc::UID's provide sane results.
# These do not assume any special privileges.

BEGIN { plan tests => 4; }

use Proc::UID qw(geteuid getruid getsuid);

ok(1);	# Loaded Proc::UID.

# These make sure that our functions agree with our variables.

ok(geteuid(),$>,"geteuid not the same as \$>");
ok(getruid(),$<,"getruid not the same as \$<");
ok(getsuid(),$>,"getsuid not the same as original \$>");
