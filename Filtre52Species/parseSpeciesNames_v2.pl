#!/bin/perl

use Switch;
#===================================================================================
#= Phylogeagraphy scripts
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : Juillet-Août 2015
#===================================================================================
print STDOUT "\nDEBUT DU PROGRAMME\n\n";
#===================================================================================
#= VARIABLES GLOBALES
#===================================================================================
my $nbEspecesRetrouve = 30;
my $nbZone = 2661;
my $option = 5;
my @NomEspeces;
my @IDEspeces;
my @inputText3;
my @inputText4;

print STDOUT "\n**************************************************************************************\n";
print STDOUT "**\tPhylogeography program for built the matrice of reference's tree \n";
print STDOUT "**\tRefernce's tree # 1 : presence/absence of species \n";
print STDOUT "**\tRefernce's tree # 2 : Temperature mean of species \n";
print STDOUT "**\tRefernce's tree # 3 : precipitation mean of species \n";
print STDOUT "**\tAuthors : Nadia Tahiri, Nancy Badran and Vladimir Makarenkov \n";
print STDOUT "**\tEtablissment : UQAM \n";
print STDOUT "**\tDate : September 2015 \n";
print STDOUT "**************************************************************************************\n";

my $rep = "MyData";
opendir(REP,$rep) or die "E/S : $!\n";

do{
	print STDOUT "\nMENU:\n1-Pour filtrer la liste des espèces (noms espèces + son id)\n2-Nettoyer les données géographiques\n3-Collecter toutes les données utiles pour le projet en un seul fichier\n4-Réalisation de la matrice présence/absence des espèces\n5-Réalisation de la matrice des températures moyennes\n6-Réalisation de la matrice des précipitations moyennes\n7-Réalisation de la sous matrice des températures/précipitations moyennes \nà partir d'un ensemble de fichiers se trouvant sous le repretoire MyData\n8-Quitter\n\n";

	print STDOUT "Veuillez entrer votre choix: ";
	$option = <>;
	chomp($option);
	switch ($option) {
			case 1	{ filtreEspeceAndId() }
			case 2	{ cleanGeoData() }
			case 3	{ newFinalOutput() }
			case 4	{ matricePresenceAbs() }
			case 5	{ matriceParametre(3) }
			case 6	{ matriceParametre(4) }
			case 7	{ 
					while(defined(my $fic=readdir REP)){
						print $rep."/".$fic."\n";
						if($fic=~/.*\.csv/){
							sousMatrice($rep,$fic); 
						}
					}
				}
			case 8	{ print STDOUT "\nFIN PROGRAMME\n";}
			else	{ print "Mauvaise saisie" }
	}
}while($option!=8);





#===================================================================================
#= FONCTIONS
#= Auteur : Tahiri Nadia
#= Date   : Juillet-Août 2015
#===================================================================================

#===================================================================================
#= Filtrer les noms des espèces avec son id
#= Input : names.txt + names52Species.txt
#= Output : namesID.txt
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : Juillet 2015
#===================================================================================

sub filtreEspeceAndId {
	print STDOUT "\nDébut du traitement...\n";
	$nbEspecesRetrouve = 0;
	open (IN1 , 'names.txt') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText1 = <IN1>);
	close IN1;

	open (IN2 , 'names52Species.txt') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText2 = <IN2>);
	close IN2;

	open (OUT1 , '>namesID.txt')|| die "Erreur d'initialisation du fichier de sortie : $!";

	my @tab1;
	my @tab2;
	my @nameFile1;
	my @nameFile2;
	
	@NomEspeces;
	foreach my $name1(@inputText1){
		@tab1 = split(/"\s"/,$name1);
		$tab1[0] =~s/"//g;
		$tab1[1] =~s/"//g;
		$tab1[1] = lc $tab1[1];
		@nameFile1 = split(/\s/,$tab1[1]);
		
		foreach my $name2(@inputText2){
			$name2 = lc $name2;
			@nameFile2 = split(/\s/,$name2);
			
			if($nameFile1[0] eq $nameFile2[0] && $nameFile1[1] eq $nameFile2[1]){
				print STDOUT $tab1[0]." ".$nameFile1[0]." ".$nameFile1[1]."\n";
				print OUT1 $tab1[0]." ".$nameFile1[0]." ".$nameFile1[1]."\n";
				$IDEspeces[$nbEspecesRetrouve] = $tab1[0];
				$NomEspeces[$nbEspecesRetrouve] = $nameFile1[0]." ".$nameFile1[1];
				$tab2[$nbEspecesRetrouve][0] = $tab1[0];
				$tab2[$nbEspecesRetrouve][1] = $nameFile1[0];
				$tab2[$nbEspecesRetrouve][2] = $nameFile1[1];
				$nbEspecesRetrouve ++;
			}
		}
	}

	print STDOUT "Le nombre d'espèces communes au fichier : ".$nbEspecesRetrouve."\n";
	close (OUT1);
	print STDOUT "\nFin du traitement!\n";
}

