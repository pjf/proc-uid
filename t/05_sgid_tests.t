#!/usr/bin/perl -wT
use strict;

# This exists purely to call our child test script.

$ENV{PATH} = "";

system("t/05_sgid_tests.t2");
