;Donnees de test
; (setq map '((1 12 2)(2 1 3)(3 2 4)(4 3 5)(5 4 8 6)(6 5 7)(7 8 6)(8 7 5)(12 13 1)
;             (13 24 12)(15 22)(20 21 29)(21 22 20)(22 27 21 15)(24 25 13)
;             (25 36 26 24)(26 25 27)(27 26 22)(29 32 20)(32 29)(36 25)))


; (setq horcruxesDescription '(
;                               ("Journal intime de Tom Jedusor" 
;                                 (methodeDestruction "Crochet de Basilic"))
;                              ("Médaillon de Salazar Serpentard" 
;                                 (methodeDestruction "Epée de Gryffondor"))
;                              ("Bague de Gaunt" 
;                                 (methodeDestruction "Epée de Gryffondor"))
;                              ("Coupe de Helga Poufsouffle" 
;                                 (methodeDestruction "Crochet de Basilic"))
;                              ("Nagini" 
;                                 (methodeDestruction "Epée de Gryffondor"))
;                              ("Diadème de Rowena Serdaigle" 
;                                 (methodeDestruction "Feudeymon"))
;                             )
; )

; (setq horcruxesMap '((8 "Journal intime de Tom Jedusor")
;                      (12 "Médaillon de Salazar Serpentard")
;                      (15 "Bague de Gaunt")
;                      (22 "Coupe de Helga Poufsouffle")
;                      (26 "Nagini")
;                      (29 "Diadème de Rowena Serdaigle")))

; (setq armesMap '((3 "Crochet de Basilic")
;                  (32 "Feudeymon")
;                  (25 "Epée de Gryffondor")
;                  (20 "Sortilège de la Mort")))   


;Fonctions de service

