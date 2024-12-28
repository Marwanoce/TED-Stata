// PROJET STATISTIQUES D'ENQUETE

// NOCEIR MARWANE, M1 DATA ANALYST

// 
clear
cd "C:\Users\marwa\OneDrive\Documents\Master Data Analyst\S1-Marwane\statistiques d'enquête\projet\PROJET"

import excel excel_statistiques.xlsx, firstrow

* Renommer les variables 

rename Quelestvotregenre Sexe
rename QuelestvotreâgeEnanné Age
rename Quelestvotreplushautnive Dipl
rename Quelestvotrenumérodedépa departement
rename Quelestapproximativementvo Revenu
rename Quelleestvotresituationpe Situation
rename Combiendenfantsavezvous nombreEnfants
rename Dansquelsecteurdactivité Metier
rename Quelleestvotretailleen Taille
rename Vousvousconsidérezcomme sportif
rename Pourvousquelleestlapri Raison
rename Combiendetempspratiquezv TempsSport
rename Combiendeséancesdesport seancesSportMoisDernier
rename Quelestlesportquevousa SportPratique
rename Vosperformancesdanscespo Performances
rename Dansquelcadreavezvouspr CategorieSportFavori
rename Q SportJeune
rename Pratiquezvousencorecespo SportJeuneEncorePratique
rename Combiendecompétitionsspor Compet
rename Utilisezvousdesréseauxso ReseauxSport
rename Siouilequelutilisezvous ReseauxSport_nom
rename Enquelleannéeavezvousco ReseauxSport_Annee
rename Combiendefoisconsultezvo ReseauxSport_cb
rename Pourquelleraisonutilisez RaisonsReseauxSport
rename Combiendepublicationssur NombrePubli
rename Quelpourcentagedevotrevi PercentPubliSport
rename Avezvousdéjàeulatentati Falsification
rename Dansquellemesurelapressi Pression
rename Pensezvousquilsoitpossi PerfSansReseaux
rename Sivouspouviezchangerquel ChangementReseauxSport


replace ReseauxSport_nom = "aucun" if ReseauxSport_nom == ""

* Encode les variables alphanumériques :

encode Sexe, generate(Sexe_num) 
encode Situation, generate(Situation_num) 
encode Dipl, generate(Dipl_num) 
encode Revenu, generate(Revenu_num) 
encode Metier, generate(Metier_num) 
encode Raison, generate(Raison_num) 
encode SportPratique, generate(SportPratique_num) 
encode Performances, generate(Performances_num) 
encode CategorieSportFavori, generate(CategorieSportFavori_num) 
encode SportJeune, generate(SportJeune_num) 
encode SportJeuneEncorePratique, generate(SportJeuneEncorePratique_num) 
encode ReseauxSport, generate(ReseauxSport_num) 
encode ReseauxSport_nom, generate(ReseauxSport_nom_num) 
encode ReseauxSport_cb, generate(ReseauxSport_cb_num) 
encode RaisonsReseauxSport, generate(RaisonsReseauxSport_num)  
encode PercentPubliSport, generate(PercentPubliSport_num)
encode Falsification, generate(Falsification_num) 
encode Pression, generate(Pression_num) 
encode PerfSansReseaux, generate(PerfSansReseaux_num) 
encode ChangementReseauxSport, generate(ChangementReseauxSport_num) 

*-------------------------------------------------------------------

 * Générer une nouvelle variable Performances_sort_num vide
generate Performances_sort_num = .

* Reclasser les catégories basées sur les textes
replace Performances_sort_num = 1 if Performances_num == 2
replace Performances_sort_num = 2 if Performances_num == 4
replace Performances_sort_num = 3 if Performances_num == 5
replace Performances_sort_num = 4 if Performances_num == 3
replace Performances_sort_num = 5 if Performances_num == 1

* Ajouter des labels pour rendre la variable interprétable
label define Performances_sort_labels ///
    1 "Fortement dégradées" ///
    2 "Un peu dégradées" ///
    3 "Pas de changement" ///
    4 "Un peu améliorées" ///
    5 "Fortement améliorées"

label values Performances_sort_num Performances_sort_labels

* Vérifier le résultat
tabulate Performances_sort_num

*--------------------------------------------------------------------------------------------------

// Créer une variable catégorique pour la taille
gen Taille_cat = floor((Taille - 150) / 10) if Taille >= 150 & Taille <= 200

// Ajuster les catégories pour qu'elles soient compréhensibles
label define Taille_cat_lbl ///
    0 "150-159" ///
    1 "160-169" ///
    2 "170-179" ///
    3 "180-189" ///
    4 "190-200"

