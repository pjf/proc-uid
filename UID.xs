/* XSUB bindings for Secure::UID.pm
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

MODULE = Secure::UID  PACKAGE = Secure::UID

PROTOTYPES: DISABLE

# Get our saved UID

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

