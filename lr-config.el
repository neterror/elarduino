(require 'cl)
(require 'lr-util)

(setq lexical-binding t)
(defvar lr-config-obarray (make-vector 1024 nil)
  "Obarray for the symbols, that represent all possible config options. 
The config options for each board are set in property lists for for their symbol")


(defcustom lr-arduino-app  "/Applications/Arduino.app/"
  "Base directory of Arduino IDE")

(defvar lr-avr-bin (concat lr-arduino-app "/Contents/Resources/Java/hardware/tools/avr/bin")
  "Path to avr-gcc binaries")
                             
(defvar lr-avr-base (concat lr-arduino-app "/Contents/Resources/Java/hardware/arduino/avr/")
  "Base path to avr-gcc include dir")


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

(defun lr-tokenize-line(line)
  "Tokenize single line which is not comment"
  (if (not (string-prefix-p "#" line))
    (let ((tokens (split-string line "[=]")))
      (if (eq (length tokens) 2)
          (append (split-string (car tokens) "[.]") (cdr tokens))))))

(defun lr-file-tokens(file-name)
  "Load the file and return each of non-comment lines tokenized"
  (remove-if #'null
             (mapcar #'lr-tokenize-line (lr-split-lines (lr-load-file file-name)))))

(defun lr-intern-tokens(line-tokens)
  "Given a single line with tokens, the first item is the board, the last is the value, the middle is the option name
Intern the board in the lr-config array"
  (let* ((option-name (intern (car line-tokens) lr-config-obarray))
        (value (or (concat-with "/" (butlast (cdr line-tokens))) "value"))
        (option-value (intern value lr-config-obarray)))
    (put option-name option-value (last line-tokens))))


(defun lr-parse-file(file-name)
  (mapcar #'lr-intern-tokens (lr-file-tokens file-name)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; API calls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lr-config-init()
  "Loads the boards.txt and platform.txt files from Arduino directory"
  (setq lr-config-obarray (make-vector 128 nil))
  (lr-parse-file (concat lr-avr-base "boards.txt"))
  (lr-parse-file (concat lr-avr-base "platform.txt"))
  (lr-config-version))

(defun lr-config-get (option value)
  (car (get (intern-soft option lr-config-obarray) (intern value lr-config-obarray))))

(defun lr-format-version(version)
  (let ((tokens (split-string version "[.]")))
    (format "%d%.2d%.2d"
            (string-to-number (nth 0 tokens))
            (string-to-number (nth 1 tokens))
            (string-to-number (nth 2 tokens)))))
  
(defun lr-config-version()
  (lr-config-get "version" "value"))


;;todo -- append the arduino version taken from platform.txt as "-DARDUINO=10601"
(defun lr-board-options(board)
  (list (concat "-mmcu=" (lr-config-get board "build/mcu"))
        (concat "-DF_CPU=" (lr-config-get board "build/mcu"))
        (concat "-DARDUINO_" (lr-config-get board "build/board"))
        (concat "-DARDUINO=" (lr-format-version (lr-config-version)))
        "-DARDUINO_ARCH_AVR"))

(defun lr-compiler-options()
  (list (concat (lr-config-get "compiler" "cpp/flags"))))

(lr-config-init)
(lr-board-options "leonardo")
(lr-compiler-options) 
