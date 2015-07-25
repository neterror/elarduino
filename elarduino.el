(provide 'elarduino)

(if (not (memq "." load-path))
    (setf load-path (append load-path (list "."))))

(require 'lr-util)
(require 'lr-config)

(defun avr(prog)
  (concat *avr-bin-path* "/" prog))

(defun includes()
  (let ((paths (list "cores/arduino" "variants/leonardo" "libraries/SPI")))
    (mapcar (lambda(x) (concat "-I" *headers-base-path* x " ")) paths)))


(defun compile-options(file)
  (concat-with (" " avr "avr-g++")
          (apply #'concat-with " " (append *board-options* *compiler-options* (includes)))
          file))

(compile-options "WebRelay.cpp")

(defun avr-g++(file)
    (compile (compile-options file)))

(avr-g++ "WebRelay.cpp")

