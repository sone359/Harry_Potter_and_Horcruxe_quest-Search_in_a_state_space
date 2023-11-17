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

(defun rechercheProfondeur (case profondeur carte carteHorcruxes carteArmes descriptionHorcruxes cheminParcouru armesPossedees horcruxesDetruits)
    ;Traitement de la case active
    (let (
        (armeCase (assoc case carteArmes))
        (horcruxeCase (assoc case carteHorcruxes))
        )
        (if armeCase 
            (if armesPossedees
                (setf (cdr (last armesPossedees)) (list (cadr armeCase)))
                (setf armesPossedees (list (cadr armeCase)))
            )
        )
        (if (and horcruxeCase (hasBonneArme (cadr horcruxeCase) armesPossedees descriptionHorcruxes)) 
            (if horcruxesDetruits
                (setf (cdr (last horcruxesDetruits)) (list (cadr horcruxeCase)))
                (setf horcruxesDetruits (list (cadr horcruxeCase)))
            )
        )
    )
    ; (setq armeCase (assoc case carteArmes))
    ; (setq horcruxeCase (assoc case carteHorcruxes))
    ; (if armeCase 
    ;     (if armesPossedees
    ;         (setf (cdr (last armesPossedees)) (list (cadr armeCase)))
    ;         (setf armesPossedees (list (cadr armeCase)))
    ;         ;(setf armesPossedees (list "coucou"))
    ;     )
    ; )
    ; (if (and horcruxeCase (hasBonneArme (cadr horcruxeCase) armesPossedees descriptionHorcruxes)) 
    ;         (if horcruxesDetruits
    ;             (setf (cdr (last horcruxesDetruits)) (list (cadr horcruxeCase)))
    ;             (setq horcruxesDetruits (list (cadr horcruxeCase)))
    ;         )
    ;     )
    

    (if cheminParcouru
        (setf (cdr (last cheminParcouru)) (list case))
        (setf cheminParcouru (list case))
    )

    ;Affichage de la case actuelle, des méthodes de destruction possédées et des Horcruxes détruits
    (format t "~vT- ~a ~a ~a ~a~%" profondeur case cheminParcouru armespossedees horcruxesdetruits)

    ;Vérification que la profondeur maximum n'a pas été atteinte
    (if (< profondeur 7)
        ;Si elle ne l'a pas été, recherche et traitement des successeurs valides (non déjà parcouru notamment)
        (dolist (succ (successeurs-valides case carte cheminParcouru))
            (if (not (member succ cheminParcouru)) ;Nouvelle vérification que la case n'a pas déjà été parcourue dans le cas où elle aurait été parcourue lors d'un appel imbriqué ayant eu lieu après la recherche de successeurs valides
                (rechercheProfondeur succ (+ profondeur 1) carte carteHorcruxes carteArmes descriptionHorcruxes cheminParcouru armesPossedees horcruxesDetruits)
                ;(push horcruxesDetruits (car (rechercheProfondeur succ (+ profondeur 1) carte carteHorcruxes carteArmes descriptionHorcruxes cheminParcouru armesPossedees horcruxesDetruits)))
            )
        )
        ;Sinon, on ne fait rien
    )
    ;Dans tous les cas, renvoie des horcruxes détruits et des méthodes de destruction possédées, qui ne servent pas pour les appels intermédiaires mais sont attendues pour le premier appel
    (list horcruxesDetruits armesPossedees)
)

;Tests de la recherche
(rechercheprofondeur 1 0 map horcruxesMap armesMap horcruxesDescription NIL NIL NIL)
(rechercheprofondeur 1 0 map horcruxesMap armesMap horcruxesDescription NIL '("salut") '("salue"))
