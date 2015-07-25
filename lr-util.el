(defun append-separator(separator strings)
   (mapcar #'(lambda(x) (concat x separator)) strings))

(defun remove-last-char(string)
  (let ((len (length string)))
    (if (> len 1)
        (substring string 0 (1- len)))))


(defun concat-with(separator strings)
  (remove-last-char (apply #'concat (append-separator separator strings))))

   
(provide  'lr-util)


