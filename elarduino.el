(provide 'elarduino)

(if (not (memq "." load-path))
    (setf load-path (append load-path (list "."))))

(require 'lr-util)
(require 'lr-config)


