(defun Recherche-Harry (case carte profondeur HorcruxesDescriptions cheminParcouru
                         HorcruxesMap HorcruxesDetruites ArmesMap ArmesPossedees)
  
  (format t "~% ~% Harry est à la case ~s" case)
  
  (push case cheminParcouru)
  (setq armePresente (methodePresente case ArmesMap))
  (if armePresente 
      (progn
        (format t "~% ~% Arme présente : ~s" armePresente)
        (push armePresente ArmesPossedees)
        (setq ArmesMap (supprimeArmeCarte case ArmesMap))
        (format t "~% Méthodes de Destruction récupérées :")
        (dolist (arme ArmesPossedees)
          (format t "~% ~s" arme))
        (format t "~%~% Passage à la case suivante...")
        )
    )
  (setq HorcruxePresente (horcruxePresente case HorcruxesMap))
  (if HorcruxePresente 
      (progn
        (format t "~%~% Horcruxes présente : ~s" HorcruxePresente)
        (if (hasBonneArme HorcruxePresente HorcruxesDescriptions ArmesPossedees)
            (progn
              (push HorcruxePresente HorcruxesDetruites) 
              (format t "~% Horcruxes détruites :")
              (dolist (horcruxe HorcruxesDetruites)
                (format t "~% ~s" horcruxe))
              (setq HorcruxesMap (supprimeHorcruxeCarte case HorcruxesMap))
              (format t "~%~% Passage à la case suivante...")
              )
          (progn
            (format t "~% La méthode de destruction nécessaire n'est pas possédée !")
            (format t "~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !")
            (setq HorcruxesMap (supprimeHorcruxeCarte case HorcruxesMap))
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
          (setq data_parcours (Recherche-Harry voisin carte (+ profondeur 1) HorcruxesDescriptions cheminParcouru
                                                       HorcruxesMap HorcruxesDetruites ArmesMap ArmesPossedees))
          (setq HorcruxesDetruites (car data_parcours))
          (setq HorcruxesMap (cadr data_parcours))
          (setq ArmesMap (caddr data_parcours))
          (setq ArmesPossedees (cadddr data_parcours))
          (setq cheminParcouru (cadr(cdddr data_parcours))))))
  (list HorcruxesDetruites HorcruxesMap ArmesMap ArmesPossedees cheminParcouru))





(defun supprimeHorcruxeCarte (horcruxe carte)
  "Supprime l'Horcruxe de la carte."
  (setq nouvelle-carte (copy-list carte)) ; Crée une copie de la carte pour éviter de modifier l'original

  ; Recherche et suppression de l'Horcruxe de la carte
  (setq index (position horcruxe nouvelle-carte :test #'string=))
  (when index
    (setq nouvelle-carte (remove (elt nouvelle-carte index) nouvelle-carte :test #'string=)))

  nouvelle-carte) ; Retourne la nouvelle carte après la suppression



  




(defun Recherche-Harry (caseHarry caseVoldemort carte profondeur HorcruxesDescriptions cheminParcouruHarry
                                  cheminParcouruVoldemort HorcruxesMap HorcruxesDetruitesHarry 
                                  HorcruxesDetruitesVoldemort ArmesMap ArmesPossedeesHarry
                                  ArmesPossedeesVoldemort)
  
  (when (and (equal caseHarry caseVoldemort)
               (member "Sortilège de la Mort" ArmesPossedeesVoldemort :test #'string=))
    (return-from Recherche-Harry (list "Harry Potter a été tué par Voldemort"))
    )
  
  (format t "~% ~% Harry est à la case ~s" caseHarry)
  (push caseHarry cheminParcouruHarry)
  (setq armePresente (methodePresente caseHarry ArmesMap))
  (if armePresente 
      (progn
        (format t "~% ~% Arme présente : ~s" armePresente)
        (push armePresente ArmesPossedeesHarry)
        (setq ArmesMap (supprimeArmeCarte caseHarry ArmesMap))
        (format t "~% Méthodes de Destruction récupérées :")
        (dolist (arme ArmesPossedeesHarry)
          (format t "~% ~s" arme))
        (format t "~%~% Passage à la case suivante...")
        )
    )
  
  (format t "~% ~% Voldemort est à la case ~s" caseVoldemort)
  (push caseVoldemort cheminParcouruVoldemort)
  (setq armePresente (methodePresente caseVoldemort ArmesMap))
  (if armePresente 
      (progn
        (format t "~% ~% Arme présente : ~s" armePresente)
        (push armePresente ArmesPossedeesVoldemort)
        (setq ArmesMap (supprimeArmeCarte caseVoldemort ArmesMap))
        (format t "~% Méthodes de Destruction récupérées :")
        (dolist (arme ArmesPossedeesVoldemort)
          (format t "~% ~s" arme))
        (format t "~%~% Passage à la case suivante...")
        )
    )
  
  (setq HorcruxePresente (horcruxePresente caseHarry HorcruxesMap))
  (if HorcruxePresente 
      (progn
        (format t "~%~% Horcruxes présente : ~s" HorcruxePresente)
        (if (hasBonneArme HorcruxePresente HorcruxesDescriptions ArmesPossedeesHarry)
            (progn
              (push HorcruxePresente HorcruxesDetruitesHarry) 
              (format t "~% Horcruxes détruites :")
              (dolist (horcruxe HorcruxesDetruitesHarry)
                (format t "~% ~s" horcruxe))
              (setq HorcruxesMap (supprimeHorcruxeCarte caseHarry HorcruxesMap))
              (format t "~%~% Passage à la case suivante...")
              )
          (progn
            (format t "~% La méthode de destruction nécessaire n'est pas possédée !")
            (format t "~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !")
            (setq HorcruxesMap (supprimeHorcruxeCarte caseHarry HorcruxesMap))
            (format t "~%~% Passage à la case suivante...")
            )
          )
        )
    )
  
  (setq HorcruxePresente (horcruxePresente caseVoldemort HorcruxesMap))
  (if HorcruxePresente 
      (progn
        (format t "~%~% Horcruxes présente : ~s" HorcruxePresente)
        (if (hasBonneArme HorcruxePresente HorcruxesDescriptions ArmesPossedeesVoldemort)
            (progn
              (push HorcruxePresente HorcruxesDetruitesVoldemort) 
              (format t "~% Horcruxes détruites :")
              (dolist (horcruxe HorcruxesDetruitesVoldemort)
                (format t "~% ~s" horcruxe))
              (setq HorcruxesMap (supprimeHorcruxeCarte caseVoldemort HorcruxesMap))
              (format t "~%~% Passage à la case suivante...")
              )
          (progn
            (format t "~% La méthode de destruction nécessaire n'est pas possédée !")
            (format t "~% L'Horcruxe n'a pas été détruite et ne pourra plus l'être !")
            (setq HorcruxesMap (supprimeHorcruxeCarte caseVoldemort HorcruxesMap))
            (format t "~%~% Passage à la case suivante...")
            )
          )
        )
    )
  
  (if (< profondeur 7)
      (progn
        (setq cases_suivantes_harry (successeurs-valides caseHarry carte cheminParcouruHarry))
        (setq cases_suivantes_voldemort (assoc caseVoldemort carte))
        (dolist (voisin cases_suivantes_harry)
          (reverse (cons voisin (reverse cheminParcouruHarry))))
        
        (format t "~% Cases suivantes possibles pour Voldemort :")
        (dolist (voisin cases_suivantes_voldemort)
          (format t "~% ~s" voisin))
        (format t " ~% Entrer la case choisie: ")
        (setq inputCase (read))
        
        
        (dolist (voisin cases_suivantes_harry)
          (setq data_parcours (Recherche-Harry voisin inputCase carte (+ profondeur 1) HorcruxesDescriptions cheminParcouruHarry
                                                       cheminParcouruVoldemort HorcruxesMap HorcruxesDetruitesHarry 
                                               HorcruxesDetruitesVoldemort ArmesMap ArmesPossedeesHarry
                                               ArmesPossedeesVoldemort))
          (setq HorcruxesDetruitesHarry (car data_parcours))
          (setq HorcruxesDetruitesVoldemort (cadr data_parcours))
          (setq HorcruxesMap (caddr data_parcours))
          (setq ArmesMap (cadddr data_parcours))
          (setq ArmesPossedeesHarry (cadr (cdddr data_parcours)))
          (setq ArmesPossedeesVoldemort (caddr (cdddr data_parcours)))
          (setq cheminParcouruHarry (cadddr (cdddr data_parcours)))
          (setq cheminParcouruVoldemort (cadr (cdddr (cdddr data_parcours)))))))
  (list HorcruxesDetruitesHarry HorcruxesDetruitesVoldemort HorcruxesMap ArmesMap ArmesPossedeesHarry ArmesPossedeesVoldemort cheminParcouruHarry cheminParcouruVoldemort))

  
        

(Recherche-Harry '1 '20 map '0 horcruxesDescription nil nil horcruxesMap nil nil armesMap nil nil)