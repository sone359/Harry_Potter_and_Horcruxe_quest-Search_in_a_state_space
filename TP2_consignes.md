# TP 2 : Harry Potter et les reliques de la mort, partie 3

    Livrables attendus : un fichier lisp + un rapport présentant et argumentant les réponses aux questions

    Format attendu : une archive nommée TP2_NomBinome1_NomBinome2_GroupeX.zip/rar

    Date de remise : 20 novembre 2023 18.00

    Une attention particulière sera portée à la présentation du rapport, à l’élégance du code, à l’utilisabilité du code et à la compréhension des instructions pour l’utilisateur (un fichier readme sera le bienvenu).

    Pour toute demande de précision merci de privilégier Discord

## Objectif et Univers

Ce TP a pour objectif de vous faire travailler la recherche dans un espace d’états. Il est inspiré l’univers Harry Potter. Il porte sur une sorte de chasse au trésor dans laquelle il faut trouver des Horcruxes cachés et les détruire. Il n’est pas nécessaire d’avoir lu ou vu la série Harry Potter. Vous trouverez les informations relatives à ce TP sur le wiki Harry Potter, en consultant la page relative aux Horcruxes.

https://harrypotter.fandom.com/fr/wiki/Horcruxe

## Enoncé du problème :

Harry Potter et Lord Voldemort vont chercher les Horcruxes dans une carte. Chaque case de la carte représente une pièce ou un lieu. Harry Potter utilisera un algorithme de recherche en profondeur pour trouver et détruire des Horcruxes. Il ne pourra se déplacer que sur des cases contigues (en haut, à droite, en bas ou à gauche). Les cases grisées ne sont pas accessibles. Ainsi de l’état 22, on peut aller en 27, en 21 et en 15. Lord Voldmort quand à lui pourra se déplacer n’importe comment à l’exception des cases grisées.

Le nombre d’essai est limité à un nombre de profondeur donné (7 ici, l’entrée étant le niveau 0).
Pour cet exercice, nous allons travailler sur la carte ci-dessous, vous veillerez cependant à avoir un code robuste pouvant traiter n’importe quelle carte représentée de la sorte.

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

## Analyse (3 points)

    1. Dessinez un arbre de recherche en profondeur si la recherche débute à la case 1, et un autre arbre en commençant à la case 36. Indiquez par un moyen de couleurs ou de pictogrammes où se trouve les méthodes de destruction et les Horcruxes. Faites en sorte que l’on comprenne quelles méthodes détruisent tels Horcruxes (même couleur ou association de pictogrammes ou autre). On rappelle que l’on ne peut pas aller au-delà de la profondeur 7.
    2. Indiquez les Horcruxes détruits dans chacun des cas suivants : en démarrant à la case 1 et en démarrant à la case 36.
    3. Si on augmente la profondeur, dans ces deux cas, est-ce qu’il serait possible d’obtenir tous les Horcruxes ? Si oui lesquels ? Argumentez.

Représentation du problème

On aura quatre listes différentes qui représenteront 1) la carte, 2) la description des Horcruxes, 3) le positionnement des Horcruxes dans la carte et 4) le positionnement des méthodes de destructions dans la carte.

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

## Fonctions de service (2 points)

    1. Donnez le code Lisp de la fonction successeurs-valides qui prend en argument une case, une carte et le chemin déjà parcouru. Cette fonction renvoie alors les successeurs qui n’ont pas encore été explorés.
    Par exemple :

(successeurs-valides '25 'map '(1 12 13 24)) 
renvoie (36 26)

    2. Donnez le code Lisp de la fonction methodeDestruction qui prend en argument un Horcrurxe et la liste de description des Horcruxes. Cette fonction renvoie la méthode de destruction si l’Horcruxe existe ou nil sinon.
    Par exemple :

(methodeDestruction "Nagini" horcruxesDescription) 
renvoie "Epée de Gryffondor".  

    3. Donnez le code Lisp de la fonction hasBonneArme qui prend en argument un Horcrurxe, la liste des noms des méthodes de destruction que l’on possède déjà et la liste de description des Horcruxes. Cette fonction renvoie T ou nil selon que l’on possède ou non la méthode adaptée
    Par exemple :

(hasBonneArme "Nagini" '("Crochet de Basilic" "Epée de Gryffondor") horcruxesDescription) 
renvoie T.  

    Notez que pour vérifier si un une chaine de caractères se trouve dans une liste, il faudra utiliser le test suivant :test #'string=

## Recherche en profondeur pour la recherche de Harry Potter (5 points)

    1. Donnez l’algorithme de recherche en profondeur qui renverra entre autres la liste des noms des Horcruxes détruits et les armes collectée pour un départ dans une case donnée.
    2. Donnez le code Lisp de cette fonction. Pensez à mettre des affichages dans votre fonction pour savoir où se trouve Harry Potter, quelles sont ses armes et quelles sont les Horcruxes qu’il a détruit. Vous être libre de choisir les arguments de cette fonction.

## Lord Voldemort part à la recherche des Horcruxes (5 points)

Lord Voldemort va également explorer la carte. A chaque déplacement de Harry Potter sur une nouvelle case, Lord Voldemort va également se déplacer (en même temps). On peut considérer que lorsque Harry revient sur ses pas, Lord Voldemort ne se déplace pas (mais vous pouvez aussi proposer cette variante). C’est à l’utilisateur de choisir la case de Lord Voldemort. La profondeur possible est toujours de 7.

Lord Voldemort peut également collecter des armes et détruire des Horcruxes. Comme pour Harry Potter, il ne peut détruire l’Horcruxe que :

    - s’il a déjà collecté la méthode de destruction adéquate et
    - si c’est la première fois qu’il vient dans cette case.

Toutefois, les règles sont différentes pour l’Horcruxe Harry Potter. Lord Voldermort peut détruire Harry Potter avec le Sortilège de la Mort s’il arrive sur la même case que lui et même s’il est déjà venu sur cette case. Si Harry Potter meurt, le jeu s’arrête.

    1. Modifiez l’algorithme précédent pour ajouter le jeu de Lord Voldemort dans la même fonction.
    2. Donnez le code Lisp de cette fonction. Pensez à mettre des affichages dans votre fonction pour savoir où se trouve Lord Voldemort, quelles sont ses armes et quelles sont les Horcruxes qu’il a détruit.

## Créativité (3 points)

Proposez des améliorations au jeu. Ces améliorations peuvent être liées à la résolution du problème (e.g. représentation, algorithme de recherche en largeur, heuristiques, etc.), à des éléments de l’univers d’Harry Potter (e.g. ajout de sorts, d’autres personnages, etc.), ou à tout autre aspect.
Un autre exemple, pourrait être une fonction qui permettrait à Harry Potter de tester toutes les entrées possibles pour estimer celle qu’il serait judicieux de prendre pour détruire le maximum d’Horcruxes (sans supposer les déplacements de Lord Voldemort).

## Conclusion (2 points)

Discutez et critiquez la représentation proposée, vos méthodes de résolution. Proposez et argumentez des améliorations possibles qui n’ont pas été traitées dans la question précédente.
