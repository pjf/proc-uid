#!/usr/bin/perl -wT
use strict;

# This exists purely to call our child test script.

$ENV{PATH} = "";

system("t/04_suid_tests.t2");