#===================================================================================
#= Selectionner uniquement les colonnes des espèces trouver
#= dans le fichier indiquant pour chaque zone géographique si l'espèce est présente 
#= ou absente.
#= Input : Mammals.txt + cell_translation.txt
#= Output : namesID_geo.csv
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : Juillet 2015
#===================================================================================
sub cleanGeoData {
	print STDOUT "\nDébut du traitement...\n";
	# File geographique distribution
	open (IN3 , 'Mammals.txt') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(@inputText3 = <IN3>);
	close IN3;

	# File data geographique
	open (IN4 , 'cell_translation.txt') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(@inputText4 = <IN4>);
	close IN4;

	open (OUT2 , '>namesID_geo.csv')|| die "Erreur d'initialisation du fichier de sortie : $!";

	#Écrire la ligne d'en-tête
	print STDOUT "id_zone;longitude;latitude;";
	print OUT2 "id_zone;longitude;latitude;";
	foreach my $listNomEspece(@NomEspeces){
		print STDOUT $listNomEspece.";";
		print OUT2 $listNomEspece.";";
	}
	print STDOUT "\n";
	print OUT2 "\n";

	my @tab3;
	my @tab4;
	my @tab5;

	for(my $i=0; $i<scalar @inputText3; $i++){
		@tab3 = split(/\s/,$inputText3[$i]);
		$tab3[0]=~s/"//g;
		
		@tab4 = split(/\s/,$inputText4[$i]);
		
		if($tab3[0] eq $tab4[0]){
			# id de la zone
			print STDOUT $tab3[0].";";
			print OUT2 $tab3[0].";";
			
			# longitude
			print STDOUT $tab4[1].";";
			print OUT2 $tab4[1].";";
			
			# latitude
			print STDOUT $tab4[2].";";
			print OUT2 $tab4[2].";";		
			
			#stocke présence/absence pour espèce étudiée
			for(my $j=0; $j<scalar @IDEspeces; $j++){
				print STDOUT $tab3[$IDEspeces[$j]].";";
				print OUT2 $tab3[$IDEspeces[$j]].";";
			}
			
			print STDOUT "\n";
			print OUT2 "\n";
		}
		
	}

	close(OUT2);
	print STDOUT "\nFin du traitement!\n";
}

#===================================================================================
#= Filtre et nettoyage du fichier final
#= Input : mammal.csv
#= Output : result_global.csv
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : Aout 2015
#===================================================================================
sub newFinalOutput {
	print STDOUT "\nDébut du traitement...\n";
	$nbZone = 0;
	# File data geographique mammal.csv
	open (IN5 , 'mammal.csv') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText5 = <IN5>);
	close IN5;

	my $interval_zone = 5;

	my $x_min = -178;
	my $x_max = -44;

	my $y_min = 8;
	my $y_max = 74;


	open (OUT3 , '>result_global.csv')|| die "Erreur d'initialisation du fichier de sortie : $!";

	#Écrire la ligne d'en-tête
	print STDOUT "id_zone;longitude;latitude;mean_temp;prec_mean;";
	print OUT3 "id_zone;longitude;latitude;mean_temp;prec_mean;";
	foreach my $listNomEspece(@NomEspeces){
		print STDOUT $listNomEspece.";";
		print OUT3 $listNomEspece.";";
	}
	print STDOUT "\n";
	print OUT3 "\n";


	for(my $i=0; $i<scalar @inputText3; $i++){
		@tab3 = split(/\s/,$inputText3[$i]);
		$tab3[0]=~s/"//g;
		
		@tab4 = split(/\s/,$inputText4[$i]);
		
		if($tab3[0] eq $tab4[0]){
		
			foreach my $data1 (@inputText5){
				@tab5 = split(/;/,$data1);
				
				if($tab5[0]==$tab4[1] && $tab5[1]==$tab4[2]){
					if($tab4[1]>=$x_min && $tab4[1]<=$x_max && $tab4[2]>=$y_min && $tab4[2]<=$y_max){
						# compte le nombre de zones étudiée
						$nbZone ++;
						
						# id de la zone
						print STDOUT $tab3[0].";";
						print OUT3 $tab3[0].";";
						
						# longitude
						print STDOUT $tab4[1].";";
						print OUT3 $tab4[1].";";
						
						# latitude
						print STDOUT $tab4[2].";";
						print OUT3 $tab4[2].";";	
						
						#le parametre mean_temp
						print STDOUT $tab5[6].";";
						print OUT3 $tab5[6].";";
						
						#le parametre prec_mean
						print STDOUT $tab5[11].";";
						print OUT3 $tab5[11].";";
						
						#stocke présence/absence pour espèce étudiée
						for(my $j=0; $j<scalar @IDEspeces; $j++){
							print STDOUT $tab3[$IDEspeces[$j]].";";
							print OUT3 $tab3[$IDEspeces[$j]].";";
						}
						
						print STDOUT "\n";
						print OUT3 "\n";
					}
				}
			}
		}
		
	}

	close(OUT3);
	print STDOUT "\nFin du traitement!\n";
}

