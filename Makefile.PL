#!/usr/bin/perl -w
use strict;

# Makefile.PL for Proc::UID
# Paul Fenwick <pjf@cpan.org>, May 2004

use ExtUtils::MakeMaker;

WriteMakefile( NAME         => "Proc::UID",
               VERSION_FROM => "UID.pm"
             );
