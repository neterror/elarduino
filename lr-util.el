(setq lisp-indent-offset 4)
(modify-syntax-entry ?- "w" emacs-lisp-mode-syntax-table)

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

(defun directory-tree (root)
    (let (result)
        (defun directories-in (dir)
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

(defun source-files(dir)
    (let ((dirs (cons dir (directory-tree dir))))
        (remove-if #'null (mapcar #'(lambda(x)(directory-files x t "\\.cpp$\\|\\.c$\\|\\.h$")) dirs))))

(source-files "/Users/plamen/amazon/")


(provide 'lr-util)
