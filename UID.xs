/* XSUB bindings for Proc::UID.pm
 *
 * Paul Fenwick	<pjf@cpan.org>
 *
 * Copyright (c) 2004 Paul Fenwick.  All Rights reserved.  This
 * program is free software; you can redistribute it and/or modify
 * it under the same terms as Perl itself.
 *
 */

/* TODO: Everything here uses type 'int' when it should use type
 * 'uid_t'.  On most systems they're the same, but we should not assume.
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

# Set our saved UID.

void
setsuid(suid)
		int suid;
	CODE:
		if (setresuid(-1,-1,suid) == -1) {
			croak("Could not set saved UID");
		}

# Set our saved GID.
void
setsgid(sgid)
		int sgid;
	CODE:
		if (setresgid(-1,-1,sgid) == -1) {
			croak("Could not set saved GID");
		}

# Preferred calls.

# drop_uid_temp - Drop privileges temporarily.
# Moves the current effective UID to the saved UID.
# Assigns the new_uid to the effective UID.
# Updates PL_euid
void
drop_uid_temp(new_uid)
		int new_uid;
	CODE:
		if (setresuid(-1,new_uid,geteuid()) < 0) {
			croak("Could not temporarily drop privs.");
		}
		if (geteuid() != new_uid) {
			croak("Dropping privs appears to have failed.");
		}
		PL_euid = new_uid;

# drop_uid_perm - Drop privileges permanently.
# Set all privileges to new_uid.
# Updates PL_uid and PL_euid
void
drop_uid_perm(new_uid)
		int new_uid;
	PREINIT:
		int ruid, euid, suid;
	CODE:
		if (setresuid(new_uid,new_uid,new_uid) < 0) {
			croak("Could not permanently drop privs.");
		}
		if (getresuid(&ruid, &euid, &suid) < 0) {
			croak("Could not check privileges were dropped.");
		}
		if (ruid != new_uid || euid != new_uid || suid != new_uid) {
			croak("Failed to drop privileges.");
		}
		PL_uid  = new_uid;
		PL_euid = new_uid;

void
restore_uid()
	PREINIT:
		int ruid, euid, suid;
	CODE:
		if (getresuid(&ruid, &euid, &suid) < 0) {
			croak("Could not verify privileges.");
		}
		if (setresuid(-1,suid,-1) < 0) {
			croak("Could not set effective UID.");
		}
		if (geteuid() != suid) {
			croak("Failed to set effective UID.");
		}
		PL_euid = suid;

# Now let's do the same for gid functions.
# TODO - Think about getgroups / setgroups, how do they best fit in?

void
drop_gid_temp(new_gid)
		int new_gid;
	CODE:
		if (setresgid(-1,new_gid,getegid()) < 0) {
			croak("Could not temporarily drop privs.");
		}
		if (getegid() != new_gid) {
			croak("Dropping privs appears to have failed.");
		}
		PL_egid = new_gid;


void
drop_gid_perm(new_gid)
		int new_gid;
	PREINIT:
		int rgid, egid, sgid;
	CODE:
		if (setresgid(new_gid,new_gid,new_gid) < 0) {
			croak("Could not permanently drop privs.");
		}
		if (getresgid(&rgid, &egid, &sgid) < 0) {
			croak("Could not check privileges were dropped.");
		}
		if (rgid != new_gid || egid != new_gid || sgid != new_gid) {
			croak("Failed to drop privileges.");
		}
		PL_gid  = new_gid;
		PL_egid = new_gid;

void
restore_gid()
	PREINIT:
		int rgid, egid, sgid;
	CODE:
		if (getresgid(&rgid, &egid, &sgid) < 0) {
			croak("Could not verify privileges.");
		}
		if (setresgid(-1,sgid,-1) < 0) {
			croak("Could not set effective GID.");
		}
		if (getegid() != sgid) {
			croak("Failed to set effective GID.");
		}
		PL_egid = sgid;