// Appliquer les labels aux catégories
label values Taille_cat Taille_cat_lbl

// Vérifiez vos résultats
tab Taille_cat


describe
browse

* Création de la variable regroupée 'Pression_grouped'
gen Pression_grouped = .
* Attribution des catégories
replace Pression_grouped = 1 if Pression == "Pas du tout"
replace Pression_grouped = 2 if Pression == "Un peu"
replace Pression_grouped = 3 if inlist(Pression, "Modérément", "Beaucoup", "Très fortement")

* Ajout des labels descriptifs aux catégories
label define pression_lbl 1 "Pas du tout" 2 "Un peu" 3 "Modérément/Beaucoup/Très fortement"
label values Pression_grouped pression_lbl

*--------------------------------

* Création de la variable regroupée 'PercentPubliSport_grouped'
gen PercentPubliSport_grouped = ""

* Attribution des catégories
replace PercentPubliSport_grouped = "0 à 5%" if PercentPubliSport == "Entre 0 et 5%"
replace PercentPubliSport_grouped = "5 à 50%" if inlist(PercentPubliSport, "Entre 5 et 25%", "Entre 25% et 50%", "Entre 0 et 25%")
replace PercentPubliSport_grouped = "+ de 50%" if inlist(PercentPubliSport, "Entre 50 et 75%", "Plus de 75%")

* Encodage pour associer des labels numériques
encode PercentPubliSport_grouped, gen(PercentPubliSport_grouped_coded)


*Création de la variable CatégorieSport
gen CategorieSport = .
replace CategorieSport = 1 if CategorieSportFavori == "Amateur (loisir)"
replace CategorieSport = 2 if CategorieSportFavori == "Compétition amateur" | CategorieSportFavori == "Compétition semi-professionnelle"

label define CategorieSport_lbl 1 "Amateur (loisir)" 2 "Compétition"
label values CategorieSport CategorieSport_lbl

tab CategorieSport

*Creation de la variable CompetGrouped
gen CompetGrouped = .
replace CompetGrouped = 0 if Compet == 0
replace CompetGrouped = 1 if Compet >= 1

label define CompetGrouped_lbl 0 "0" 1 "1 ou plus"
label values CompetGrouped CompetGrouped_lbl

tab CompetGrouped

*Creation de la variable CompetGrouped2
gen CompetGrouped2 = .
replace CompetGrouped2 = 0 if Compet == 0
replace CompetGrouped2 = 1 if Compet == 1
replace CompetGrouped2 = 2 if Compet >= 2

label define CompetGrouped_lbl2 0 "0" 1 "1" 2 "2 ou plus"
label values CompetGrouped2 CompetGrouped_lbl2

tab CompetGrouped2


* Création de la variable regroupée 'NombrePubli_grouped'
gen NombrePubli_grouped = .
replace NombrePubli_grouped = NombrePubli if NombrePubli <= 2
replace NombrePubli_grouped = 3 if NombrePubli > 2

* Ajout des labels descriptifs
label define nombrepubli_lbl 0 "0" 1 "1" 2 "2" 3 "3 ou plus"
label values NombrePubli_grouped nombrepubli_lbl

tab NombrePubli_grouped

tab PercentPubliSport_num
* Création de la variable regroupée 'sportif_grouped'
gen sportif_grouped = .
replace sportif_grouped = 1 if sportif >= 1 & sportif < 3
replace sportif_grouped = 2 if sportif >= 3 & sportif < 5
replace sportif_grouped = 3 if sportif >= 5 & sportif < 7
replace sportif_grouped = 4 if sportif >= 7 & sportif <= 8

* Attribuer des labels aux groupes
label define sportif_lbl 1 "1-2" 2 "3-4" 3 "5-6" 4 "7-8"
label values sportif_grouped sportif_lbl

tab sportif_grouped

*Creation de ReseauxSport_nom_grouped
gen ReseauxSport_nom_grouped = ReseauxSport_nom
replace ReseauxSport_nom_grouped = "Autre" if ReseauxSport_nom == "Adidas Running" | ReseauxSport_nom == "Garmin" | ReseauxSport_nom == "Nike Run Club"

* encoder
encode(ReseauxSport_nom_grouped), gen(ReseauxSport_nom_grouped_coded)

tab ReseauxSport_nom_grouped_coded Sexe_num, chi2
tab ReseauxSport_nom_grouped Sexe_num, chi2

* Création d'une variable Situation :
gen Situation_cat = .
replace Situation_cat = 1 if Situation == "Célibataire" // Célibataire
replace Situation_cat = 2 if Situation == "Marié" // Marié
replace Situation_cat = 3 if Situation != "Marié" & Situation != "Célibataire" // Autre