#===================================================================================
#= Réalisation de la matrice de distance presence/absence des espèces
#= Input : result_global.csv
#= Output : matricePresenceAbsence.csv
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : Aout 2015
#===================================================================================

sub matricePresenceAbs {
	print STDOUT "\nDébut du traitement...\n";
	
	print STDOUT "Le nombre de zone étudiée est de : ".$nbZone."\n";

	# File data geographique result_global.csv
	open (IN6 , 'result_global.csv') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText6 = <IN6>);
	close IN6;

	open (OUT4 , '>matricePresenceAbsence.csv')|| die "Erreur d'initialisation du fichier de sortie : $!";

	my @tab6;
	my $nbEspEnsemble = 0; #nombre espece ensemble
	my @matriceDistance;
	my @ListEspece;
	my $nomEspece="";

	#initialisation de la matrice de distance a zero
	for(my $k=1; $k<=$nbEspecesRetrouve; $k++){
		for(my $i=1; $i<=$nbEspecesRetrouve; $i++){
			$matriceDistance[$k][$i] = 0;
		}
	}

	for(my $k=1; $k<$nbEspecesRetrouve; $k++){
		for(my $i=$k+1; $i<=$nbEspecesRetrouve; $i++){
			$nbEspEnsemble = 0;
			
			for(my $j=1; $j<scalar @inputText6; $j++){
				@tab6 = split(/;/,$inputText6[$j]);
				
				if($tab6[4+$k]==$tab6[5+$i] && $tab6[4+$k]==1){
					$nbEspEnsemble ++;
				}
			}
			$nbEspEnsemble = 1-($nbEspEnsemble/$nbZone);
			$matriceDistance[$k][$i] = $nbEspEnsemble;
			$matriceDistance[$i][$k] = $nbEspEnsemble;
		}
	}

	
	print OUT4 $nbEspecesRetrouve."\n";
	print STDOUT $nbEspecesRetrouve."\n";

	for(my $k=1; $k<=$nbEspecesRetrouve; $k++){
		@ListEspece = split(/\s/,$NomEspeces[$k-1]);
		$ListEspece[0] = lc(substr($ListEspece[0],0,1));
		$ListEspece[1] = lc($ListEspece[1]);
		$nomEspece = $ListEspece[0]."_".$ListEspece[1];
		
		print OUT4 $nomEspece."\t";
		print STDOUT $nomEspece."\t";
		for(my $i=1; $i<=$nbEspecesRetrouve; $i++){
			print OUT4 $matriceDistance[$k][$i]." ";
			print STDOUT $matriceDistance[$k][$i]." ";
		}
		print OUT4 "\n";
		print STDOUT "\n";
	}

	close OUT4;
	print STDOUT "\nFin du traitement!\n";
}


#===================================================================================
#= Réalisation de la matrice de distance :
#= si input = 3 alors des températures moyennes des espèces
#= si input = 4 alors des précipitations moyennes des espèces
#= Input : result_global.csv et para
#= Output : matriceTempMean.csv
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : Aout 2015
#===================================================================================

