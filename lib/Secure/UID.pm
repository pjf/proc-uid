=head1 NAME

Secure::UID - Manipulate a variety of UID and GID settings.

=head1 SYNOPSIS

	use Secure::UID qw(

=head1 DESCRIPTION

Perl only has concepts of effective and real UIDs, whereas a
number of operating systems have further concepts, such as saved
UIDs.  This module is intended to provide a way for those additional
UIDs to be manipulated.

A number of functions are provided to perform logical operations,
such as irrevocably dropping privileges.

=head1 BUGS

Many operating systems have different interfaces into their
extra UIDs.  This module has not yet been tested under all of
them.

=head1 AUTHOR

Paul Fenwick	pjf@cpan.org

Copyright (c) 2004 Paul Fenwick.  All rights reserved.  This
program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

perlsec and perlvar

=cut

package Secure::UID;
use strict;
use warnings;

our $VERSION = 0.01;

# These are included for completeness.

sub getruid { return $< };
sub geteuid { return $> };
sub getrgid { return $( };
sub getegid { return $) };

# These *should* be expanded to actually check the operation succeeded.

sub setruid { $< = $_[0]; }
sub seteuid { $> = $_[0]; }
sub setrgid { $( = $_[0]; }
sub setegid { $) = $_[0]; }

# Our story begins trying to load the syscall.ph file.  Without this,
# we don't have access to any system calls.  That makes any sort of
# UID manipulation very difficult.

# Try to get access to our available system calls.

eval {
	require 'syscall.ph';
};

if ($@) {
	die "Could not load syscall.ph in Secure::UID.\n$@\n";
}

# Now, if we have syscall loaded, we can see what functions we have
# available to us.  Currently we only look for setresuid(2).

if (*SYS_setresuid{CODE}) {
	*setsuid = sub { syscall(&SYS_setresuid,-1,-1,$_[0]+0); };
	*setuid_permanent = sub { syscall(&SYS_setresuid,$_[0]+0,$_[0]+0,$_[0]+0); };
} else {
	die "Cannot locate SYS_setresuid";
}

1;
