(defun config-option (plist options)
  (if (cdr options)
      (config-option (plist-get plist (car options)) (cdr options))
    (plist-get plist (car options))))

(setq boards '(yun
               (upload (tool "avrdude" protocol "avr109")
                       build (mcu "atmega32u4" f_cpu "16000000L"))
               uno
               (upload (tool "avrdude" protocol "arduino")
                       build (mcu "atmega328p" f_cpu "16000000L"))))

(plist-get (plist-get (plist-get boards 'uno) 'build) 'f_cpu)


(config-option boards (list 'uno 'build 'mcu))

