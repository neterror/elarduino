(defun append-separator(separator strings)
   (mapcar #'(lambda(x) (concat x separator)) strings))

(defun remove-last-char(string)
  (let ((len (length string)))
    (if (> len 1)
        (substring string 0 (1- len)))))

(defun concat-with(separator strings)
  "Separator is string, strings is list of strings"
  (remove-last-char (apply #'concat (append-separator separator strings))))


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
  (and (eq (elt (nth 9 attributes) 0) ?d)
       (not (eq (elt (nth 0 attributes) 0) ?.))))


(defun lr-sub-directories(base-path)
  (mapcar #'car (remove-if-not #'lr-directory-p (directory-files-and-attributes base-path))))
  
(provide 'lr-util)


(defun dir-tree(root)
  (let ((sym (
      

;;rt314o12wg
