#!/bin/perl
use warnings;
use strict;
use Getopt::Long;

my $width = 80;

GetOptions(
  'c=i' => \$width,
);

while (my $line = <>) {
  $line =~ s/^\s*//;
  $line =~ s/\s*$//;
  my $pad = 0;
  if (length($line) > 0 && length($line) < $width) {
    $pad = ($width - length($line) - 1) / 2;
  }
  print ' ' x $pad, $line, "\n";
}
