#!/usr/bin/perl -w
use strict;

# Makefile.PL for Secure::UID
# Paul Fenwick <pjf@cpan.org>, May 2004

use ExtUtils::MakeMaker;

WriteMakefile( NAME         => "Secure::UID",
               VERSION_FROM => "UID.pm"
             );
