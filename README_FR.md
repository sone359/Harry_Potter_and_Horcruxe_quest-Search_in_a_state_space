# Harry, Voldemort et Dumbledore à la recherche des Horcruxes

Un projet étudiant où Harry Potter, Voldemort et Dumbledore cherchent les Horcruxes dans une carte représentée par un espace d'état au moyen de différents types d'algorithme.  
Ceci est un projet étudiant, réalisé un temps contraint et limité et dont le développement est aujourd'hui stoppé.

![Image des sept Horcruxes](./data/Horcruxes.jpg "Horcruxes")

## Création
14/11/2023

## Dernière modification du code
20/11/2023

## Auteur
Simon Biffe

## Contributeur
Inès Adam

### Quelles sont les règles ?

## Enoncé du problème :

Harry Potter et Lord Voldemort vont chercher les Horcruxes dans une carte. Chaque case de la carte représente une pièce ou un lieu. Harry Potter utilisera un algorithme de recherche en profondeur pour trouver et détruire des Horcruxes. Il ne pourra se déplacer que sur des cases contigues (en haut, à droite, en bas ou à gauche). Les cases grisées ne sont pas accessibles. Ainsi de l’état 22, on peut aller en 27, en 21 et en 15. Lord Voldmort quand à lui pourra se déplacer n’importe comment à l’exception des cases grisées.

Le nombre d’essai est limité à un nombre de profondeur donné (7 ici, l’entrée étant le niveau 0).
Pour ce projet, on dispose de la carte ci-dessous, le programme doit cependant pouvoir traiter n’importe quelle carte représentée de la sorte.

![Carte de référence](./data/carte_reference.png "Carte de référence")

Chaque Horcruxe peut être détruit par une méthode de destruction unique. Voici la description des Horcruxes et des méthodes de destruction associées :

- Journal intime de Tom Jedusor. Méthode de destruction : Crochet de Basilic
- Médaillon de Salazar Serpentard. Méthode de destruction : Epée de Gryffondor
- Bague de Gaunt. Méthode de destruction : Epée de Gryffondor
- Coupe de Helga Poufsouffle. Méthode de destruction : Crochet de Basilic
- Nagini. Méthode de destruction : Epée de Gryffondor
- Diadème de Rowena Serdaigle. Méthode de destruction : Feudeymon
- Harry Potter. Méthode de destruction : Sortilège de la Mort

Les Horcruxes sont cachés dans les cases suivantes :

- Journal intime de Tom Jedusor : 8
- Médaillon de Salazar Serpentard : 12
- Bague de Gaunt : 15
- Coupe de Helga Poufsouffle : 22
- Nagini : 26
- Diadème de Rowena Serdaigle : 29

Le septième Horcruxe, Harry Potter, se déplace.

Une méthode de destruction peut détruire plusieurs Horcruxes. Quatre méthodes de destruction sont cachées dans les cases suivantes :

- Crochet de Basilic : 3
- Sortilège de la Mort : 20
- Epée de Gryffondor : 25
- Feudeymon : 32

En arrivant surs une case, il est possible de prendre une méthode de destruction s’il y en a une. Si on arrive sur une case pour la première fois, s’il y a un Horcruxe et si on dispose de la méthode adéquate alors on peut détruire l’Horcruxe (e.g. si on est sur la case 26, pour détruire le Nagini, il faut déjà posséder l’épée de Gryffondor). Il ne sera pas possible de le détruire si ce n’est pas la première fois qu’on vient sur cette case. Par exemple, si on passe une première fois sur la case 12 mais qu’on n’a pas l’épée de Gryffondor, alors il n’est pas possible de la détruire. Si on revient une seconde fois avec l’épée, il sera trop tard pour le détruire.

Lord Voldemort va également explorer la carte. A chaque déplacement de Harry Potter sur une nouvelle case, Lord Voldemort va également se déplacer (en même temps). On peut considérer que lorsque Harry revient sur ses pas, Lord Voldemort ne se déplace pas. C’est à l’utilisateur de choisir la case de Lord Voldemort. La profondeur possible est toujours de 7.