sub matriceParametre {
	print STDOUT "\nDébut du traitement...\n";
	my $para = shift;
	my $parametre = "";
	
	if($para==3){
		$parametre = "mean_temp";
	}elsif($para==4){
		$parametre = "prec_mean";
	}

	# File data geographique result_global.csv
	open (IN6 , 'result_global.csv') || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText6 = <IN6>);
	close IN6;

	my $name_file_out = 'data_'.$parametre.'.csv';
	open (OUT4 , '>'.$name_file_out)|| die "Erreur d'initialisation du fichier de sortie : $!";

	my @tab6;
	my %para_mean = {}; #si $para = 3 : Liste des temperatures moyennes dans une tab asso en farenheit 
					    #si $para = 4 : Liste des précipitations moyennes dans une tab asso en mm 
					  
	my @tab_presence_abs;
	
	my $liste_para = "";
	my @tab_last;
	for(my $k=1; $k<$nbEspecesRetrouve; $k++){
		for(my $i=$k+1; $i<=$nbEspecesRetrouve; $i++){
			
			for(my $j=1; $j<scalar @inputText6; $j++){
				@tab6 = split(/;/,$inputText6[$j]);
				
				for(my $cp=5; $cp<scalar @tab6; $cp++){
					$tab_presence_abs[$cp-5] = $tab6[$cp];
				}
				
				if(defined($para_mean{$tab6[$para]})){
					@tab_last = split(/;/,$para_mean{$tab6[$para]});
					for(my $indice=0; $indice<scalar @tab_presence_abs; $indice++){
						if($tab_presence_abs[$indice]==1){
							$tab_last[$indice] = $tab_presence_abs[$indice];
						}
					}
					@tab_presence_abs = @tab_last;
				}
				$liste_para = join( ";", @tab_presence_abs);
				$para_mean{$tab6[$para]} = $liste_para;
				
			}
		}
	}

	# this deletes entry with key looks like 'HASH':
	foreach my $temp (keys %para_mean){
		if($temp=~ m/HASH\S+/){
			delete $para_mean{$temp};
		}
	}
	
	#Trie les clés du tableau associatif
	my @keys = sort { $a <=> $b } keys %para_mean; # nouveau tableau avec les clefs triees

	#Écrire la ligne d'en-tête
	print STDOUT "$parametre;";
	print OUT4 "$parametre;";
	foreach my $listNomEspece(@NomEspeces){
		print STDOUT $listNomEspece.";";
		print OUT4 $listNomEspece.";";
	}
	print STDOUT "\n";
	print OUT4 "\n";
	
	my $nbParam = 0;
	foreach my $temp (@keys){
		print STDOUT "$temp;" .  ($para_mean{$temp})  . "\n";
		print OUT4 "$temp;" .  ($para_mean{$temp})  . "\n";
		$nbParam ++;
	}
	
	close OUT4;
	
	# Uniformiser le nombre de points (i.e. lat et long) sur 12 plus grandes zones (nbParam/12)
	matricePara($nbParam,$para);
	
	print STDOUT "\nFin du traitement!\n";
}



#===================================================================================
#= Réalisation de la matrice de distances des paramètres 
#= 1)temperature moyenne
#= 2)précipitation moyenne 
#= des espèces
#= Input : matrice.csv et nb_param
#= si input = 3 alors des températures moyennes des espèces
#= si input = 4 alors des précipitations moyennes des espèces
#= Output : matricePresenceAbsence.csv
#= Auteur : Tahiri Nadia
#= Cours  : phylogéographie
#= Date   : septembre 2015
#===================================================================================

sub matricePara {
	print STDOUT "\nDébut du traitement...\n";
	my $nb_param = shift;
	my $para = shift;
	my $parametre = "";
	
	if($para==3){
		$parametre = "mean_temp";
	}elsif($para==4){
		$parametre = "prec_mean";
	}
	
	print STDOUT "Le nombre de données étudiées est de : ".$nb_param."\n";

	my $name_file_in = 'data_'.$parametre.'.csv';
	my $name_file_out = 'matrice_'.$parametre.'.csv';
	
	# File data parametre (precipitation + temperature)
	open (IN6 , $name_file_in) || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText6 = <IN6>);
	close IN6;

	open (OUT4 , '>'.$name_file_out)|| die "Erreur d'initialisation du fichier de sortie : $!";

	my @tab6;
	my $nbEspEnsemble = 0; #nombre espece ensemble
	my @matriceDistance;
	my @ListEspece;
	my $nomEspece="";
	
	#initialisation de la matrice de distance a zero
	for(my $k=1; $k<=$nbEspecesRetrouve; $k++){
		for(my $i=1; $i<=$nbEspecesRetrouve; $i++){
			$matriceDistance[$k][$i] = 0;
		}
	}

	for(my $k=1; $k<$nbEspecesRetrouve; $k++){
		for(my $i=$k+1; $i<=$nbEspecesRetrouve; $i++){
			$nbEspEnsemble = 0;
			
			for(my $j=1; $j<scalar @inputText6; $j++){
				@tab6 = split(/;/,$inputText6[$j]);
				
				if($tab6[$k]==$tab6[1+$i] && $tab6[$k]==1){
					$nbEspEnsemble ++;
				}
			}
			$nbEspEnsemble = 1-($nbEspEnsemble/$nb_param);
			$matriceDistance[$k][$i] = $nbEspEnsemble;
			$matriceDistance[$i][$k] = $nbEspEnsemble;
		}
	}

	
	print OUT4 $nbEspecesRetrouve."\n";
	print STDOUT $nbEspecesRetrouve."\n";

	for(my $k=1; $k<=$nbEspecesRetrouve; $k++){
		@ListEspece = split(/\s/,$NomEspeces[$k-1]);
		$ListEspece[0] = lc(substr($ListEspece[0],0,1));
		$ListEspece[1] = lc($ListEspece[1]);
		$nomEspece = $ListEspece[0]."_".$ListEspece[1];
		
		print OUT4 $nomEspece."\t";
		print STDOUT $nomEspece."\t";
		for(my $i=1; $i<=$nbEspecesRetrouve; $i++){
			print OUT4 $matriceDistance[$k][$i]." ";
			print STDOUT $matriceDistance[$k][$i]." ";
		}
		print OUT4 "\n";
		print STDOUT "\n";
	}

	close OUT4;
	print STDOUT "\nFin du traitement!\n";
}


