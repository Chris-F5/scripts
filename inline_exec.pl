#!/bin/perl
use warnings;
use strict;

use IPC::Open2;

while (my $line = <>) {
  if ($line =~ /^!EXEC (.+)$/) {
    my $pid = open2(my $out, my $in, $1);
    while ($line = <>) {
      last if $line =~ /^!END$/;
      print $in $line;
    }
    close $in;
    waitpid $pid, 0;
    print $line while ($line = <$out>);
    close $out;
  } else {
    print $line;
  }
}

