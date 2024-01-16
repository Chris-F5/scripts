#!/bin/perl
use warnings;
use strict;

use POSIX qw(strftime);
use Getopt::Long;

my $time = time;
my $n = 3;

GetOptions(
  'n=i' => \$n,
);

for (1..$n) {
  my $date = strftime '%b %d, %a', localtime $time;
  print $date, "\n";
  $time += 86400;
}
