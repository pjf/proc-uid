=head1 NAME

Proc::UID - Manipulate a variety of UID and GID settings.

=head1 SYNOPSIS

	use Proc::UID qw(:vars);
	print "My saved-uid is $SUID, my real-uid is $RUID\n";

	use Proc::UID qw(setuid_permanent);
	print "Permanently dropping privileges to $new_uid\n";
	drop_priv_perm($new_uid); # Throws an exception on failure.


=head1 WARNING

This release of Proc::UID is for testing and review purposes only.
Please do not use it in production code.  The interface may change,
and the underlying code has not yet been rigourously tested.

If you discover any of the included tests fail, or that any other
problems with the code, please contact Paul Fenwick, pjf@cpan.org.

=head1 DESCRIPTION

Perl only has concepts of effective and real user-ids (UIDs) and 
group-ids (GIDs), accessible via the special variables $<, $>, $( and $).
However most modern Unix systems also have a concept of saved UIDs.

This module provides a consistent and logical interface to real,
effective, and saved UIDs and GIDs.  It also provides a way to
permanently drop privileges to that of a given user, a process
which '$< = $> = $uid' does not guarantee, and the exact syntax
of which may vary from between operating systems.

Proc::UID is also very pedantic about making sure that operations
succeeded, and checking the value which it returns for a UID/GID
really is the one that's being used.  Perl may sometimes cache
the values of $<, $>, $( and $), which means they can be wrong
after being changed with low-level system calls.

Proc::UID provides both a variable and function interfaces to
underlying UIDs.

=head2 VARIABLE INTERFACE

	To be compelted.

=head2 FUNCTIONAL INTERFACE

	To be completed.

=head2 PREFERRED INTERFACE

=over 4

=item B<drop_priv_temp($uid)>

=item B<drop_priv_perm($uid)>

=item B<restore_priv()>

=back

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

package Proc::UID;
use strict;
use warnings;
use XSLoader;
use Exporter;
use Carp;
use vars qw/$VERSION @ISA @EXPORT_OK $SUID $SGID $EUID $RUID $EGID $RGID/;

$VERSION = 0.02;
@ISA = qw(Exporter);
@EXPORT_OK = qw(	getruid geteuid getrgid getegid
			setruid seteuid setrgid setegid
			getsuid getsgid
			setsuid setsgid
			setuid_permanent
			$RUID $EUID $RGID $EGID $SUID $SGID);

# Most of our hard work is done in XS.
XSLoader::load 'Proc::UID';

# Ties for SUID/SGID

tie $SUID, 'Proc::UID::SUID';
tie $SGID, 'Proc::UID::SGID';
tie $EUID, 'Proc::UID::EUID';
tie $RUID, 'Proc::UID::RUID';
tie $EGID, 'Proc::UID::EGID';
tie $RGID, 'Proc::UID::RGID';

# These use Perl's interface to set privileges, as that handles updating
# of PL_uid, PL_euid, etc for us.  However they die in the case of an
# updating failure.

sub setruid { $< = $_[0]; croak "setruid failed" unless ($_[0] == $<); }
sub seteuid { $> = $_[0]; croak "seteuid failed" unless ($_[0] == $>); }
sub setrgid { $( = $_[0]; croak "setrgid failed" unless ($_[0] == $(); }
sub setegid { $) = $_[0]; croak "setegid failed" unless ($_[0] == $)); }

# Packages for tied variables are from here on.
# Saved [UG]ID...
package Proc::UID::SUID;
sub TIESCALAR { my $val; return bless \$val, $_[0]; }
sub FETCH     { return Proc::UID::getsuid(); }
sub STORE     { return Proc::UID::setsuid($_[1]); }

package Proc::UID::SGID;
sub TIESCALAR { my $val; return bless \$val, $_[0]; }
sub FETCH     { return Proc::UID::getsgid(); }
sub STORE     { return Proc::UID::setsgid($_[1]); }

# Regular UIDs
package Proc::UID::RUID;
sub TIESCALAR { my $val; return bless \$val, $_[0]; }
sub FETCH     { return Proc::UID::getruid(); }
sub STORE     { return Proc::UID::setruid($_[1]); }

package Proc::UID::EUID;
sub TIESCALAR { my $val; return bless \$val, $_[0]; }
sub FETCH     { return Proc::UID::geteuid(); }
sub STORE     { return Proc::UID::seteuid($_[1]); }

# Regular GIDs
package Proc::UID::RGID;
sub TIESCALAR { my $val; return bless \$val, $_[0]; }
sub FETCH     { return Proc::UID::getrgid(); }
sub STORE     { return Proc::UID::setrgid($_[1]); }

package Proc::UID::EGID;
sub TIESCALAR { my $val; return bless \$val, $_[0]; }
sub FETCH     { return Proc::UID::getegid(); }
sub STORE     { return Proc::UID::setegid($_[1]); }

1;
