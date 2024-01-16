#!/bin/perl
use warnings;
use strict;

use Getopt::Long;
use PDF::API2;

my $output = 'output.pdf';
my $page_width = 595;
my $page_height = 842;
my $top_margin = 40;
my $bot_margin = 40;
my $left_margin = 80;
my $font_size = 9;
my $max_image_width = $page_width - 2 * $left_margin;
my $max_image_height = $page_height - $top_margin - $bot_margin;
my $image_top_margin = 4;
my $image_bot_margin = 4;

GetOptions(
  'o=s' => \$output,
  's=i' => \$font_size,
);

my $pdf = PDF::API2->new();
my $font = $pdf->font('Courier');

my $x;
my $y;
my $page;
my $page_empty;

sub new_page {
  $page = $pdf->page();
  $page->size([0, 0, $page_width, $page_height]);
  $y = $page_height - $top_margin;
  $x = $left_margin;
  $page_empty = 1;
}
sub request_space {
  my $space = shift;
  new_page() if ($y - $space < $bot_margin);
  $y -= $space;
  $page_empty = 0;
  die if ($y < $bot_margin);
}
sub new_text {
  request_space($font_size);
  my $text = $page->text();
  $text->font($font, $font_size);
  $text->position($x, $y);
  $text->text(@_);
}
sub new_image {
  my $fname = shift;
  my $image = $pdf->image($fname);
  my $aspect = $image->width() / $image->height();
  my $critical_aspect = $max_image_width / $max_image_height;
  my $width;
  my $height;
  if ($aspect > $critical_aspect) {
    $width = $max_image_width;
    $height = $max_image_width / $aspect;
  } else {
    $width = $max_image_height * $aspect;
    $height = $max_image_height;
  }
  $y -= $image_top_margin;
  request_space($height);
  $page->object($image, ($page_width - $width) / 2, $y, $width);
  $y -= $image_bot_margin;
}

new_page();
while (my $line = <>) {
  chomp $line;
  next if ($page_empty && $line =~ /^\s*$/);
  if ($line =~ /^---\s*$/) {
    new_page();
  } elsif ($line =~ /^!IMAGE_SIZE (\d+)/) {
    $max_image_height = $1;
  } elsif ($line =~ /^!IMAGE (.+)$/) {
    new_image($1);
  } elsif ($line =~ /^!FONT_SIZE (\d+)$/) {
    $font_size = int($1);
  } else {
    new_text($line);
  }
}

$pdf->save($output);
