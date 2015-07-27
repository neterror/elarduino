(require 'lr-util)
(require 'lr-config)

(setq lexical-binding t)

(defun lr-libraries(base-path)
  (let ((path (concat base-path "libraries/")))
      (lr-sub-directories path)))

(defun lr-arduino-libraries()
  (append
   (lr-libraries (concat lr-arduino-base "hardware/arduino/avr/"))
      (lr-libraries lr-arduino-base)))

(defun lr-get-files(path pattern fullp)
    (let ((dirs (lr-directory-tree path)))
        (lr-flat (remove-if #'null (mapcar #'(lambda(x)(directory-files x fullp pattern)) dirs)))))

(defun lr-library-files(library-dir)
    "Returns the list of sources in given library. Headers are without path for easy lookup. cpp files are with full path 
for the compiler"
    (append (lr-get-files library-dir "\\.h$" nil) (lr-get-files library-dir "\\.cpp$\\|\\.c$" t)))
    
(defun lr-library-sources(library-paths)
    "Returns hashmap, with key full path to library, value is list of headers (without path) and sources(with full path)"
    (let ((library-sources (make-hash-table :test #'equal)))
        (mapc #'(lambda(x)
                    (puthash x (lr-library-files x) library-sources)) library-paths)
        library-sources))
                          


(defun lr-library-find()
    (let* ((libraries (lr-arduino-libraries))
              (sources (lr-library-sources libraries)))
        (lambda(library)
            (gethash library sources))))

(setq finder (lr-library-find))


(funcall finder "/Applications/Arduino.app/Contents/Resources/Java/hardware/arduino/avr/libraries/EEPROM")

    
(setq *sources* (lr-library-sources))

(maphash #'(lambda(key value) (print key) (print value)) *sources*)
