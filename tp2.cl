;Donnees de test
(setq map '((1 12 2)(2 1 3)(3 2 4)(4 3 5)(5 4 8 6)(6 5 7)(7 8 6)(8 7 5)(12 13 1)
            (13 24 12)(15 22)(20 21 29)(21 22 20)(22 27 21 15)(24 25 13)
            (25 36 26 24)(26 25 27)(27 26 22)(29 32 20)(32 29)(36 25)))


(setq horcruxesDescription '(
                              ("Journal intime de Tom Jedusor" 
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
                                (methodeDestruction "Feudeymon"))
                            )
)

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


;Fonctions de service

(defun successeurs-valides (case carte cheminParcouru)

    ;Vérification de la validité du type des arguments
    (if (not (numberp case)) (print "successeurs-valides : Erreur : La case doit être un nombre"))
    (if (not (listp carte)) (print "successeurs-valides : Erreur : La carte doit être une liste"))
    (if (not (listp cheminParcouru)) (print "successeurs-valides : Erreur : Le chemin parcouru doit être une liste"))
    
    (let ((successeurs NIL))
        ;Traite chaque successeur de la case passée en paramètre puis inverse la liste des successeurs valides 
        ;pour la renvoyer dans l'ordre où ils se trouvaient dans la carte
        (dolist (x (cdr (assoc case carte)) (nreverse successeurs))
            ;Vérifie si un successeur n'a pas déjà été parcouru et l'ajoute aux successeurs valides si ce n'est pas le cas
            (if (not (member x cheminParcouru))
                (push x successeurs)
            )
        )
    )
)

