#!/usr/bin/perl -wT
use strict;
use Test;

# These tests are to ensure that Proc::UID's provide sane results.
# These do not assume any special privileges.

BEGIN { plan tests => 10; }

use Proc::UID qw(geteuid getruid getsuid getsgid getrgid getegid
		 $SUID $SGID $RUID $RGID $EUID $EGID);

ok(1);	# Loaded Proc::UID.

# These make sure that our functions agree with our variables.

ok(geteuid(),$>,"geteuid not the same as \$>");
ok(getruid(),$<,"getruid not the same as \$<");
ok(getsuid(),$>,"getsuid not the same as original \$>");

# Make sure our variables look sensible.

ok($SUID,getsuid(),"\$SUID and getsuid() do not match\n");
ok($SGID,getsgid(),"\$SGID and getsgid() do not match\n");

ok($RUID,getruid(),"\$RUID and getruid() do not match\n");
ok($RGID,getrgid(),"\$RGID and getrgid() do not match\n");

ok($EUID,geteuid(),"\$EUID and geteuid() do not match\n");
ok($EGID,getegid(),"\$EGID and getegid() do not match\n");
