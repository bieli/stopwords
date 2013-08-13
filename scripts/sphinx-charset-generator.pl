#!/usr/bin/env perl
#
# Generates a charset_table entry for Sphinx
# 

use strict;
use warnings;
use utf8;
use Text::Unaccent;
use Encode;

my $map = gen_map_accents($ARGV[0] || 'utf-8');

print "charset_table=a..z,0..9,A..Z->a..z, \\\n";
print join(', ', map { sprintf('U+%X->%s', unpack('W*'), $map->{$_}) } sort keys %$map);
print "\n";

sub gen_map_accents {
  my $charset = shift;
  my %map;

#  my $src = 'áéíóúàèìòùãõâêîôûç';
  my $src = 'áéíóúàèìòùãõâêîôûçĂÂÎŢŞăâîţş';
  $src .= uc($src);  
  $src = encode($charset, $src) unless $charset =~ m/^utf-?8$/i;

  my $clean = lc(unac_string($charset, $src));
  @map{split(//, $src)} = split(//, $clean);
  
  return \%map;
}


