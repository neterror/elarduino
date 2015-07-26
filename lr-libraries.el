(require 'lr-util)
(require 'lr-config)

(defun lr-libraries(base-path)
  (let ((base-path (concat base-path "libraries/")))
    (mapcar #'(lambda(x) (concat base-path x)) (lr-sub-directories base-path))))


(defun lr-arduino-libraries()
  (append
   (lr-libraries (concat lr-arduino-base "hardware/arduino/avr/"))
   (lr-libraries lr-arduino-base)))

(defun lr-required-libraries(file-name)
  

