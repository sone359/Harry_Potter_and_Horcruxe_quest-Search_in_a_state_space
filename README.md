# Harry, Voldemort et Dumbledore à la recherche des Horcruxes

A student project in which Harry Potter and Voldemort search Horcruxes in a map represented as a state space with different algorithmes.  
This is a student project, made in a limited period and stopped.

![Image of the seven Horcruxes](./data/Horcruxes.jpg "Horcruxes")

## Creation
14/11/2023

## Last modification of the code
20/11/2023

## Author
Simon Biffe

## Contributor
Inès Adam

## What are rules?

### Problem Statement
Harry Potter and Lord Voldemort are searching for Horcruxes on a map. Each square on the map represents a room or a location. Harry Potter will use a depth-first search algorithm to find and destroy Horcruxes. He can only move to adjacent squares (up, right, down, or left). Grayed-out squares are not accessible. For example, from state 22, Harry can move to 27, 21, and 15. Lord Voldemort, on the other hand, can move in any direction except on grayed-out squares.

The number of attempts is limited to a specified depth (7 here, with the entry level being 0). For this project, we have the following map, but the program should be able to handle any map represented in a similar way.

![Map for tests](./data/carte_reference.png "Map for tests")

Each Horcrux can be destroyed by a unique destruction method. Here is the description of the Horcruxes and their associated destruction methods:

- Journal intime de Tom Jedusor (Tom Riddle's Diary): Destruction method : Crochet de Basilic (Basilisk Hook)
- Médaillon de Salazar Serpentard (Salazar Slytherin's Locket): Destruction method : Epée de Gryffondor (Gryffindor's Sword)
- Bague de Gaunt (Gaunt's Ring): Destruction method : Epée de Gryffondor (Gryffindor's Sword)
- Coupe de Helga Poufsouffle (Helga Hufflepuff's Cup): Destruction method : Crochet de Basilic (Basilisk Hook)
- Nagini: Destruction method : Epée de Gryffondor (Gryffindor's Sword)
- Diadème de Rowena Serdaigle (Rowena Ravenclaw's Diadem): Destruction method : Feudeymon (Fiendfyre)
- Harry Potter: Destruction method : Sortilège de la Mort (Killing Curse)

The Horcruxes are hidden in the following squares:

- Journal intime de Tom Jedusor: 8
- Médaillon de Salazar Serpentard: 12
- Bague de Gaunt: 15
- Coupe de Helga Poufsouffle: 22
- Nagini: 26
- Diadème de Rowena Serdaigle: 29

The seventh Horcrux, Harry Potter, is mobile.

A destruction method can destroy multiple Horcruxes. Four destruction methods are hidden in the following squares:

- Crochet de Basilic: 3
- Sortilège de la Mort: 20
- Epée de Gryffondor: 25
- Feudeymon: 32

When arriving on a square, it's possible to acquire a destruction method if available. If arriving on a square for the first time, having the appropriate destruction method allows the destruction of the Horcrux (e.g., if on square 26, the Gryffindor's Sword is needed to destroy Nagini). It is not possible to destroy it if it's not the first time on that square. For example, passing the first time on square 12 without the Gryffindor's Sword means it cannot be destroyed. If returning a second time with the sword, it will be too late to destroy it.

Lord Voldemort will also explore the map. With each movement of Harry Potter to a new square, Lord Voldemort will move simultaneously. When Harry retraces his steps, Lord Voldemort does not move. The user must choose Lord Voldemort's square. The depth is always limited to 7.

Lord Voldemort can also collect weapons and destroy Horcruxes. Like Harry Potter, he can only destroy the Horcrux if:
- He has already collected the appropriate destruction method, and
- It's the first time he has come to that square.

However, the rules are different for the Harry Potter Horcrux. Lord Voldemort can destroy Harry Potter with the Killing Curse if he arrives on the same square, even if he has been there before. If Harry Potter dies, the game ends.

### Problem Representation

Four different lists will represent 1) the map, 2) the description of the Horcruxes, 3) the placement of the Horcruxes on the map, and 4) the placement of the destruction methods on the map.

Here are examples for each corresponding to the reference map.

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
Next, some examples of interesting requests.  
Each structure and different parameters' options are more detailled in commentary of each function in the code.  

The names map, horcruxesDescription, horcruxesMap et armesMap match with the test variables de test proposées dans le sujet du TP2. Toute variable ayant une structure similaire peut leur être substituée au sein des appels de fonction.

### Service Functions:
( successeurs-valides 22 map '(26 27 28))
( methodedestruction “Nagini” horcruxesDescription)
( hasbonneArme “Nagini” '(“Epée de Gryffondor” “Feudeymon”) Horcruxesdescription)

### Function RechercheProfondeur:
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur 24 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")

### Fnction rechercheProfondeurVoldemort:
(rechercheprofondeurVoldemort 1 3 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeurVoldemort 1 3 map horcruxesMap armesMap horcruxesDescription :affichage "log-arbre")

### Function rechercheProfondeur+:
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 3)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :affichage "events-arbre")
(rechercheprofondeur+ 24 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :fluxSortie "test32.txt" :affichage "events")

### Function rechercheProfondeurVoldemort+ :
(rechercheprofondeurVoldemort+ 1 3 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeurVoldemort+ 1 36 map horcruxesMap armesMap
horcruxesDescription :affichage "log-arbre" :profondeurMax 9 :fluxSortie "test333.txt")

### Function rechercheProfondeur++:
(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription
:profondeurMax 7 :dumbledore T :caseD 1)
(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription
:profondeurMax 7 :dumbledore T :caseD 1 :modeD "parallele")