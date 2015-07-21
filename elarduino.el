(provide 'elarduino)

(if (not (memq "." load-path))
    (setf load-path (append load-path (list "."))))
(require 'arduino-utils)

(defvar *arduino-path* "/Applications/Arduino.app/")
(defvar *avr-bin-path* (concat *arduino-path* "/Contents/Resources/Java/hardware/tools/avr/bin"))
(defvar *headers-base-path* (concat *arduino-path* "/Contents/Resources/Java/hardware/arduino/avr/"))

(defun avr(prog)
  (concat *avr-bin-path* "/" prog))

(defvar *board-options* (list "-mmcu=atmega32u4" "-DF_CPU=16000000L" "-DARDUINO=10601" "-DARDUINO_AVR_LEONARDO" "-DARDUINO_ARCH_AVR" " "))
(defvar *compiler-options* (list "-c" "-g" "-Os" "-w" "-fno-exceptions" "-ffunction-sections" "-fdata-sections"  "-fno-threadsafe-statics" "-MMD" " "))

(defun includes()
  (let ((paths (list "cores/arduino" "variants/leonardo" "libraries/SPI")))
    (mapcar (lambda(x) (concat "-I" *headers-base-path* x " ")) paths)))


(defun compile-options(file)
  (concat-with-spaces (avr "avr-g++")
          (apply #'concat-with-spaces (append *board-options* *compiler-options* (includes)))
          file))


(compile-options "WebRelay.cpp")

(defun avr-g++(file)
    (compile (compile-options file)))

(avr-g++ "WebRelay.cpp")

