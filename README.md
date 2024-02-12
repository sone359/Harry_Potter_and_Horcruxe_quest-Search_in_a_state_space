# IA01_TP2

## Harry, Voldemort et Dumbledore à la recherche des Horcruxes

Voici des exemples d'appel pour chaque fonction. Nous avons tenté de les faire les plus variés possible pour illuster les différentes possiblitées d'utilisation et les différents arguments pouvant être passés en paramètre. Les structures et différentes options des paramètres sont davantages détaillés dans le rapport et en commentaire de chaque fonction au sein du code.

Les noms map, horcruxesDescription, horcruxesMap et armesMap correspondent aux variables de test proposées dans le sujet du TP2. Toute variable ayant une structure similaire peut leur être substituée au sein des appels de fonction.

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