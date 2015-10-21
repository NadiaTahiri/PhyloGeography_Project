#!/usr/bin/perl
use strict;
use warnings;
use autodie;



my $FichierSource = "data_mean_temp.csv";
my $NbLigneMax = "100";
my $FichierSortie = "fichier";
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

