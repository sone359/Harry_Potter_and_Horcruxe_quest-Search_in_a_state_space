(defun successeurs-valides (case carte cheminParcouru)
    (let ((successeurs NIL))
        (dolist x (cdr (assoc case carte)) successeurs
            (if (not (member x cheminParcouru))
                (append x successeurs)
            )
        )
    )
)