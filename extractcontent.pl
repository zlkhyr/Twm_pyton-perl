#!/usr/bin/perl
#
# Program ini digunakan untuk mengekstrak bagian konten dari sebuah file HTML
#
# Author: Taufik Fuadi Abidin
# Department of Informatics
# College of Science, Syiah Kuala Univ
# 
# Date: Mei 2011
# http://www.informatika.unsyiah.ac.id/tfa
#
# Dependencies:
# INSTALASI HTML-EXTRACTCONTENT
# See http://www.cpan.org/
#
# 1. Download HTML-ExtractContent-0.10.tar.gz and install
# 2. Download Exporter-Lite-0.02.tar.gz and install
# 3. Download Class-Accessor-Lvalue-0.11.tar.gz and install
# 4. Download Class-Accessor-0.34.tar.gz and install
# 5. Download Want-0.18.tar.gz and install
#

use strict;
use warnings;
use HTML::ExtractContent;
use File::Basename;

# get file
my $file = $ARGV[0];
my $fileout = basename($file);
print "fileout: [$fileout]\n";

# Directory where clean data are stored, its better to set this in config file
my $PATHCLEAN = "/home/zlkhyr/Desktop/twm4/clean_data/kategori_2/train";

$fileout = "$PATHCLEAN/" . $fileout . ".clean.dat";
print "$fileout\n";

# open file
open OUT, "> $fileout" or die "Cannot Open File!!!";

# object
my $extractor = HTML::ExtractContent->new;
my $html = `cat $file`;

#$html = lc($html);  # don't make it lowercase

$html =~ s/\^M//g;

# get TITLE
if( $html =~ /<title.*?>(.*?)<\/title>/){
  my $title = $1;
  $title = clean_str($title);
  print "<title>$title\t$fileout</title>\n";
  print OUT "<title>$title</title>\n";
}

# get BODY (Content)
$extractor->extract($html);
my $content = $extractor->as_text;
$content = clean_str($content);

# Split content menjadi beberapa kalimat berdasarkan simbol titik
my @kalimat = split /\./, $content;

# Menghitung jumlah total kalimat 
my $total_sentences = scalar @kalimat;

# Membagi total kalimat menjadi 3 bagian
my $part_size = int($total_sentences / 3);

# Membagi content menjadi 3 bagian : atas, tengah, atas
my @atas = @kalimat[0..($part_size - 1)];
my @tengah = @kalimat[$part_size..(2 * $part_size - 1)];
my @bawah = @kalimat[(2 * $part_size)..($total_sentences - 1)];

# Join kalimat
my $content_atas = join "\n", @atas;
my $content_tengah = join "\n", @tengah;
my $content_bawah = join "\n", @bawah;

print OUT "<atas>$content_atas</atas>\n";
print OUT "<tengah>$content_tengah</tengah>\n";
print OUT "<bawah>$content_bawah</bawah>\n";
# print OUT "<content>$content</content>\n";

close OUT;


sub clean_str {
  my $str = shift;
  $str =~ s/>//g;
  $str =~ s/&.*?;//g;
  #$str =~ s/[\:\]\|\[\?\!\@\#\$\%\*\&\,\/\\\(\)\;"]+//g;
  $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
  $str =~ s/-/ /g;
  $str =~ s/\n+//g;
  $str =~ s/\s+/ /g;
  $str =~ s/^\s+//g;
  $str =~ s/\s+$//g;
  $str =~ s/^$//g;
  return $str;
}