(defun successeurs-valides (case carte cheminParcouru)
;Renvoie la liste des successeurs valides d'une case donnée

    ;Vérification de la validité du type des arguments
    (cond
        ((not (numberp case)) (print "successeurs-valides : Erreur : La case doit être un nombre"))
        ((not (listp carte)) (print "successeurs-valides : Erreur : La carte doit être une liste"))
        ((not (listp cheminParcouru)) (print "successeurs-valides : Erreur : Le chemin parcouru doit être une liste"))
        (T
            
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
    )
)

( defun methodeDestruction (horcruxe horcruxesDescription)
;Renvoie une chaîne de caractère correspondant à la méthode de destruction associée à un Horcruxe donné
    
    ;Vérification de la validité du type des arguments
    (cond
        ((not (stringp horcruxe)) (print "methodeDestruction : Erreur : Le Horcruxe testé doit être une chaîne de caractère"))
        ((not (listp horcruxesDescription)) (print "methodeDestruction : Erreur : La description des horcruxes doit être sous forme de liste"))

        (T (cadr (cadr (assoc horcruxe horcruxesDescription :test #'string=))))
    )
)

(defun hasBonneArme (horcruxe methodesPossedes horcruxesDescription)
;Renvoie T si la méthode de destruction associée à un Horcruxe donnée appartient à methodesPossedes, NIL sinon

    ;Vérification de la validité du type des arguments
    (cond
        ((not (stringp horcruxe)) (print "hasBonneArme : Erreur : Le Horcruxe testé doit être une chaîne de caractère"))
        ((not (listp horcruxesDescription)) (print "hasBonneArme : Erreur : Les méthodes de destructions possédées doivent être sous forme de liste"))
        ((not (listp horcruxesDescription)) (print "hasBonneArme : Erreur : La description des horcruxes doit être sous forme de liste"))

        (t
            (if (member (methodeDestruction horcruxe horcruxesdescription) methodespossedes :test #'string=)
                T ;On aurait directement pu renvoyer le résultat du test à la place de faire un if mais, dans le cas où l'on possède la méthode adpatée, on aurait alors renvoyé la fin de la liste et non simplement T. A noter que ces deux valeurs auraient toutefois été équivalentes dans le cas d'un test booléen
                NIL
            )
        )
    )
)

;Tests des fonctions
;(successeurs-valides 25 map '(1 12 13 24))


;Recherche en profondeur pour la recherche de Harry Potter

(defun rechercheProfondeur (case carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouru NIL) (armesPossedees NIL) (horcruxesDetruits NIL) (affichage "log-arbre"))
;Effectue un parcours en profondeur de profondeur 7 au maximum et renvoie une liste composée de la liste des Horcruxes détruits et de la liste des méthodes de destruction récupérées

    ;Vérification du type des arguments passés en paramètre
    (cond
        ((not (numberp case))(print "rechercheProfondeur : Erreur : La case doit être un nombre"))
        ((not (listp carte))(print "rechercheProfondeur : Erreur : La carte doit être une liste"))
        ((not (listp carteHorcruxes))(print "rechercheProfondeur : Erreur : La carte des Horcruxes doit être une liste"))
        ((not (listp carteArmes))(print "rechercheProfondeur : Erreur : La carte des méthodes de destruction (carteArme) doit être une liste"))
        ((not (listp descriptionHorcruxes))(print "rechercheProfondeur : Erreur : La description des Horcruxes doit être sous forme de liste"))
        ((not (numberp profondeur))(print "rechercheProfondeur : Erreur : La profondeur doit être un nombre"))
        ((not (listp cheminParcouru))(print "rechercheProfondeur : Erreur : Le chemin parcouru doit être sous forme de liste"))
        ((not (listp horcruxesDetruits))(print "rechercheProfondeur : Erreur : Les Horcruxes détruits doivent être sous forme d'une liste"))
        ((not (listp armesPossedees))(print "rechercheProfondeur : Erreur : Les méthodes de destruction (armes) possédées doivent être sous forme d'une liste"))
        ((not (member affichage '("log" "log-arbre" "events" "events-arbre") :test #'string=))(print "rechercheProfondeur : Erreur : Le mode d'affichage doit être une chaîne de caractère valant log, log-arbre, events ou events-arbre"))
        (T (progn
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
                (armeCase (assoc case carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc case carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
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

                ;Vérification que la profondeur maximum n'a pas été atteinte et que tous les Horcruxes n'ont pas déjà été trouvés
                (if (and (< profondeur 7) (< (length horcruxesDetruits) 6))
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
        ))
    )
)

;Tests de la fonction
; (rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription)
; (rechercheprofondeur 24 map horcruxesMap armesMap horcruxesDescription)
; (rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
; (rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")


(defun rechercheProfondeurVoldemort (caseHarry caseVoldemort carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouruHarry NIL) (armesPossedeesHarry NIL) (horcruxesDetruitsHarry NIL) (cheminParcouruVoldemort NIL) (armesPossedeesVoldemort NIL) (horcruxesDetruitsVoldemort NIL) (affichage "events"))
;Effectue un parcours en profondeur de profondeur 7 au maximum et renvoie une liste composée de la liste des Horcruxes détruits et de la liste des méthodes de destruction récupérées

    ;Vérification du type des arguments passés en paramètre
    (cond
        ((not (numberp caseHarry))(print "rechercheProfondeur : Erreur : La case de Harry doit être un nombre"))
        ((not (numberp caseVoldemort))(print "rechercheProfondeur : Erreur : La case de Voldemort doit être un nombre"))
        ((not (listp carte))(print "rechercheProfondeur : Erreur : La carte doit être une liste"))
        ((not (listp carteHorcruxes))(print "rechercheProfondeur : Erreur : La carte des Horcruxes doit être une liste"))
        ((not (listp carteArmes))(print "rechercheProfondeur : Erreur : La carte des méthodes de destruction (carteArme) doit être une liste"))
        ((not (listp descriptionHorcruxes))(print "rechercheProfondeur : Erreur : La description des Horcruxes doit être sous forme de liste"))
        ((not (numberp profondeur))(print "rechercheProfondeur : Erreur : La profondeur doit être un nombre"))
        ((not (listp cheminParcouruHarry))(print "rechercheProfondeur : Erreur : Le chemin parcouru par Harry doit être sous forme de liste"))
        ((not (listp horcruxesDetruitsHarry))(print "rechercheProfondeur : Erreur : Les Horcruxes détruits par Harry doivent être sous forme d'une liste"))
        ((not (listp armesPossedeesHarry))(print "rechercheProfondeur : Erreur : Les méthodes de destruction (armes) possédées par Harry doivent être sous forme d'une liste"))
        ((not (listp cheminParcouruVoldemort))(print "rechercheProfondeur : Erreur : Le chemin parcouru par Voldemort doit être sous forme de liste"))
        ((not (listp horcruxesDetruitsVoldemort))(print "rechercheProfondeur : Erreur : Les Horcruxes détruits par Voldemort doivent être sous forme d'une liste"))
        ((not (listp armesPossedeesVoldemort))(print "rechercheProfondeur : Erreur : Les méthodes de destruction (armes) possédées par Voldemort doivent être sous forme d'une liste"))
        ((not (member affichage '("log" "log-arbre" "events" "events-arbre") :test #'string=))(print "rechercheProfondeur : Erreur : Le mode d'affichage doit être une chaîne de caractère valant log, log-arbre, events ou events-arbre"))
        (T (progn

            ;ici on teste si Harry et VDM sont sur la même case et si VDM possède la méthode nécessaire pour tuer Harry (qui est un horcruxe)
            (when (and (equal caseHarry  caseVoldemort) (member "Sortilège de la Mort" ArmesPossedeesVoldemort :test #'string=))  
            ;Dans ce cas, #'string= indique que la comparaison doit être faite en utilisant l'égalité de chaînes de caractères.
                (return-from rechercheProfondeurVoldemort (list "Harry Potter a été tué par Voldemort"))
            ) 
                ;ici on sort directement de la fonction grâce à return-from car le jeu est perdu, harry est mort

            ;Traitement de la case active de Harry
            ;Ajoute la case active au chemin parcouru
            (if cheminParcouruHarry
                (setf (cdr (last cheminParcouruHarry)) (list caseHarry))
                (setf cheminParcouruHarry (list caseHarry))
            );on rajoute la position actuelle de Harry à son chemin parcouru

            ;Dans le mode events ou events-arbre, affichage de la case active
            (cond 
                ((equal affichage "events-arbre")(format t "~% ~% ~vTHarry est à la case ~s" profondeur caseHarry))
                ((equal affichage "events")(format t "~% ~% Harry est à la case ~s" caseHarry))
            )
            (let (
                (armeCase (assoc caseHarry carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc caseHarry carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
                )
                (if (and armeCase (not (member (cadr armeCase) armesPossedeesVoldemort)))
                    (progn
                        (push (cadr armeCase) armesPossedeesHarry)
                        ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                        (cond 
                            ((equal affichage "events-arbre")(format t "~% ~% ~vTSur cette case se trouve la Méthode : ~s~% ~vTMéthodes de Destruction récupérées : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedeesHarry profondeur)) 
                            ((equal affichage "events")(format t "~% ~% Sur cette case se trouve la Méthode : ~s~% Méthodes de Destruction récupérées :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedeesHarry))
                        )
                    )
                )
                (if (and horcruxeCase (not (member (cadr horcruxeCase) horcruxesDetruitsVoldemort)))
                    (if (hasBonneArme (cadr horcruxeCase) armesPossedeesHarry descriptionHorcruxes)
                        (progn
                            (push (cadr horcruxeCase) horcruxesDetruitsHarry)
                            ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                            (cond 
                                ((equal affichage "events-arbre")(format t "~% ~% ~vTL'horcruxe présent sur cette case est : ~s~% ~vTHorcruxes détruits : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruitsHarry profondeur)) 
                                ((equal affichage "events")(format t "~% ~% L'horcruxe présent sur cette case est : ~s~% Horcruxes détruits :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruitsHarry))
                            )
                        )
                        ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                        (cond 
                            ((equal affichage "events-arbre")(format t "~% ~% ~vTL'horcruxe présent sur cette case est : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                            ((equal affichage "events")(format t "~% ~% L'horcruxe présent sur cette case est : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                        )
                    )
                )
            )

            ;Traitement de la case active de Voldemort
            ;Ajoute la case active au chemin parcouru
            (if cheminParcouruVoldemort
                (setf (cdr (last cheminParcouruVoldemort)) (list caseVoldemort))
                (setf cheminParcouruVoldemort (list caseVoldemort))
            );cela revient à (push caseVoldemort cheminParcouruVoldemort)

            ;Dans le mode events ou events-arbre, affichage de la case active
            (cond 
                ((equal affichage "events-arbre")(format t "~% ~% ~vTVoldemort est sur la case ~s" profondeur caseVoldemort))
                ((equal affichage "events")(format t "~% ~% Voldemort est sur la case ~s" caseVoldemort))
            )
            (let (
                (armeCase (assoc caseVoldemort carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc caseVoldemort carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
                )
                (if (and armeCase (and (not (member (cadr armeCase) armesPossedeesVoldemort)) (not (member (cadr armeCase) armesPossedeesHarry))))
                    (progn
                        (push (cadr armeCase) armesPossedeesVoldemort)
                        ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                        (cond 
                            ((equal affichage "events-arbre")(format t "~% ~% ~vTLa méthode présente sur la case de Voldemort est : ~s~% ~vTMéthodes de Destruction récupérées : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedeesVoldemort profondeur)) 
                            ((equal affichage "events")(format t "~% ~% La méthode présente sur la case de Voldemort est : ~s~% Méthodes de Destruction récupérées :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedeesVoldemort))
                        )
                    )
                )
                (if (and horcruxeCase (and (not (member (cadr horcruxeCase) horcruxesDetruitsVoldemort)) (not (member (cadr horcruxeCase) horcruxesDetruitsHarry))))
                    (if (hasBonneArme (cadr horcruxeCase) armesPossedeesVoldemort descriptionHorcruxes)
                        (progn
                            (push (cadr horcruxeCase) horcruxesDetruitsVoldemort)
                            ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                            (cond
                                ((equal affichage "events-arbre")(format t "~% ~% ~vTL'Horcruxe présent sur la case de Voldemort est : ~s~% ~vTHorcruxes détruits : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruitsVoldemort profondeur)) 
                                ((equal affichage "events")(format t "~% ~% L'Horcruxe présent sur la case de Voldemort est : ~s~% Horcruxes détruits :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruitsVoldemort))
                            )
                        )
                        ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                        (cond 
                            ((equal affichage "events-arbre")(format t "~% ~% ~vTL'Horcruxe présent sur la case de Voldemort est : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                            ((equal affichage "events")(format t "~% ~% L'Horcruxe présent sur la case de Voldemort est : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                        )
                    )
                )
            )

            ;Dans le mode log ou log-arbre, affichage de la case actuelle, des méthodes de destruction possédées et des Horcruxes détruits
            (cond 
                ((equal affichage "log-arbre")(format t "~vT- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}} | Voldemort : Case ~a Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" profondeur caseHarry armespossedeesHarry horcruxesdetruitsHarry caseVoldemort armespossedeesVoldemort horcruxesdetruitsVoldemort))
                ((equal affichage "log")(format t "- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}} | Voldemort : Case ~a Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" caseHarry armespossedeesHarry horcruxesdetruitsHarry caseVoldemort armespossedeesVoldemort horcruxesdetruitsVoldemort))
            )

            ;Vérification que la profondeur maximum n'a pas été atteinte et que tous les Horcruxes n'ont pas déjà été trouvés
            (if (and (< profondeur 7) (< (length horcruxesDetruitsHarry) 6))
                (let ((inputCase NIL)(succ_voldemort NIL))                    
                    ;Si elle ne l'a pas été, recherche et traitement des successeurs valides (non déjà parcouru notamment)
                    (dolist (succ (successeurs-valides caseHarry carte cheminParcouruHarry))
                        (if (not (member succ cheminParcouruHarry)) ;Nouvelle vérification que la case n'a pas déjà été parcourue dans le cas où elle aurait été parcourue lors d'un appel imbriqué ayant eu lieu après la recherche de successeurs valides
                            (progn
                                ;On cherche les cases adjacentes à la case active de Voldemort et on demande à l'utilisateur la case à laquelle Voldemort doit se déplacer
                                (setq succ_voldemort (assoc caseVoldemort carte))
                                (format t "~% Cases suivantes possibles pour Voldemort : ~{~% ~s~^~} ~% Entrer la case choisie: " succ_voldemort)
                                (setq inputCase (read))
                                (let ((tmp (rechercheProfondeurVoldemort succ inputCase carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouruHarry cheminParcouruHarry :armesPossedeesHarry armesPossedeesHarry :horcruxesDetruitsHarry horcruxesDetruitsHarry :cheminParcouruVoldemort cheminParcouruVoldemort :armesPossedeesVoldemort armesPossedeesVoldemort :horcruxesDetruitsVoldemort horcruxesDetruitsVoldemort :affichage affichage)))
                                    (setf horcruxesDetruitsHarry (car tmp)) ;On remplace la liste plutôt que de la modifier en place pour traiter le cas où HorcruxesDetruits est vide (égale à NIL et donc sans car et cdr)
                                    (setf armesPossedeesHarry (cadr tmp))
                                    (setf horcruxesDetruitsVoldemort (caddr tmp))
                                    (setf armesPossedeesVoldemort (cadddr tmp))
                                    (setf caseVoldemort (cadr (cdddr tmp)))
                                )
                            )
                        )
                    )
                )
                ;Sinon, on ne fait rien
            )

            ;Dans tous les cas, renvoie des horcruxes détruits et des méthodes de destruction possédées, qui ne servent pas pour les appels intermédiaires mais sont attendues pour le premier appel
            (list horcruxesDetruitsHarry armesPossedeesHarry horcruxesDetruitsVoldemort armesPossedeesVoldemort caseVoldemort)
        ))
    )
)

;Tests de la fonction rechercheProfondeurVoldemort
;(rechercheprofondeurVoldemort 1 3 map horcruxesMap armesMap horcruxesDescription)
;(rechercheprofondeurVoldemort 1 3 map horcruxesMap armesMap horcruxesDescription :affichage "log-arbre")

(defun afficher (sortie &rest params)
;Affiche un texte formatté dans un flux de sortie donné, qui peut être le flux standard (T) ou un fichier sous forme de chemin
    (cond
        ;Vérification de la conformité de sortie, les autres paramètres étant difficilement controlables
        ((not (or (equal T sortie) (stringp sortie)))(print "rechercheProfondeur+ : Erreur : Le flux de sortie doit être le flux standard (T) ou un chemin de fichier représenté par une chaîne de caractère"))
        (T  

            (if (equal sortie t)
                ;Si le paramètre de flux de sortie est le flux standard, définit le flux comme le flux standard et exécute 
                (apply #'format (push t params))
                ;Sinon, on attend un chemin de fichier et on écris alors à la suite de ce fichier s'il existe, sinon on le créé
                (with-open-file (flux sortie :direction :output :if-exists :append :if-does-not-exist :create)
                    (apply #'format (push flux params))
                )
            )
        )
    )
)

(defun rechercheProfondeur+ (case carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouru NIL) (armesPossedees NIL) (horcruxesDetruits NIL) (affichage "log-arbre") (profondeurMax 7) (fluxSortie T))
;Effectue un parcours en profondeur de profondeur donnée (7 par défaut) au maximum et renvoie une liste composée de la liste des Horcruxes détruits et de la liste des méthodes de destruction récupérées

    ;Vérification du type des arguments passés en paramètre
    (cond
        ((not (numberp case))(print "rechercheProfondeur+ : Erreur : La case doit être un nombre"))
        ((not (listp carte))(print "rechercheProfondeur+ : Erreur : La carte doit être une liste"))
        ((not (listp carteHorcruxes))(print "rechercheProfondeur+ : Erreur : La carte des Horcruxes doit être une liste"))
        ((not (listp carteArmes))(print "rechercheProfondeur+ : Erreur : La carte des méthodes de destruction (carteArme) doit être une liste"))
        ((not (listp descriptionHorcruxes))(print "rechercheProfondeur+ : Erreur : La description des Horcruxes doit être sous forme de liste"))
        ((not (numberp profondeur))(print "rechercheProfondeur+ : Erreur : La profondeur doit être un nombre"))
        ((not (listp cheminParcouru))(print "rechercheProfondeur+ : Erreur : Le chemin parcouru doit être sous forme de liste"))
        ((not (listp horcruxesDetruits))(print "rechercheProfondeur+ : Erreur : Les Horcruxes détruits doivent être sous forme d'une liste"))
        ((not (listp armesPossedees))(print "rechercheProfondeur+ : Erreur : Les méthodes de destruction (armes) possédées doivent être sous forme d'une liste"))
        ((not (member affichage '("log" "log-arbre" "events" "events-arbre") :test #'string=))(print "rechercheProfondeur+ : Erreur : Le mode d'affichage doit être une chaîne de caractère valant log, log-arbre, events ou events-arbre"))
        ((not (numberp profondeurMax))(print "rechercheProfondeur+ : Erreur : La profondeur maximale doit être un nombre"))
        ((not (or (equal T fluxSortie) (stringp fluxSortie)))(print "rechercheProfondeur+ : Erreur : Le flux de sortie doit être le flux standard (T) ou un chemin de fichier représenté par une chaîne de caractère"))
        (T (progn
    
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
                (armeCase (assoc case carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc case carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
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

                ;Vérification que la profondeur maximum n'a pas été atteinte et que tous les Horcruxes n'ont pas déjà été trouvés
                (if (and (< profondeur profondeurMax) (< (length horcruxesDetruits) 6))
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
        ))
    )
)

;Tests de rechercheProfondeur+
; (rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 3)
; (rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :affichage "events-arbre")
; (rechercheprofondeur+ 24 map horcruxesMap armesMap horcruxesDescription)
; (rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
; (rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")
; (rechercheprofondeur+ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 12 :fluxSortie "test32.txt" :affichage "events")


(defun rechercheProfondeurVoldemort+ (caseHarry caseVoldemort carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouruHarry NIL) (armesPossedeesHarry NIL) (horcruxesDetruitsHarry NIL) (cheminParcouruVoldemort NIL) (armesPossedeesVoldemort NIL) (horcruxesDetruitsVoldemort NIL) (affichage "events") (profondeurMax 7) (fluxSortie T))
;Effectue un parcours en profondeur de profondeur 7 au maximum et renvoie une liste composée de la liste des Horcruxes détruits et de la liste des méthodes de destruction récupérées

    ;Vérification du type des arguments passés en paramètre
    (cond
        ((not (numberp caseHarry))(print "rechercheProfondeur : Erreur : La case de Harry doit être un nombre"))
        ((not (numberp caseVoldemort))(print "rechercheProfondeur : Erreur : La case de Voldemort doit être un nombre"))
        ((not (listp carte))(print "rechercheProfondeur : Erreur : La carte doit être une liste"))
        ((not (listp carteHorcruxes))(print "rechercheProfondeur : Erreur : La carte des Horcruxes doit être une liste"))
        ((not (listp carteArmes))(print "rechercheProfondeur : Erreur : La carte des méthodes de destruction (carteArme) doit être une liste"))
        ((not (listp descriptionHorcruxes))(print "rechercheProfondeur : Erreur : La description des Horcruxes doit être sous forme de liste"))
        ((not (numberp profondeur))(print "rechercheProfondeur : Erreur : La profondeur doit être un nombre"))
        ((not (listp cheminParcouruHarry))(print "rechercheProfondeur : Erreur : Le chemin parcouru par Harry doit être sous forme de liste"))
        ((not (listp horcruxesDetruitsHarry))(print "rechercheProfondeur : Erreur : Les Horcruxes détruits par Harry doivent être sous forme d'une liste"))
        ((not (listp armesPossedeesHarry))(print "rechercheProfondeur : Erreur : Les méthodes de destruction (armes) possédées par Harry doivent être sous forme d'une liste"))
        ((not (listp cheminParcouruVoldemort))(print "rechercheProfondeur : Erreur : Le chemin parcouru par Voldemort doit être sous forme de liste"))
        ((not (listp horcruxesDetruitsVoldemort))(print "rechercheProfondeur : Erreur : Les Horcruxes détruits par Voldemort doivent être sous forme d'une liste"))
        ((not (listp armesPossedeesVoldemort))(print "rechercheProfondeur : Erreur : Les méthodes de destruction (armes) possédées par Voldemort doivent être sous forme d'une liste"))
        ((not (member affichage '("log" "log-arbre" "events" "events-arbre") :test #'string=))(print "rechercheProfondeur : Erreur : Le mode d'affichage doit être une chaîne de caractère valant log, log-arbre, events ou events-arbre"))
        ((not (numberp profondeurMax))(print "rechercheProfondeur+ : Erreur : La profondeur maximale doit être un nombre"))
        ((not (or (equal T fluxSortie) (stringp fluxSortie)))(print "rechercheProfondeur+ : Erreur : Le flux de sortie doit être le flux standard (T) ou un chemin de fichier représenté par une chaîne de caractère"))
        (T (progn

            ;ici on teste si Harry et VDM sont sur la même case et si VDM possède la méthode nécessaire pour tuer Harry (qui est un horcruxe)
            (when (and (equal caseHarry  caseVoldemort) (member "Sortilège de la Mort" ArmesPossedeesVoldemort :test #'string=))  
            ;Dans ce cas, #'string= indique que la comparaison doit être faite en utilisant l'égalité de chaînes de caractères.
                (return-from rechercheProfondeurVoldemort (list "Harry Potter a été tué par Voldemort"))
            ) 
                ;ici on sort directement de la fonction grâce à return-from car le jeu est perdu, harry est mort

            ;Traitement de la case active de Harry
            ;Ajoute la case active au chemin parcouru
            (if cheminParcouruHarry
                (setf (cdr (last cheminParcouruHarry)) (list caseHarry))
                (setf cheminParcouruHarry (list caseHarry))
            );on rajoute la position actuelle de Harry à son chemin parcouru

            ;Dans le mode events ou events-arbre, affichage de la case active
            (cond 
                ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTHarry est à la case ~s" profondeur caseHarry))
                ((equal affichage "events")(afficher fluxSortie "~% ~% Harry est à la case ~s" caseHarry))
            )
            (let (
                (armeCase (assoc caseHarry carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc caseHarry carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
                )
                (if (and armeCase (not (member (cadr armeCase) armesPossedeesVoldemort)))
                    (progn
                        (push (cadr armeCase) armesPossedeesHarry)
                        ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                        (cond 
                            ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTSur cette case se trouve la Méthode : ~s~% ~vTMéthodes de Destruction récupérées : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedeesHarry profondeur)) 
                            ((equal affichage "events")(afficher fluxSortie "~% ~% Sur cette case se trouve la Méthode : ~s~% Méthodes de Destruction récupérées :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedeesHarry))
                        )
                    )
                )
                (if (and horcruxeCase (not (member (cadr horcruxeCase) horcruxesDetruitsVoldemort)))
                    (if (hasBonneArme (cadr horcruxeCase) armesPossedeesHarry descriptionHorcruxes)
                        (progn
                            (push (cadr horcruxeCase) horcruxesDetruitsHarry)
                            ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                            (cond 
                                ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTL'horcruxe présent sur cette case est : ~s~% ~vTHorcruxes détruits : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruitsHarry profondeur)) 
                                ((equal affichage "events")(afficher fluxSortie "~% ~% L'horcruxe présent sur cette case est : ~s~% Horcruxes détruits :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruitsHarry))
                            )
                        )
                        ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                        (cond 
                            ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTL'horcruxe présent sur cette case est : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                            ((equal affichage "events")(afficher fluxSortie "~% ~% L'horcruxe présent sur cette case est : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                        )
                    )
                )
            )

            ;Traitement de la case active de Voldemort
            ;Ajoute la case active au chemin parcouru
            (if cheminParcouruVoldemort
                (setf (cdr (last cheminParcouruVoldemort)) (list caseVoldemort))
                (setf cheminParcouruVoldemort (list caseVoldemort))
            );cela revient à (push caseVoldemort cheminParcouruVoldemort)

            ;Dans le mode events ou events-arbre, affichage de la case active
            (cond 
                ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTVoldemort est sur la case ~s" profondeur caseVoldemort))
                ((equal affichage "events")(afficher fluxSortie "~% ~% Voldemort est sur la case ~s" caseVoldemort))
            )
            (let (
                (armeCase (assoc caseVoldemort carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc caseVoldemort carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
                )
                (if (and armeCase (and (not (member (cadr armeCase) armesPossedeesVoldemort)) (not (member (cadr armeCase) armesPossedeesHarry))))
                    (progn
                        (push (cadr armeCase) armesPossedeesVoldemort)
                        ;Dans le mode events ou events-arbre, affichage des méthodes de destruction mis à jour
                        (cond 
                            ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTLa méthode présente sur la case de Voldemort est : ~s~% ~vTMéthodes de Destruction récupérées : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr armeCase) profondeur armesPossedeesVoldemort profondeur)) 
                            ((equal affichage "events")(afficher fluxSortie "~% ~% La méthode présente sur la case de Voldemort est : ~s~% Méthodes de Destruction récupérées :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr armeCase) armesPossedeesVoldemort))
                        )
                    )
                )
                (if (and horcruxeCase (and (not (member (cadr horcruxeCase) horcruxesDetruitsVoldemort)) (not (member (cadr horcruxeCase) horcruxesDetruitsHarry))))
                    (if (hasBonneArme (cadr horcruxeCase) armesPossedeesVoldemort descriptionHorcruxes)
                        (progn
                            (push (cadr horcruxeCase) horcruxesDetruitsVoldemort)
                            ;Dans le mode events ou events-arbre, affichage des Horcruxes mis à jour
                            (cond
                                ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTL'Horcruxe présent sur la case de Voldemort est : ~s~% ~vTHorcruxes détruits : {~{~s~^, ~}}~%~% ~vTPassage à la case suivante..." profondeur (cadr horcruxeCase) profondeur horcruxesDetruitsVoldemort profondeur)) 
                                ((equal affichage "events")(afficher fluxSortie "~% ~% L'Horcruxe présent sur la case de Voldemort est : ~s~% Horcruxes détruits :~{~% ~s~^~}~%~% Passage à la case suivante..." (cadr horcruxeCase) horcruxesDetruitsVoldemort))
                            )
                        )
                        ;Si on ne possède pas la méthode de destruction requise, dans le mode events ou events-arbre, on l'indique
                        (cond 
                            ((equal affichage "events-arbre")(afficher fluxSortie "~% ~% ~vTL'Horcruxe présent sur la case de Voldemort est : ~s~% ~vTLa méthode de destruction nécessaire n'est pas possédée !~% ~vTL'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% ~vTPassage à la case suivante..."  profondeur (cadr horcruxeCase) profondeur profondeur profondeur)) 
                            ((equal affichage "events")(afficher fluxSortie "~% ~% L'Horcruxe présent sur la case de Voldemort est : ~s~% La méthode de destruction nécessaire n'est pas possédée !~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !~%~% Passage à la case suivante..." (cadr horcruxeCase)))
                        )
                    )
                )
            )

            ;Dans le mode log ou log-arbre, affichage de la case actuelle, des méthodes de destruction possédées et des Horcruxes détruits
            (cond 
                ((equal affichage "log-arbre")(afficher fluxSortie "~vT- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}} | Voldemort : Case ~a Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" profondeur caseHarry armespossedeesHarry horcruxesdetruitsHarry caseVoldemort armespossedeesVoldemort horcruxesdetruitsVoldemort))
                ((equal affichage "log")(afficher fluxSortie "- ~a : Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}} | Voldemort : Case ~a Méthodes de destruction : {~{'~a'~^, ~}} Horcruxes détruits : {~{'~a'~^, ~}}~%" caseHarry armespossedeesHarry horcruxesdetruitsHarry caseVoldemort armespossedeesVoldemort horcruxesdetruitsVoldemort))
            )

            ;Vérification que la profondeur maximum n'a pas été atteinte et que tous les Horcruxes n'ont pas déjà été trouvés
            (if (and (< profondeur profondeurMax) (< (length horcruxesDetruitsHarry) 6))
                (let ((inputCase NIL)(succ_voldemort NIL))                    
                    ;Si elle ne l'a pas été, recherche et traitement des successeurs valides (non déjà parcouru notamment)
                    (dolist (succ (successeurs-valides caseHarry carte cheminParcouruHarry))
                        (if (not (member succ cheminParcouruHarry)) ;Nouvelle vérification que la case n'a pas déjà été parcourue dans le cas où elle aurait été parcourue lors d'un appel imbriqué ayant eu lieu après la recherche de successeurs valides
                            (progn
                                ;On cherche les cases adjacentes à la case active de Voldemort et on demande à l'utilisateur la case à laquelle Voldemort doit se déplacer
                                (setq succ_voldemort (assoc caseVoldemort carte))
                                (format T "~% Cases suivantes possibles pour Voldemort : ~{~% ~s~^~} ~% Entrer la case choisie: " succ_voldemort)
                                (setq inputCase (read))
                                (let ((tmp (rechercheProfondeurVoldemort+ succ inputCase carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouruHarry cheminParcouruHarry :armesPossedeesHarry armesPossedeesHarry :horcruxesDetruitsHarry horcruxesDetruitsHarry :cheminParcouruVoldemort cheminParcouruVoldemort :armesPossedeesVoldemort armesPossedeesVoldemort :horcruxesDetruitsVoldemort horcruxesDetruitsVoldemort :affichage affichage :profondeurMax profondeurMax :fluxSortie fluxSortie)))
                                    (setf horcruxesDetruitsHarry (car tmp)) ;On remplace la liste plutôt que de la modifier en place pour traiter le cas où HorcruxesDetruits est vide (égale à NIL et donc sans car et cdr)
                                    (setf armesPossedeesHarry (cadr tmp))
                                    (setf horcruxesDetruitsVoldemort (caddr tmp))
                                    (setf armesPossedeesVoldemort (cadddr tmp))
                                    (setf caseVoldemort (cadr (cdddr tmp)))
                                )
                            )
                        )
                    )
                )
                ;Sinon, on ne fait rien
            )

            ;Dans tous les cas, renvoie des horcruxes détruits et des méthodes de destruction possédées, qui ne servent pas pour les appels intermédiaires mais sont attendues pour le premier appel
            (list horcruxesDetruitsHarry armesPossedeesHarry horcruxesDetruitsVoldemort armesPossedeesVoldemort caseVoldemort)
        ))
    )
)

;Tests de la fonction rechercheProfondeurVoldemort+
;(rechercheprofondeurVoldemort+ 1 3 map horcruxesMap armesMap horcruxesDescription)
;(rechercheprofondeurVoldemort+ 1 36 map horcruxesMap armesMap horcruxesDescription :affichage "log-arbre" :profondeurMax 9 :fluxSortie "test333.txt")


(defun rechercheProfondeur++ (case carte carteHorcruxes carteArmes descriptionHorcruxes &key (profondeur 0) (cheminParcouru NIL) (armesPossedees NIL) (horcruxesDetruits NIL) (affichage "log-arbre") (profondeurMax 7) (fluxSortie T) (dumbledore NIL) (caseD 1) (fileD NIL) (cheminParcouruD NIL) (armesPossedeesD NIL) (horcruxesDetruitsD NIL) (modeD "collab"))
;Effectue un parcours en profondeur de profondeur donnée (7 par défaut) au maximum et, de manière optionnelle, un parcours en largeur par Dumbledore s'arrêtant en même temps que le parcours en profondeur et comportant deux modes au choix : collab ou parallele
;Renvoie une liste composée de la liste des Horcruxes détruits par Harry, la liste des méthodes de destruction récupérées par Harry, la liste des Horcruxes détruits par Dumbledore, la liste des méthodes de destruction récupérées par Dumbledore et la file des cases à parcourir par Dumbledore

    ;Vérification du type des arguments passés en paramètre (le paramètre dumbledore n'est pas testé car il accepte toute les valeurs, qui valent toutes T sauf la valeur NIL)
    (cond
        ((not (numberp case))(print "rechercheProfondeur++ : Erreur : La case de Harry (case) doit être un nombre"))
        ((not (listp carte))(print "rechercheProfondeur++ : Erreur : La carte doit être une liste"))
        ((not (listp carteHorcruxes))(print "rechercheProfondeur++ : Erreur : La carte des Horcruxes doit être une liste"))
        ((not (listp carteArmes))(print "rechercheProfondeur++ : Erreur : La carte des méthodes de destruction (carteArme) doit être une liste"))
        ((not (listp descriptionHorcruxes))(print "rechercheProfondeur++ : Erreur : La description des Horcruxes doit être sous forme de liste"))
        ((not (numberp profondeur))(print "rechercheProfondeur++ : Erreur : La profondeur doit être un nombre"))
        ((not (listp cheminParcouru))(print "rechercheProfondeur++ : Erreur : Le chemin parcouru par Harry doit être sous forme de liste"))
        ((not (listp horcruxesDetruits))(print "rechercheProfondeur++ : Erreur : Les Horcruxes détruits par Harry doivent être sous forme d'une liste"))
        ((not (listp armesPossedees))(print "rechercheProfondeur++ : Erreur : Les méthodes de destruction (armes) possédées par Harry doivent être sous forme d'une liste"))
        ((not (member affichage '("log" "log-arbre" "events" "events-arbre") :test #'string=))(print "rechercheProfondeur++ : Erreur : Le mode d'affichage doit être une chaîne de caractère valant log, log-arbre, events ou events-arbre"))
        ((not (numberp profondeurMax))(print "rechercheProfondeur++ : Erreur : La profondeur maximale doit être un nombre"))
        ((not (or (equal T fluxSortie) (stringp fluxSortie)))(print "rechercheProfondeur++ : Erreur : Le flux de sortie doit être le flux standard (T) ou un chemin de fichier représenté par une chaîne de caractère"))
        ((not (numberp caseD))(print "rechercheProfondeur++ : Erreur : La case de Dumbledore (caseD) doit être un nombre"))
        ((not (listp fileD))(print "rechercheProfondeur++ : Erreur : La file des cases à parcourir par Dumbledore doit être sous forme de liste"))
        ((not (listp cheminParcouruD))(print "rechercheProfondeur++ : Erreur : Le chemin parcouru par Dumbledore doit être sous forme de liste"))
        ((not (listp horcruxesDetruitsD))(print "rechercheProfondeur++ : Erreur : Les Horcruxes détruits par Dumbledore doivent être sous forme d'une liste"))
        ((not (listp armesPossedeesD))(print "rechercheProfondeur++ : Erreur : Les méthodes de destruction (armes) possédées par Dumbledore doivent être sous forme d'une liste"))
        ((not (member modeD '("collab" "parallele") :test #'string=))(print "rechercheProfondeur++ : Erreur : Le mode d'ajout de Dumbledore doit être une chaîne de caractère valant collab ou parallele"))
        (T (progn
    
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
                (armeCase (assoc case carteArmes)) ;Prend la valeur de la méthode de destruction présente sur la cases s'il y en a une, sinon NIL
                (horcruxeCase (assoc case carteHorcruxes)) ;Prend la valeur de l'Horcruxe présent sur la cases s'il y en a un, sinon NIL
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
                                (setf fileD (list succ))
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

            ;Vérification que la profondeur maximum n'a pas été atteinte et que tous les Horcruxes n'ont pas déjà été trouvés
            (if (and (< profondeur profondeurMax) (< (+ (length horcruxesDetruits) (length horcruxesDetruitsD)) 6))
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
                            (let ((tmp (rechercheProfondeur++ succ carte carteHorcruxes carteArmes descriptionHorcruxes :profondeur (+ profondeur 1) :cheminParcouru cheminParcouru :armesPossedees armesPossedees :horcruxesDetruits horcruxesDetruits :affichage affichage :profondeurMax profondeurMax :fluxSortie fluxSortie :dumbledore NIL :horcruxesDetruitsD horcruxesDetruitsD :armesPossedeesD armesPossedeesD :modeD modeD)))
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
        ))
    )
)

;Tests de rechercheProfondeur++
;(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 7 :dumbledore T :caseD 1)
;(rechercheprofondeur++ 1 map horcruxesMap armesMap horcruxesDescription :profondeurMax 7 :dumbledore T :caseD 1 :modeD "parallele")