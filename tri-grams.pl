#!/usr/bin/perl

use lib '../lib';
use Lingua::EN::Bigram;
use strict;

my $PATH = "/home/zlkhyr/Desktop/twm4/kamus";
open TOFILE, ">> $PATH/property_3grams.txt" or die "Cannot Open File!!!";

my %stopwords;

load_stopwords(\%stopwords);

my $file = $ARGV[ 0 ];
if (! $file) {
  print "Cara jalankan: $0 <file>\n";
  exit;
}

open F, $file or die "Can't open input: $!\n";
my $text = do { local $/; <F> };


close F;


# build n-grams
my $ngrams = Lingua::EN::Bigram->new;
$ngrams->text( $text );

# get bi-gram counts
my $trigram_count = $ngrams->trigram_count;

my $index = 0;

foreach my $trigram (keys %$trigram_count ) {

	# get the tokens of the trigram
	my ( $first_token, $second_token, $third_token ) = split / /, $trigram;
	
	# skip stopwords and punctuation
	next if ( $stopwords{ $first_token } );
	next if ( $first_token =~ /[,.?!:;()\-]/ );
	next if ( $stopwords{ $second_token } );
	next if ( $second_token =~ /[,.?!:;()\-]/ );
  next if ( $stopwords{ $third_token } );
	next if ( $third_token =~ /[,.?!:;()\-]/ );
	
	$index++;

	print TOFILE "$$trigram_count{ $trigram }\t$trigram\n";

}

sub load_stopwords 
{
  my $hashref = shift;
  open IN, "< /home/zlkhyr/Desktop/twm4/stopwords-id.txt" or die "Cannot Open File!!!";
  while (<IN>)
  {
    chomp;
    if(!defined $$hashref{$_})
    {
       $$hashref{$_} = 1;
    }
  }  
}

  
