/* XSUB bindings for Proc::UID.pm
 *
 * Paul Fenwick	<pjf@cpan.org>
 *
 * Copyright (c) 2004 Paul Fenwick.  All Rights reserved.  This
 * program is free software; you can redistribute it and/or modify
 * it under the same terms as Perl itself.
 *
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* This current works for Linux, what about other operating systems? */
#include <unistd.h>

MODULE = Proc::UID  PACKAGE = Proc::UID

PROTOTYPES: DISABLE

# Low-level calls to get our privileges.
# These *should* always return the same as $< and $>, $( and $)

int geteuid()
	CODE:
		RETVAL = geteuid();
	OUTPUT:
		RETVAL

int getruid()
	CODE:
		RETVAL = getuid();
	OUTPUT:
		RETVAL

int getegid()
	CODE:
		RETVAL = getegid();
	OUTPUT:
		RETVAL

int getrgid()
	CODE:
		RETVAL = getgid();
	OUTPUT:
		RETVAL

# Get our saved UID/GID

int
getsuid()
	PREINIT:
		int ret;
		int ruid, euid, suid;
	CODE:
		ret = getresuid(&ruid, &euid, &suid);
		if (ret == -1) {
			RETVAL = -1;
		} else {
			RETVAL = suid;
		}
	OUTPUT:
		RETVAL

# Get our saved GID 

int
getsgid()
	PREINIT:
		int ret;
		int rgid, egid, sgid;
	CODE:
		ret = getresgid(&rgid, &egid, &sgid);
		if (ret == -1) {
			RETVAL = -1;
		} else {
			RETVAL = sgid;
		}
	OUTPUT:
		RETVAL

void
setsuid(suid)
		int suid;
	CODE:
		if (setresuid(-1,-1,suid) == -1) {
			croak("Could not set saved UID");
		}

void
setuid_permanent(uid)
		int uid;
	CODE:
		if (setresuid(uid,uid,uid) == -1) {
			croak("Could not drop privileges in setuid_permanent");
		}
		# If we don't update Perl's special variables directly,
		# then Perl doesn't believe we've changed UIDs.  Oh dear!
		PL_uid = uid;
		PL_euid = uid;
