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

use strict;
use warnings;

# Insert module here.  ;)

1;
