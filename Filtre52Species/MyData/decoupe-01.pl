#!/usr/bin/perl
use strict;
use warnings;
use autodie;



my $FichierSource = "data_prec_mean.csv";
my $NbLigneMax = "171";
my $FichierSortie = "fichier2";
my $FichierSortieExtension = ".csv";

my $FichierNumero = 1;
open(my $fout, ">", $FichierSortie.sprintf("%03d", $FichierNumero++).$FichierSortieExtension);
open(my $fin, "<", $FichierSource);
while (<$fin> ) {
 print $fout $_;
 if ($. % $NbLigneMax == 0) {
   close($fout);
   open($fout, ">", $FichierSortie.sprintf("%03d", $FichierNumero++).$FichierSortieExtension);
 }
}
close($fout);
close($fin);