(defun lr-load-file (f)
    "Loads file contents and returns it as string"
    (with-temp-buffer
        (insert-file-contents f)
        (buffer-substring-no-properties
            (point-min)
            (point-max))))

(defun lr-split-lines(string)
    "Load file contents and returns it as list of lines"
    (split-string string "[\r\n]" t))


(defun lr-directory-p(attributes)
    "Omit the entry if the 0th file-attribute which is file-name begins with . 9th attribute is in file persmission
in the form drwx___rwx"
    (eq (elt (nth 9 attributes) 0) ?d))

(defun lr-directory-tree (root)
    (let (result)
        (defun lr-directories-in (dir)
            (let ((paths (lr-sub-directories (car dir))))
                (setq result (append result paths))
                (while (car paths)
                    (directories-in paths)
                    (setq paths (cdr paths)))))
        (directories-in (list root))
        (append (list root) result)))


(defun lr-sub-directories(base-path)
    (if base-path
        (mapcar #'car (remove-if-not #'lr-directory-p (directory-files-and-attributes base-path t "^[^.]")))))

(defun lr-flat(list)
    (if list
        (if (consp (car list))
            (append (flat (car list)) (flat (cdr list)))
            (cons (car list) (flat (cdr list))))))

(provide 'lr-util)

