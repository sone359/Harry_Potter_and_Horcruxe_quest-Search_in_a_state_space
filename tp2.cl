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
    (let ((successeurs NIL))
        (dolist (x (cdr (assoc case carte)) (nreverse successeurs))
            (if (not (member x cheminParcouru))
                (push x successeurs)
            )
        )
    )
)

( defun methodeDestruction (horcruxe horcruxesDescription)
     
    (cadr (cadr (assoc horcruxe horcruxesDescription :test #'string=)))

)

(defun hasBonneArme (horcruxe methodesPossedes horcruxesDescription)
    (if (member (methodeDestruction horcruxe horcruxesdescription) methodespossedes :test #'string=)
        T ;On aurait directement pu renvoyer le résultat du test à la place de faire un if mais, dans le cas où l'on possède la méthode adpatée, on aurait alors renvoyé la fin de la liste et non simplement T. A noter que ces deux valeurs auraient toutefois été équivalentes dans le cas d'un test booléen
        NIL
    )
)

;Tests des fonctions
;(successeurs-valides 25 map '(1 12 13 24))

;Recherche en profondeur pour la recherche de Harry Potter

; Nous avons choisi d'expoiter la propiété mutable des listes en Lisp pour mettre directement à jour les informations nécessaires d'un appel récurisif à l'autre, sans passer par une valeur envoyée.
; Cette méthode présente plusieurs avantages :
;     Etant donné que chaque liste n'est créée qu'une seule fois et qu'il n'y a pas besoin de faire de copie à partir de la valeur de retour d'un appel, le nombre d'opérations effectuées et surtout la place prise en mémoire sont réduits
;     Le nombre de valeur de retour final est réduit au strict minimum, tout en permettant à l'utilisateur de pouvoir récupérer les valeurs des autres listes impliquées (en passant une liste définie et stocké précédemment dans une variable en paramètre par exemple)
; Nous lui reconnaissons toutefois un inconvénient, celui de modifier la valeur de liste passée en paramètre et donc d'imposer de lui passer une copie s'il ne souhaite pas de ce comportement

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

(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur 24 map horcruxesMap armesMap horcruxesDescription)
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :horcruxesDetruits NIL :profondeur 2)
(rechercheprofondeur 1 map horcruxesMap armesMap horcruxesDescription :affichage "events")


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