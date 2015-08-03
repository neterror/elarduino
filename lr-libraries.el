; -*- lexical-binding: t -*-

(require 'lr-util)
(require 'lr-config)

(defun lr-libraries(base-path)
  (let ((path (concat base-path "libraries/")))
    (lr-sub-directories path)))

(defun lr-arduino-libraries()
  (append
   (lr-libraries (concat (lr-arduino-base) "hardware/arduino/avr/"))
   (lr-libraries (lr-arduino-base))))

(defun lr-get-files(path pattern fullp)
  (let ((dirs (lr-directory-tree path)))
    (lr-flat (remove-if #'null (mapcar #'(lambda(x)(directory-files x fullp pattern)) dirs)))))

(defun lr-library-files(library-dir)
  "Returns the list of sources in given library. Headers are without path for easy lookup. cpp files are with full path. For the compiler"
  (append (lr-get-files library-dir "\\.h$" nil) (lr-get-files library-dir "\\.cpp$\\|\\.c$" t)))

(defun lr-library-sources(library-paths)
  "Returns hashmap, with key full path to library, value is list of headers (without path) and sources(with full path)"
  (mapcar #'(lambda(x)
	      (cons x (lr-library-files x))) library-paths))

(defun lr-find-header-internal(libraries header)
  (if libraries
      (if (member header (car libraries) )
	  (car libraries)
	(lr-find-header-internal (cdr libraries) header))))

(defun lr-header-finder()
  (let ((library-sources (lr-library-sources (lr-arduino-libraries))))
    (lambda(header)
      (lr-find-header-internal library-sources header))))

;;example usage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq fn-find-header (lr-header-finder))
(funcall fn-find-header "EEPROM.h")


(provide 'lr-libraries)