#===================================================================================
#= Réalisation de la sous matrice de distances des paramètres 
#= 1)temperature moyenne
#= 2)précipitation moyenne 
#= des espèces
#= Input : Nom de repertoire et des noms de fichiers
#= Output : sous_matrice_NOM_FICIER_INPUT.csv
#= Auteur : Tahiri Nadia, Nancy Badran
#= Cours  : phylogéographie
#= Date   : septembre 2015
#===================================================================================

sub sousMatrice {
	print STDOUT "\nDébut du traitement...\n";
	my $name_file_rep = shift;
	my $name_file_fic = shift;
	my $nb_param = 0;
	my $parametre = "";
	

	my $name_file_in = $name_file_rep."/".$name_file_fic;
	my $name_file_out = 'sous_matrice_'.$name_file_fic;
	
	# File data parametre (precipitation + temperature)
	open (IN6 , $name_file_in) || die "Erreur de lecture du fichier d'entree‚ : $!";
		chomp(my @inputText6 = <IN6>);
	close IN6;

	open (OUT4 , '>results/'.$name_file_out)|| die "Erreur d'initialisation du fichier de sortie : $!";

	my @tab6;
	my $nbEspEnsemble = 0; #nombre espece ensemble
	my @matriceDistance;
	my @ListEspece;
	my $nomEspece="";
	
	#initialisation de la matrice de distance a zero
	for(my $k=1; $k<=$nbEspecesRetrouve; $k++){
		for(my $i=1; $i<=$nbEspecesRetrouve; $i++){
			$matriceDistance[$k][$i] = 0;
		}
	}

	#Calcul de la matrice de dissimilarité
	for(my $k=1; $k<$nbEspecesRetrouve; $k++){
		for(my $i=$k+1; $i<=$nbEspecesRetrouve; $i++){
			$nbEspEnsemble = 0;
			$nb_param = 0;
			
			for(my $j=0; $j<scalar @inputText6; $j++){
				@tab6 = split(/;/,$inputText6[$j]);
				$nb_param++;
				if($tab6[$k]==$tab6[1+$i] && $tab6[$k]==1){
					$nbEspEnsemble ++;
				}
			}					
			$nbEspEnsemble = 1-($nbEspEnsemble/$nb_param);
			$matriceDistance[$k][$i] = $nbEspEnsemble;
			$matriceDistance[$i][$k] = $nbEspEnsemble;
		}
	}

	print STDOUT "Le nombre de données étudiées est de : ".$nb_param."\n";
	
	print OUT4 $nbEspecesRetrouve."\n";
	print STDOUT $nbEspecesRetrouve."\n";

	for(my $k=1; $k<=$nbEspecesRetrouve; $k++){
		@ListEspece = split(/\s/,$NomEspeces[$k-1]);
		$ListEspece[0] = lc(substr($ListEspece[0],0,1));
		$ListEspece[1] = lc($ListEspece[1]);
		$nomEspece = $ListEspece[0]."_".$ListEspece[1];
		
		print OUT4 $nomEspece."\t";
		print STDOUT $nomEspece."\t";
		for(my $i=1; $i<=$nbEspecesRetrouve; $i++){
			print OUT4 $matriceDistance[$k][$i]." ";
			print STDOUT $matriceDistance[$k][$i]." ";
		}
		print OUT4 "\n";
		print STDOUT "\n";
	}

	close OUT4;
	print STDOUT "\nFin du traitement!\n";
}