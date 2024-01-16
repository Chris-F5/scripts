#!/bin/perl
use warnings;
use strict;

use File::Temp;
use PDF::API2;
use Getopt::Long;

my $output = 'output.pdf';
GetOptions(
  'o=s' => \$output
);
my @fnames = @ARGV;

my %pdfs = ();
my $temp = File::Temp->new();
my $temp_fname = $temp->filename;

for my $i (0..$#fnames) {
  $pdfs{$fnames[$i]} = PDF::API2->open($fnames[$i]);
  my $count = $pdfs{$fnames[$i]}->page_count();
  for my $j (1..$count) {
    print $temp $j, '.', $fnames[$i], "\n";
  }
}
$temp->close();

system($ENV{EDITOR} => $temp_fname);

open($temp, '<', $temp_fname);

my $pdf = PDF::API2->new();
while (my $line = <$temp>) {
  if ($line =~ /^(\d+)\.(.+)$/) {
    $pdf->import_page($pdfs{$2}, $1);
  } elsif ($line =~ /^BLANK$/) {
    $pdf->page();
  } else {
    print 'invalid line: ', $line;
  }
}
$pdf->save($output);

for my $pdf (values %pdfs) {
  $pdf->close();
}
unlink($temp->filename)
