=head1 NAME

Proc::UID - Manipulate a variety of UID and GID settings.

=head1 SYNOPSIS

	use Proc::UID;

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

package Proc::UID;
use strict;
use warnings;
use XSLoader;
use Exporter;

our $VERSION = 0.01;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(	getruid geteuid getrgid getegid
			setruid seteuid setrgid setegid
			getsuid getsgid
			setuid_permanent setsuid);

XSLoader::load 'Proc::UID';

# Try to find a tainted() routine.  If not, define our own.
# This may not be needed if we're doing everything via XS,
# which can probably just poke around inside the vars directly.
eval "use Scalar::Util 'tainted'";
if ($@ or ! *tainted{CODE}) {
	# Hmm, no Scalar::Util, or it didn't provide a tainted().
	# We'll define our own.  The following code is shamelessly
	# ripped from Scalar::Util 1.14
	*tainted = sub {
		local($@, $SIG{__DIE__}, $SIG{__WARN__});
		local $^W = 0;
		eval { kill 0 * $_[0] };
		$@ =~ /^Insecure/;
	}
}

# These *should* be expanded to actually check the operation succeeded.

sub setruid { $< = $_[0]; }
sub seteuid { $> = $_[0]; }
sub setrgid { $( = $_[0]; }
sub setegid { $) = $_[0]; }

# Most of our hard work is done in XS.

1;
