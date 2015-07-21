(defun append-spaces (args)
  (mapcar '(lambda(x) (concat x " ")) args))

(defun concat-with-spaces(&rest args)
  (apply #'concat (append-spaces args)))

(provide  'lr-util)
