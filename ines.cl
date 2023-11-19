(defun rechercheProfondeur-Harry (case carte profondeur descriptionHorcruxes cheminParcouru carteHorcruxes HorcruxesDetruites ArmesMap ArmesPossedees)
  
  (format t "~% ~% Harry est à la case ~s" case)
  
  (push case cheminParcouru)
  (setq armeCase (methodePresente case ArmesMap))
  (if armeCase 
      (progn
        (format t "~% ~% Arme présente : ~s" armeCase)
        (push armeCase ArmesPossedees)
        (setq ArmesMap (supprimeArmeCarte case ArmesMap))
        (format t "~% Méthodes de Destruction récupérées :")
        (dolist (arme ArmesPossedees)
          (format t "~% ~s" arme))
        (format t "~%~% Passage à la case suivante...")
        )
    )
  (setq horcruxeCase  (horcruxeCase  case carteHorcruxes))
  (if horcruxeCase  
      (progn
        (format t "~%~% Horcruxes présente : ~s" horcruxeCase  )
        (if (hasBonneArme horcruxeCase  descriptionHorcruxes ArmesPossedees)
            (progn
              (push horcruxeCase  HorcruxesDetruites) 
              (format t "~% Horcruxes détruites :")
              (dolist (horcruxe HorcruxesDetruites)
                (format t "~% ~s" horcruxe))
              (setq carteHorcruxes (supprimeHorcruxeCarte case carteHorcruxes))
              (format t "~%~% Passage à la case suivante...")
              )
          (progn
            (format t "~% La méthode de destruction nécessaire n'est pas possédée !")
            (format t "~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !")
            (setq carteHorcruxes (supprimeHorcruxeCarte case carteHorcruxes))
            (format t "~%~% Passage à la case suivante...")
            )
          )
        )
    )
  (if (< profondeur 7)
      (progn
        (setq cases_suivantes (successeurs-valides case carte cheminParcouru))
        (dolist (voisin cases_suivantes)
          (reverse (cons voisin (reverse cheminParcouru))))
        
        (dolist (voisin cases_suivantes)
          (setq data_parcours (rechercheProfondeur-Harry voisin carte (+ profondeur 1) descriptionHorcruxes cheminParcouru
                                                       carteHorcruxes HorcruxesDetruites ArmesMap ArmesPossedees))
          (setq HorcruxesDetruites (car data_parcours))
          (setq carteHorcruxes (cadr data_parcours))
          (setq ArmesMap (caddr data_parcours))
          (setq ArmesPossedees (cadddr data_parcours))
          (setq cheminParcouru (cadr(cdddr data_parcours))))))
  (list HorcruxesDetruites carteHorcruxes ArmesMap ArmesPossedees cheminParcouru))