Lord Voldemort peut également collecter des armes et détruire des Horcruxes. Comme pour Harry Potter, il ne peut détruire l’Horcruxe que :

- S’il a déjà collecté la méthode de destruction adéquate et
- Si c’est la première fois qu’il vient dans cette case.

Toutefois, les règles sont différentes pour l’Horcruxe Harry Potter. Lord Voldermort peut détruire Harry Potter avec le Sortilège de la Mort s’il arrive sur la même case que lui et même s’il est déjà venu sur cette case. Si Harry Potter meurt, le jeu s’arrête.

### Représentation du problème

On aura quatre listes différentes qui représenteront 1) la carte, 2) la description des Horcruxes, 3) le positionnement des Horcruxes dans la carte et 4) le positionnement des méthodes de destructions dans la carte.

Voici ci-dessous un exemple pour chacune, correspondant à la carte de référence.

(setq map '((1 12 2)(2 1 3)(3 2 4)(4 3 5)(5 4 8 6)(6 5 7)(7 8 6)(8 7 5)(12 13 1)
            (13 24 12)(15 22)(20 21 29)(21 22 20)(22 27 21 15)(24 25 13)
            (25 36 26 24)(26 25 27)(27 26 22)(29 32 20)(32 29)(36 25)))

 
(setq horcruxesDescription '(("Journal intime de Tom Jedusor" 
                                (methodeDestruction "Crochet de Basilic"))
                             ("Médaillon de Salazar Serpentard" 
                                (methodeDestruction "Epée de Gryffondor"))
                             ("Bague de Gaunt" 
                                (methodeDestruction "Epée de Gryffondor"))
                             ("Coupe de Helga Poufsouffle" 
                                (methodeDestruction "Crochet de Basilic"))
                             ("Nagini" 
                                (methodeDestruction "Epée de Gryffondor"))
                             ("Diadème de Rowena Serdaigle" 
                                (methodeDestruction "Feudeymon"))))

(setq horcruxesMap '((8 "Journal intime de Tom Jedusor")
                     (12 "Médaillon de Salazar Serpentard")
                     (15 "Bague de Gaunt")
                     (22 "Coupe de Helga Poufsouffle")
                     (26 "Nagini")
                     (29 "Diadème de Rowena Serdaigle")))

(setq armesMap '((3 "Crochet de Basilic")
                 (32 "Feudeymon")
                 (25 "Epée de Gryffondor")
                 (20 "Sortilège de la Mort")))        

## Usage

Ci-dessous, quelques exemples d'appels intéressants pour chaque fonction.  
Les structures et différentes options des paramètres sont davantages détaillés en commentaire de chaque fonction au sein du code.

Les noms map, horcruxesDescription, horcruxesMap et armesMap correspondent aux variables de test proposées plus haut. Toute variable ayant une structure similaire peut leur être substituée au sein des appels de fonction.

### Fonctions de Service:
( successeurs-valides 22 map '(26 27 28))
( methodedestruction “Nagini” horcruxesDescription)
( hasbonneArme “Nagini” '(“Epée de Gryffondor” “Feudeymon”) Horcruxesdescription)

### Fonction RechercheProfondeur:
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur 24 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")

### Fonction rechercheProfondeurVoldemort:
(rechercheprofondeurVoldemort 1 3 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeurVoldemort 1 3 map horcruxesMap armesMap horcruxesDescription :affichage "log-arbre")

### Fonction rechercheProfondeur+:
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 3)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :affichage "events-arbre")
(rechercheprofondeur+ 24 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :fluxSortie "test32.txt" :affichage "events")

### Fonction rechercheProfondeurVoldemort+ :
(rechercheprofondeurVoldemort+ 1 3 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeurVoldemort+ 1 36 map horcruxesMap armesMap
horcruxesDescription :affichage "log-arbre" :profondeurMax 9 :fluxSortie "test333.txt")

### Fonction rechercheProfondeur++:
(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription
:profondeurMax 7 :dumbledore T :caseD 1)
(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription
:profondeurMax 7 :dumbledore T :caseD 1 :modeD "parallele")