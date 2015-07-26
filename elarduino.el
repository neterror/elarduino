(provide 'elarduino)

(if (not (memq "." load-path))
    (setf load-path (append load-path (list "."))))

(require 'lr-util)
(require 'lr-config)


(defun compile-options(file)
  (concat-with (" " avr "avr-g++")
          (apply #'concat-with " " (append *board-options* *compiler-options* (includes)))
          file))

(compile-options "WebRelay.cpp")

(defun avr-g++(file)
    (compile (compile-options file)))

(avr-g++ "WebRelay.cpp")