(defun supprimeHorcruxeCarte (horcruxe carte)
  "Supprime l'Horcruxe de la carte."
  (setq nouvelle-carte (copy-list carte)) ; Crée une copie de la carte pour éviter de modifier l'original

  ; Recherche et suppression de l'Horcruxe de la carte
  (setq index (position horcruxe nouvelle-carte :test #'string=))
  (when index
    (setq nouvelle-carte (remove (elt nouvelle-carte index) nouvelle-carte :test #'string=)))

  nouvelle-carte) ; Retourne la nouvelle carte après la suppression



  














(defun rechercheProfondeur-Harry-VDM (pos_Harry pos_VDM carte profondeur
 descriptionHorcruxes cheminParcouruHarry cheminParcouruVoldemort 
 CarteHorcruxes HorcruxesDetruitesHarry HorcruxesDetruitesVoldemort 
 ArmesMap ArmesPossedeesHarry  ArmesPossedeesVoldemort)
  
  ;ici on teste si Harry et VDM sont sur la même case et si VDM possède la méthode nécessaire pour tuer Harry (qui est un horcruxe)
  
  (when (and (equal pos_Harry  pos_VDM) (member "Sortilège de la Mort" ArmesPossedeesVoldemort :test #'string=))  
  ;Dans ce cas, #'string= indique que la comparaison doit être faite en utilisant l'égalité de chaînes de caractères.
      (return-from rechercheProfondeur-Harry-VDM (list "Harry Potter a été tué par Voldemort"))
  ) 
    ;ici on sort directement de la fonction grâce à return-from car le jeu est perdu, harry est mort
  
 
 
 
  (format t "~% Harry est à la case ~s" pos_Harry )
  
  (if cheminParcouruHarry
    (setf (cdr(last cheminParcouruHarry) (list pos_Harry))
    (setf cheminParcouruHarry (list pos_Harry))
  ) ;on rajoute la position actuelle de Harry à son chemin parcouru


  (let (
    (armeCase (assoc pos_Harry armesMap)) ; armecase prends la valeur de la méthode sur la case de Harry s'il y en a un
    (horcruxeCase (assoc pos_Harry carteHorcruxes)) ; horcruxeCase prends la valeur de l'horcruxe sur la case de harry s'il y en a un
      )
  )

  
  (if armeCase
      (progn
        (push (cadr armeCase) ArmesPossedeesHarry) ; on l'ajoute donc aux méthodes de Harry
        (format t "~%  Sur cette case se trouve la Méthode : ~s" armeCase)
        
      
        (setq ArmesMap (supprimeArmeCarte pos_Harry ArmesMap)) ; on supprime la methode de la carte

        (format t "~% Méthodes de Destruction récupérées :")
          (dolist (arme ArmesPossedeesHarry)
            (format t "~% ~s" arme))

        (format t "~% Passage à la case suivante...")
      )
  )

  (if horcruxeCase  
      (progn
        (format t "~%~% L'horcruxe présent sur cette case est: ~s" horcruxeCase  )
       
        (if (hasBonneArme (cadr horcruxeCase )  ArmesPossedeesHarry descriptionHorcruxes)
            (progn
              (push (cadr horcruxeCase  ) HorcruxesDetruitesHarry) 
              
              (format t "~% Horcruxes détruits :")
              (dolist (horcruxe HorcruxesDetruitesHarry)
                (format t "~% ~s" horcruxe))

              (setq carteHorcruxes (supprimeHorcruxeCarte pos_Harry  carteHorcruxes))
              (format t "~%~% Passage à la case suivante...")
            )

          (progn
            (format t "~% La méthode de destruction nécessaire n'est pas possédée !")
            (format t "~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !")
            
            (setq carteHorcruxes (supprimeHorcruxeCarte pos_Harry  carteHorcruxes))
            (format t "~%~% Passage à la case suivante.")
          )
        )
      )
  )
  
  
  (format t "~% ~% Voldemort est sur la case ~s" pos_VDM)
  
  (if cheminParcouruVoldemort
    (setf (cdr(last cheminParcouruVoldemort)) (list pos_VDM))
    (setf cheminParcouruVoldemort (list pos_VDM))
  ) ;cela revient à (push pos_VDM cheminParcouruVoldemort)


  (let (
    (armeCase (assoc pos_VDM armesMap)) ;armecase prends la valeur de la méthode sur la case de VDM s'il y en a une
    (horcruxeCase  (assoc pos_VDM carteHorcruxes)) ; horcruxeCase  prends la valeur de l'horcruxe sur la case de VDM s'il y en a un
       )
  )

  (if armeCase
      (progn
        (format t "~% La méthode présente sur la case de VDM est : ~s" armeCase)
        (push (cadr armeCase) ArmesPossedeesVoldemort)
        
        (setq ArmesMap (supprimeArmeCarte pos_VDM ArmesMap))
        (format t "~% Méthodes de Destruction récupérées :")
        (dolist (arme ArmesPossedeesVoldemort)
          (format t "~% ~s" arme))
        (format t "~%~% Passage à la case suivante")
        )
  )
 

  (if horcruxeCase  
      (progn
        (format t "~% L'Horcruxe présent sur la case de Voldemort est : ~s" horcruxeCase  )

        (if (hasBonneArme (cadr horcruxeCase ) ArmesPossedeesVoldemort descriptionHorcruxes)
            (progn
              (push ( cadr horcruxeCase)  HorcruxesDetruitesVoldemort) 
              (format t "~% Horcruxes détruites :")
              (dolist (horcruxe HorcruxesDetruitesVoldemort)
                (format t "~% ~s" horcruxe))

              (setq carteHorcruxes (supprimeHorcruxeCarte pos_VDM carteHorcruxes))
              (format t "~%~% Passage à la case suivante...")
              )

            (progn
              (format t "~% La méthode de destruction nécessaire n'est pas possédée !")
              (format t "~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !")
              (setq carteHorcruxes (supprimeHorcruxeCarte pos_VDM carteHorcruxes))
              (format t "~%~% Passage à la case suivante...")

            )
        )
      )
  )
  

(if (< profondeur 7) ; on verifie que la profondeur max n'est pas atteinte
      (progn
        (setq succ_harry (successeurs-valides pos_Harry  carte cheminParcouruHarry ))
        (setq succ_voldemort (assoc pos_VDM carte))
        (dolist (voisin succ_harry)
          (reverse (cons voisin (reverse cheminParcouruHarry))))
        
        (format t "~% Cases suivantes possibles pour Voldemort :")
          (dolist (voisin succ_voldemort)
           (format t "~% ~s" voisin))
        (format t " ~% Entrer la case choisie: ")
        (setq inputCase (read))
        
        
        (dolist (voisin succ_harry)
          (setq data_parcours (rechercheProfondeur-Harry-VDM voisin inputCase carte (+ profondeur 1) descriptionHorcruxes cheminParcouruHarry
           cheminParcouruVoldemort carteHorcruxes HorcruxesDetruitesHarry HorcruxesDetruitesVoldemort ArmesMap ArmesPossedeesHarry ArmesPossedeesVoldemort))

          (setq HorcruxesDetruitesHarry (car data_parcours))
          (setq HorcruxesDetruitesVoldemort (cadr data_parcours))
          (setq carteHorcruxes (caddr data_parcours))
          (setq ArmesMap (cadddr data_parcours))
          (setq ArmesPossedeesHarry (cadr (cdddr data_parcours)))
          (setq ArmesPossedeesVoldemort (caddr (cdddr data_parcours)))
          (setq cheminParcouruHarry (cadddr (cdddr data_parcours)))
          (setq cheminParcouruVoldemort (cadr (cdddr (cdddr data_parcours)))))))
  
  (list HorcruxesDetruitesHarry HorcruxesDetruitesVoldemort carteHorcruxes ArmesMap ArmesPossedeesHarry ArmesPossedeesVoldemort cheminParcouruHarry cheminParcouruVoldemort))
  )

  
        

(rechercheProfondeur-Harry-VDM '1 '20 map '0 horcruxesDescription nil nil carteHorcruxes nil nil armesMap nil nil)