label define Situation_cat_lbl ///
    1 "Célibataire" ///
    2 "Marié" ///
    3 "Autre"

label values Situation_cat Situation_cat_lbl

tab Situation_cat

*-------------------------------------

* Créer une liste de toutes les variables de type "string" (alphanumériques)
ds, has(type string)

* Supprimer ces variables
drop `r(varlist)'
*/

*I - Statistiques descriptives

graph pie, over(Sexe_num) plabel(_all percent) title("Répartition du Sexe")


tabulate Sexe_num

tabulate Dipl_num


graph pie, over(Dipl_num) plabel(_all percent) title("Répartition du Diplome")



* Créer un graphique en secteurs pour le diplôme des hommes
graph pie Dipl_num if Sexe_num == 1, over(Dipl_num) plabel(_all percent) title("Répartition du Diplôme - Homme")


graph pie Dipl_num if Sexe_num == 2, over(Dipl_num) plabel(_all percent) title("Répartition du Diplôme - Femme")


* Repartition de l'age :

graph box Age, title("Repartition de l'âge")

* Repartition de sportif :

graph bar, over(sportif) title("Repartition des individus selon leur sportivité")

histogram TempsSport, frequency title("Répartition selon le nombre d'heures de sport par semaine")

pwcorr TempsSport sportif, sig


histogram seancesSportMoisDernier, frequency title("Repartition selon le nombre de séances de sport faites le mois dernier") color(red)
* STATISTIQUES DESCRIPTIVES DE Y SUR X :

summarize sportif

graph pie ,over(ReseauxSport_num) plabel(_all percent) title("Répartition des individus ayant des reseaux sportifs ou non")

graph bar, over(NombrePubli) title("Répartition des individus selon le nombre de publications la semaine dernière")

graph pie ,over(Pression_num) plabel(_all percent) title("Répartition des individus selon leur pression vis à vis du sport")

graph pie, over(ReseauxSport_nom_num) plabel(_all percent) title("Repartition des reseaux sociaux sportifs des individus")

graph pie, over(Falsification_num) plabel(_all percent) title("Repartition de personnes tentés de falsifier leurs résultats")

**MATRICE DE CORRELATION :

pwcorr Situation_num Sexe_num, sig
pwcorr CategorieSportFavori_num Sexe_num, sig
pwcorr Raison_num Sexe_num, sig
pwcorr Metier_num Sexe_num, sig
pwcorr SportJeuneEncorePratique_num Sexe_num, sig
pwcorr ReseauxSport_nom_num Sexe_num, sig
pwcorr Falsification_num Sexe_num, sig
pwcorr Dipl_num Sexe_num, sig
pwcorr Situation_num CategorieSportFavori_num, sig
pwcorr Situation_num Raison_num, sig
pwcorr Situation_num Metier_num, sig
pwcorr Situation_num SportJeuneEncorePratique_num, sig
pwcorr Situation_num ReseauxSport_nom_num, sig
pwcorr Situation_num Dipl_num, sig
pwcorr CategorieSportFavori_num Raison_num, sig
pwcorr CategorieSportFavori_num Metier_num, sig
pwcorr CategorieSportFavori_num SportJeuneEncorePratique_num, sig
pwcorr CategorieSportFavori_num ReseauxSport_nom_num, sig
pwcorr CategorieSportFavori_num Falsification_num, sig
pwcorr CategorieSportFavori_num Dipl_num, sig
pwcorr Raison_num Metier_num, sig
pwcorr Raison_num SportJeuneEncorePratique_num, sig
pwcorr Raison_num ReseauxSport_nom_num, sig
pwcorr Raison_num Falsification_num, sig
pwcorr Raison_num Dipl_num, sig
pwcorr Metier_num SportJeuneEncorePratique_num, sig
pwcorr Metier_num ReseauxSport_nom_num, sig
pwcorr Metier_num Falsification_num, sig
pwcorr Metier_num Dipl_num, sig
pwcorr SportJeuneEncorePratique_num ReseauxSport_nom_num, sig
pwcorr SportJeuneEncorePratique_num Falsification_num, sig
pwcorr SportJeuneEncorePratique_num Dipl_num, sig
pwcorr ReseauxSport_nom_num Falsification_num, sig
pwcorr ReseauxSport_nom_num Dipl_num, sig
pwcorr Falsification_num Dipl_num, sig
pwcorr Falsification_num Situation_num, sig
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// II - Tests d'indépendance, khi deux 
//Le fil conducteur : c'est la robustesse.


*------------------------------------------------------------------------------------------------
* TEST DE KHI DEUX GLOBAL :



*CA COMMENCE ICI -------------------------------------------------------------
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
tab sportif_grouped Pression_grouped, chi2
tab sportif_grouped PercentPubliSport_grouped_coded, chi2
tab sportif_grouped ReseauxSport_nom_grouped_coded , chi2
tab sportif_grouped PerfSansReseaux_num, chi2
tab sportif_grouped NombrePubli_grouped, chi2

tab Performances_num Pression_grouped, chi2
tab Performances_num PercentPubliSport_grouped_coded, chi2
tab Performances_num ReseauxSport_nom_grouped_coded, chi2
tab Performances_num PerfSansReseaux_num, chi2
tab Performances_num NombrePubli_grouped, chi2

tab CategorieSport Pression_grouped, chi2
tab CategorieSport PercentPubliSport_grouped_coded, chi2
tab CategorieSport ReseauxSport_nom_grouped_coded, chi2
tab CategorieSport PerfSansReseaux_num, chi2
tab CategorieSport NombrePubli_grouped, chi2

tab CompetGrouped Pression_grouped, chi2
tab CompetGrouped PercentPubliSport_grouped_coded, chi2
tab CompetGrouped ReseauxSport_nom_grouped_coded, chi2
tab CompetGrouped PerfSansReseaux_num, chi2
tab CompetGrouped NombrePubli_grouped, chi2
*FIN KHI 2 GLOBAL

* TABLEAU DE CONTINGENCE

tab sportif_grouped NombrePubli_grouped	, chi2

*Création de la variable TempsSport_cat

gen TempsSport_cat = .
replace TempsSport_cat = 1 if TempsSport >= 0 & TempsSport <= 1
replace TempsSport_cat = 2 if TempsSport >= 2 & TempsSport <= 3
replace TempsSport_cat = 3 if TempsSport >= 4 & TempsSport <= 5
replace TempsSport_cat = 4 if TempsSport >= 6 & TempsSport <= 7
replace TempsSport_cat = 5 if TempsSport >= 8

label define TempsSport_lbl ///
    1 "0-1 heures" ///
    2 "2-3 heures" ///
    3 "4-5 heures" ///
    4 "6-7 heures" ///
    5 "8 heures et plus"
    
label values TempsSport_cat TempsSport_lbl

tab TempsSport_cat




**KHI DEUX DANS DES SOUS GROUPES : VOICI LES SIGNIFICATIFS

*SOUS POPULATION - LE GENRE

* Création d'un tableau croisé pour les femmes et les hommes
*---
bysort Sexe_num: tab sportif_grouped Pression_grouped, chi2
bysort Sexe_num: tab sportif_grouped PercentPubliSport_grouped_coded, chi2
bysort Sexe_num: tab sportif_grouped ReseauxSport_nom_grouped_coded , chi2
bysort Sexe_num: tab sportif_grouped PerfSansReseaux_num, chi2
bysort Sexe_num: tab sportif_grouped NombrePubli_grouped, chi2

bysort Sexe_num: tab Performances_num Pression_grouped, chi2
bysort Sexe_num: tab Performances_num PercentPubliSport_grouped_coded, chi2
bysort Sexe_num: tab Performances_num ReseauxSport_nom_grouped_coded, chi2
bysort Sexe_num: tab Performances_num PerfSansReseaux_num, chi2
bysort Sexe_num: tab Performances_num NombrePubli_grouped, chi2

bysort Sexe_num: tab CategorieSport Pression_grouped, chi2
bysort Sexe_num: tab CategorieSport PercentPubliSport_grouped_coded, chi2
bysort Sexe_num: tab CategorieSport ReseauxSport_nom_grouped_coded, chi2
bysort Sexe_num: tab CategorieSport PerfSansReseaux_num, chi2
bysort Sexe_num: tab CategorieSport NombrePubli_grouped, chi2

bysort Sexe_num: tab CompetGrouped Pression_grouped, chi2
bysort Sexe_num: tab CompetGrouped PercentPubliSport_grouped_coded, chi2
bysort Sexe_num: tab CompetGrouped ReseauxSport_nom_grouped_coded, chi2
bysort Sexe_num: tab CompetGrouped PerfSansReseaux_num, chi2
bysort Sexe_num: tab CompetGrouped NombrePubli_grouped, chi2

* SOUS POPULATION - L'AGE
*Création d'une variable qui indique si on est jeune ou non (-de 27 ans)

gen JeuneOui = 0 if Age > 23
replace JeuneOui=1 if JeuneOui==.

tab JeuneOui
* Création d'un tableau croisé pour les jeunes et les vieux
bysort JeuneOui: tab sportif_grouped Pression_grouped, chi2
bysort JeuneOui: tab sportif_grouped PercentPubliSport_grouped_coded, chi2
bysort JeuneOui: tab sportif_grouped ReseauxSport_nom_grouped_coded , chi2
bysort JeuneOui: tab sportif_grouped PerfSansReseaux_num, chi2
bysort JeuneOui: tab sportif_grouped NombrePubli_grouped, chi2

bysort JeuneOui: tab Performances_num Pression_grouped, chi2
bysort JeuneOui: tab Performances_num PercentPubliSport_grouped_coded, chi2
bysort JeuneOui: tab Performances_num ReseauxSport_nom_grouped_coded, chi2
bysort JeuneOui: tab Performances_num PerfSansReseaux_num, chi2
bysort JeuneOui: tab Performances_num NombrePubli_grouped, chi2

bysort JeuneOui: tab CategorieSport Pression_grouped, chi2
bysort JeuneOui: tab CategorieSport PercentPubliSport_grouped_coded, chi2
bysort JeuneOui: tab CategorieSport ReseauxSport_nom_grouped_coded, chi2
bysort JeuneOui: tab CategorieSport PerfSansReseaux_num, chi2
bysort JeuneOui: tab CategorieSport NombrePubli_grouped, chi2

bysort JeuneOui: tab CompetGrouped Pression_grouped, chi2
bysort JeuneOui: tab CompetGrouped PercentPubliSport_grouped_coded, chi2
bysort JeuneOui: tab CompetGrouped ReseauxSport_nom_grouped_coded, chi2
bysort JeuneOui: tab CompetGrouped PerfSansReseaux_num, chi2
bysort JeuneOui: tab CompetGrouped NombrePubli_grouped, chi2


/*
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
*III - Regressions linéaires

* TOUTES LES REGRESSIONS SIMPLES ENTRE TOUS LES X ET LES Y.
/*Y : TempsSport , seancesSportMoisDernier, Compet
X : NombrePubli, ReseauxSport_cb_quant*/

* Régression simple :


reg seancesSportMoisDernier NombrePubli



twoway (scatter seancesSportMoisDernier NombrePubli) ///
       (lfit seancesSportMoisDernier NombrePubli, lcolor(red)), ///
       xlabel(0(1)8) ///
       ylabel(0(1)20) ///
       xtitle("Nombre de publications par semaine") ///
       ytitle("Nombre de séances par semaine") ///
       title("Relation entre séances et publications") ///
       legend(order(1 "Nuage de points" 2 "Ligne de régression"))
	   

*Régressions multiples :

reg seancesSportMoisDernier NombrePubli
*+bloc1
reg seancesSportMoisDernier NombrePubli Age Sexe_num
*+bloc2
reg seancesSportMoisDernier NombrePubli Age Sexe_num Taille Situation_num
*+bloc3
reg seancesSportMoisDernier NombrePubli Age Sexe_num Taille Situation_num Revenu_num Dipl_num 

reg seancesSportMoisDernier Age
reg seancesSportMoisDernier Sexe_num

*Régressions multiples sur un sous-échantillon :

reg seancesSportMoisDernier NombrePubli Age Taille Situation_num Revenu_num Dipl_num  if Sexe=="Un homme" //Homme
reg seancesSportMoisDernier NombrePubli Age Taille Situation_num Revenu_num Dipl_num  if Sexe=="Une femme" //Femme

table Sexe_num

reg seancesSportMoisDernier NombrePubli Age Sexe_num Taille Situation_num Revenu_num Dipl_num  if seancesSportMoisDernier >= 4 //quelqu'un qui fait du sport

reg seancesSportMoisDernier NombrePubli Age Sexe_num Taille Situation_num Revenu_num Dipl_num  if seancesSportMoisDernier < 4 //quelqu'un qui ne fait pas beaucoup de sport

reg seancesSportMoisDernier NombrePubli Age Taille Situation_num Revenu_num Dipl_num  if seancesSportMoisDernier < 4 & Sexe == "Un homme"

reg seancesSportMoisDernier NombrePubli Age Taille Situation_num Revenu_num Dipl_num  if seancesSportMoisDernier < 4 & Sexe == "Une femme"


reg seancesSportMoisDernier NombrePubli Age Sexe_num Taille Situation_num Revenu_num Dipl_num  if sportif >= 6 //quelqu'un qui est sportif

reg seancesSportMoisDernier NombrePubli Age Sexe_num Taille Situation_num Revenu_num Dipl_num  if sportif <6 //quelqu'un qui n'est pas sportif

**FIN