( defun methodeDestruction (horcruxe horcruxesDescription)
    
    ;Vérification de la validité du type des arguments
    (if (not (stringp horcruxe)) (print "methodeDestruction : Erreur : Le Horcruxe testé doit être une chaîne de caractère"))
    (if (not (listp horcruxesDescription)) (print "methodeDestruction : Erreur : La description des horcruxes doit être sous forme de liste"))

    (cadr (cadr (assoc horcruxe horcruxesDescription :test #'string=)))

)

(defun hasBonneArme (horcruxe methodesPossedes horcruxesDescription)

    ;Vérification de la validité du type des arguments
    (if (not (stringp horcruxe)) (print "hasBonneArme : Erreur : Le Horcruxe testé doit être une chaîne de caractère"))
    (if (not (listp horcruxesDescription)) (print "hasBonneArme : Erreur : Les méthodes de destructions possédées doivent être sous forme de liste"))
    (if (not (listp horcruxesDescription)) (print "hasBonneArme : Erreur : La description des horcruxes doit être sous forme de liste"))

    (if (member (methodeDestruction horcruxe horcruxesdescription) methodespossedes :test #'string=)
        T ;On aurait directement pu renvoyer le résultat du test à la place de faire un if mais, dans le cas où l'on possède la méthode adpatée, on aurait alors renvoyé la fin de la liste et non simplement T. A noter que ces deux valeurs auraient toutefois été équivalentes dans le cas d'un test booléen
        NIL
    )
)

;Tests des fonctions
;(successeurs-valides 25 map '(1 12 13 24))


;Recherche en profondeur pour la recherche de Harry Potter

(defun rechercheProfondeur (case carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouru NIL) (armesPossedees NIL) (horcruxesDetruits NIL) (affichage "log-arbre"))
    ;Traitement de la case active
    ;Ajoute la case active au chemin parcouru
    (if cheminParcouru
        (setf (cdr (last cheminParcouru)) (list case))
        (setf cheminParcouru (list case))
    )
    ;Dans le mode events ou events-arbre, affichage de la case active
    (cond 
        ((equal affichage "events-arbre")(format t "~% ~% ~vTHarry est à la case ~s" profondeur case))
        ((equal affichage "events")(format t "~% ~% Harry est à la case ~s" case))
    )
    (let (
        (armeCase (assoc case carteArmes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
        (horcruxeCase (assoc case carteHorcruxes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
        )
        (if armeCase
            (progn
                (push (cadr armeCase) armesPossedees)
                ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                (cond 
                    ((equal affichage "events-arbre")(format t "~% ~% ~vTArme présente : ~s~% ~vTMéthodes de Destruction récupérées : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedees profondeur)) 
                    ((equal affichage "events")(format t "~% ~% Arme présente : ~s~% Méthodes de Destruction récupérées :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedees))
                )
            )
        )
        (if horcruxeCase
            (if (hasBonneArme (cadr horcruxeCase) armesPossedees descriptionHorcruxes)
                (progn
                    (push (cadr horcruxeCase) horcruxesDetruits)
                    ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                    (cond 
                        ((equal affichage "events-arbre")(format t "~% ~% ~vTHorcruxes présent : ~s~% ~vTHorcruxes détruits : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruits profondeur)) 
                        ((equal affichage "events")(format t "~% ~% Horcruxes présent : ~s~% Horcruxes détruits :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruits))
                    )
                )
                ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                (cond 
                    ((equal affichage "events-arbre")(format t "~% ~% ~vTHorcruxes présent : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                    ((equal affichage "events")(format t "~% ~% Horcruxes présent : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                )
            )
        )

        ;Dans le mode log ou log-arbre, affichage de la case actuelle, des méthodes de destruction possédées et des Horcruxes détruits
        (cond 
            ((equal affichage "log-arbre")(format t "~vT- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" profondeur case armespossedees horcruxesdetruits))
            ((equal affichage "log")(format t "- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" case armespossedees horcruxesdetruits))
        )

        ;Vérification que la profondeur maximum n'a pas été atteinte
        (if (< profondeur 7)
            ;Si elle ne l'a pas été, recherche et traitement des successeurs valides (non déjà parcouru notamment)
            (dolist (succ (successeurs-valides case carte cheminParcouru))
                (if (not (member succ cheminParcouru)) ;Nouvelle vérification que la case n'a pas déjà été parcourue dans le cas où elle aurait été parcourue lors d'un appel imbriqué ayant eu lieu après la recherche de successeurs valides
                    (let ((tmp (rechercheProfondeur succ carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouru cheminParcouru :armesPossedees armesPossedees :horcruxesDetruits horcruxesDetruits :affichage affichage)))
                        (setf horcruxesDetruits (car tmp)) ;On remplace la liste plutôt que de la modifier en place pour traiter le cas où HorcruxesDetruits est vide (égale à NIL et donc sans car et cdr)
                        (setf armesPossedees (cadr tmp))
                    )
                )
            )
            ;Sinon, on ne fait rien
        )

        ;Dans tous les cas, renvoie des horcruxes détruits et des méthodes de destruction possédées, qui ne servent pas pour les appels intermédiaires mais sont attendues pour le premier appel
        (list horcruxesDetruits armesPossedees)
    )
)

;Tests de la fonction
; (rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription)
; (rechercheprofondeur 24 map horcruxesMap armesMap horcruxesDescription)
; (rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
; (rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")


(defun afficher (sortie &rest params)
;sortie doit être T ou un chemin de fichier, sinon le comportement est imprévisible
;formattage doit être de la forme '(format flux ...), si le deuxième terme n'est pas exactement 'flux' le comportement est imprévisible
    (if (equal sortie t)
        ;Si le paramètre de flux de sortie est le flux standard, définit le flux comme le flux standard et exécute 
        (apply #'format (push t params))
        ;Sinon, on attend un chemin de fichier.
        (with-open-file (flux sortie :direction :output :if-exists :append :if-does-not-exist :create)
            (apply #'format (push flux params))
        )
    )
)

(defun rechercheProfondeur+ (case carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouru NIL) (armesPossedees NIL) (horcruxesDetruits NIL) (affichage "log-arbre") (profondeurMax 7) (fluxSortie T))
    ;Traitement de la case active
    ;Ajoute la case active au chemin parcouru
    (if cheminParcouru
        (setf (cdr (last cheminParcouru)) (list case))
        (setf cheminParcouru (list case))
    )
    ;Dans le mode events ou events-arbre, affichage de la case active
    (cond 
        ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHarry est à la case ~s" profondeur case))
        ((equal affichage "events")(afficher fluxSortie "~% ~% Harry est à la case ~s" case))
    )
    (let (
        (armeCase (assoc case carteArmes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
        (horcruxeCase (assoc case carteHorcruxes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
        )
        (if armeCase
            (progn
                (push (cadr armeCase) armesPossedees)
                ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                (cond 
                    ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTArme présente : ~s~% ~vTMéthodes de Destruction récupérées : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedees profondeur)) 
                    ((equal affichage "events")(afficher fluxSortie "~% ~% Arme présente : ~s~% Méthodes de Destruction récupérées :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedees))
                )
            )
        )
        (if horcruxeCase
            (if (hasBonneArme (cadr horcruxeCase) armesPossedees descriptionHorcruxes)
                (progn
                    (push (cadr horcruxeCase) horcruxesDetruits)
                    ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                    (cond 
                        ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHorcruxes présent : ~s~% ~vTHorcruxes détruits : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruits profondeur)) 
                        ((equal affichage "events")(afficher fluxSortie "~% ~% Horcruxes présent : ~s~% Horcruxes détruits :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruits))
                    )
                )
                ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                (cond 
                    ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHorcruxes présent : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                    ((equal affichage "events")(afficher fluxSortie "~% ~% Horcruxes présent : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                )
            )
        )

        ;Dans le mode log ou log-arbre, affichage de la case actuelle, des méthodes de destruction possédées et des Horcruxes détruits
        (cond 
            ((equal affichage "log-arbre")(afficher fluxSortie "~vT- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" profondeur case armespossedees horcruxesdetruits))
            ((equal affichage "log")(afficher fluxSortie "- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" case armespossedees horcruxesdetruits))
        )

        ;Vérification que la profondeur maximum n'a pas été atteinte
        (if (< profondeur profondeurMax)
            ;Si elle ne l'a pas été, recherche et traitement des successeurs valides (non déjà parcouru notamment)
            (dolist (succ (successeurs-valides case carte cheminParcouru))
                (if (not (member succ cheminParcouru)) ;Nouvelle vérification que la case n'a pas déjà été parcourue dans le cas où elle aurait été parcourue lors d'un appel imbriqué ayant eu lieu après la recherche de successeurs valides
                    (let ((tmp (rechercheProfondeur+ succ carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouru cheminParcouru :armesPossedees armesPossedees :horcruxesDetruits horcruxesDetruits :affichage affichage :profondeurMax profondeurMax :fluxSortie fluxSortie)))
                        (setf horcruxesDetruits (car tmp)) ;On remplace la liste plutôt que de la modifier en place pour traiter le cas où HorcruxesDetruits est vide (égale à NIL et donc sans car et cdr)
                        (setf armesPossedees (cadr tmp))
                    )
                )
            )
            ;Sinon, on ne fait rien
        )
        
        ;Dans tous les cas, renvoie des horcruxes détruits et des méthodes de destruction possédées, qui ne servent pas pour les appels intermédiaires mais sont attendues pour le premier appel
        (list horcruxesDetruits armesPossedees)
    )
)

(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 3)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :affichage "events-arbre")
(rechercheprofondeur+ 24 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")
(rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :fluxSortie "test32.txt" :affichage "events")

(defun rechercheProfondeur++ (case carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouru NIL) (armesPossedees NIL) (horcruxesDetruits NIL) (affichage "log-arbre") (profondeurMax 7) (fluxSortie T) (dumbledore NIL) (caseD 1) (fileD NIL) (cheminParcouruD NIL) (armesPossedeesD NIL) (horcruxesDetruitsD NIL) (modeD "collab"))
    ;Traitement de la case active de Harry
    ;Ajoute la case active au chemin parcouru
    (if cheminParcouru
        (setf (cdr (last cheminParcouru)) (list case))
        (setf cheminParcouru (list case))
    )
    ;Dans le mode events ou events-arbre, affichage de la case active
    (cond 
        ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHarry est à la case ~s" profondeur case))
        ((equal affichage "events")(afficher fluxSortie "~% ~% Harry est à la case ~s" case))
    )
    (let (
        (armeCase (assoc case carteArmes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
        (horcruxeCase (assoc case carteHorcruxes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
        )
        (if (and armeCase (or (equal modeD "parallele") (not (member (cadr armeCase) armesPossedeesD))))
            (progn
                (push (cadr armeCase) armesPossedees)
                ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                (cond 
                    ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTArme présente : ~s~% ~vTMéthodes de Destruction récupérées par Harry : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedees profondeur)) 
                    ((equal affichage "events")(afficher fluxSortie "~% ~% Arme présente : ~s~% Méthodes de Destruction récupérées par Harry :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedees))
                )
            )
        )
        (if (and horcruxeCase (or (equal modeD "parallele") (not (member (cadr horcruxeCase) horcruxesDetruitsD))))
            (if (hasBonneArme (cadr horcruxeCase) armesPossedees descriptionHorcruxes)
                (progn
                    (push (cadr horcruxeCase) horcruxesDetruits)
                    ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                    (cond 
                        ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHorcruxes présent : ~s~% ~vTHorcruxes détruits par Harry : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruits profondeur)) 
                        ((equal affichage "events")(afficher fluxSortie "~% ~% Horcruxes présent : ~s~% Horcruxes détruits par Harry :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruits))
                    )
                )
                ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                (cond 
                    ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHorcruxes présent : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                    ((equal affichage "events")(afficher fluxSortie "~% ~% Horcruxes présent : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                )
            )
        )
    )

    ;Si Dumbledore est présent, traitement de la case active de Dumbledore
    (if dumbledore
        (progn
            ;Ajoute la case active au chemin parcouru
            (if cheminParcouruD
                (setf (cdr (last cheminParcouruD)) (list caseD))
                (setf cheminParcouruD (list caseD))
            )
            ;Ajout des successeurs de la case active à la file des cases suivantes à parcourir
            (dolist (succ (successeurs-valides caseD carte cheminParcouruD))
                (if (not (member succ fileD)) ;On vérifie que le successeur n'est pas déjà dans la file des cases à parcourir
                    (if fileD
                        (setf (cdr (last fileD)) (list succ))
                        (setf fileD (list succ)) ;Dans le cas où fileD est v
                    )
                )
            )
            ;Dans le mode events ou events-arbre, affichage de la case active
            (cond 
                ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTDumbledore est à la case ~s" profondeur caseD))
                ((equal affichage "events")(afficher fluxSortie "~% ~% Dumbledore est à la case ~s" caseD))
            )
            (let (
                (armeCaseD (assoc caseD carteArmes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
                (horcruxeCaseD (assoc caseD carteHorcruxes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                )
                (if (and armeCaseD (or (equal modeD "parallele") (not (member (cadr armeCaseD) armesPossedees))))
                    (progn
                        (push (cadr armeCaseD) armesPossedeesD)
                        ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                        (cond 
                            ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTArme présente : ~s~% ~vTMéthodes de Destruction récupérées par Dumbledore : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCaseD) profondeur armesPossedeesD profondeur)) 
                            ((equal affichage "events")(afficher fluxSortie "~% ~% Arme présente : ~s~% Méthodes de Destruction récupérées par Dumbledore :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCaseD) armesPossedeesD))
                        )
                    )
                )
                (if (and horcruxeCaseD (or (equal modeD "parallele") (not (member (cadr horcruxeCaseD) horcruxesDetruits))))
                    (if (hasBonneArme (cadr horcruxeCaseD) armesPossedeesD descriptionHorcruxes)
                        (progn
                            (push (cadr horcruxeCaseD) horcruxesDetruitsD)
                            ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                            (cond 
                                ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHorcruxes présent : ~s~% ~vTHorcruxes détruits par Dumbledore : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCaseD) profondeur horcruxesDetruitsD profondeur)) 
                                ((equal affichage "events")(afficher fluxSortie "~% ~% Horcruxes présent : ~s~% Horcruxes détruits par Dumbledore :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCaseD) horcruxesDetruitsD))
                            )
                        )
                        ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                        (cond 
                            ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHorcruxes présent : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée par Dumbledore !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être par Dumbledore !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCaseD) profondeur profondeur profondeur)) 
                            ((equal affichage "events")(afficher fluxSortie "~% ~% Horcruxes présent : ~s~% La méthode de destruction nécessaire n'est pas possédée par Dumbledore !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être par Dumbledore !~%~% Passage à la case suivante..." (cadr horcruxeCaseD)))
                        )
                    )
                )
            )
        )
    )

    ;Dans le mode log ou log-arbre, affichage pour Harry de la case actuelle, des méthodes de destruction possédées et des Horcruxes détruits
    (cond 
        ((equal affichage "log-arbre")(afficher fluxSortie "~%~vT- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}" profondeur case armespossedees horcruxesdetruits))
        ((equal affichage "log")(afficher fluxSortie "~%- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}" case armespossedees horcruxesdetruits))
    )
    ;Dans le mode log ou log-arbre, affichage pour Dumbledore s'il est présent de la case actuelle, des méthodes de destruction possédées, des Horcruxes détruits et de la file des cases suivantes à parcourir
    (if (and dumbledore (or (equal affichage "log-arbre") (equal affichage "log")))
        (afficher fluxSortie " | Dubledore (case ~a) : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}} Cases à parcourir : {~{'~a'~^, ~}}" caseD armespossedeesD horcruxesdetruitsD fileD)
    )

    ;Vérification que la profondeur maximum n'a pas été atteinte
    (if (< profondeur profondeurMax)
        ;Si elle ne l'a pas été, recherche et traitement des successeurs valides (non déjà parcouru notamment)
        (dolist (succ (successeurs-valides case carte cheminParcouru))
            (if (not (member succ cheminParcouru)) ;Nouvelle vérification que la case n'a pas déjà été parcourue dans le cas où elle aurait été parcourue lors d'un appel imbriqué ayant eu lieu après la recherche de successeurs valides
                (if (and dumbledore fileD)
                    ;Si Dumbledore est présent et qu'il reste des cases valides à parcourir, on traite la case suivante au cours du prochain appel récursif
                    (let ((tmp (rechercheProfondeur++ succ carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouru cheminParcouru :armesPossedees armesPossedees :horcruxesDetruits horcruxesDetruits :affichage affichage :profondeurMax profondeurMax :fluxSortie fluxSortie :dumbledore dumbledore :caseD (pop fileD) :fileD fileD :cheminParcouruD cheminParcouruD :horcruxesDetruitsD horcruxesDetruitsD :armesPossedeesD armesPossedeesD :modeD modeD)))
                        (setf horcruxesDetruits (car tmp)) ;On remplace la liste plutôt que de la modifier en place pour traiter le cas où HorcruxesDetruits est vide (égale à NIL et donc sans car et cdr valides)
                        (setf armesPossedees (cadr tmp))
                        (setf horcruxesDetruitsD (caddr tmp))
                        (setf armesPossedeesD (cadddr tmp))
                        (setf fileD (cadr(cdddr tmp)))
                    )
                    ;Sinon, on lance une recherche comme s'il n'était pas là
                    (let ((tmp (rechercheProfondeur++ succ carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouru cheminParcouru :armesPossedees armesPossedees :horcruxesDetruits horcruxesDetruits :affichage affichage :profondeurMax profondeurMax :fluxSortie fluxSortie :dumbledore NIL :modeD modeD)))
                        (setf horcruxesDetruits (car tmp)) ;On remplace la liste plutôt que de la modifier en place pour traiter le cas où HorcruxesDetruits est vide (égale à NIL et donc sans car et cdr valides)
                        (setf armesPossedees (cadr tmp))
                    )
                )
            )
        )
        ;Sinon, on ne fait rien
    )
    
    ;Dans tous les cas, renvoie des horcruxes détruits et des méthodes de destruction possédées, qui ne servent pas pour les appels intermédiaires mais sont attendues pour le premier appel
    (if dumbledore
        (list horcruxesDetruits armesPossedees horcruxesDetruitsD armesPossedeesD fileD)
        (list horcruxesDetruits armesPossedees)
    )
)

(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 7 :dumbledore T :caseD 1)
(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 7 :dumbledore T :caseD 1 :modeD "parallele")