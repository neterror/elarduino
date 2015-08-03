; -*- lexical-binding: t -*-

(require 'cl)
(require 'lr-util)

(defvar lr-config-obarray (make-vector 4096 nil)
  "Obarray for the symbols, that represent all possible config options. 
The config options for each board are set in property lists for for their symbol")

(defcustom lr-arduino-app  "/home/plamen/arduino-1.6.5/"
  "Base directory of Arduino IDE")

(defun lr-arduino-base()
  (cond ((string-prefix-p "gnu" (symbol-name system-type)) lr-arduino-app)
	((string=       "darwin"(symbol-name system-type)) (concat lr-arduino-app "Contents/Resources/Java/"))))

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
        (value (or (mapconcat #'identity (butlast (cdr line-tokens)) "/") "value"))
        (option-value (intern value lr-config-obarray)))
    (put option-name option-value (last line-tokens))))


(defun lr-parse-file(file-name)
  (mapcar #'lr-intern-tokens (lr-file-tokens file-name)))


(defun lr-format-version(version)
  (let ((tokens (split-string version "[.]")))
    (format "%d%.2d%.2d"
            (string-to-number (nth 0 tokens))
            (string-to-number (nth 1 tokens))
            (string-to-number (nth 2 tokens)))))

(defun lr-board-options(board)
  (mapconcat #'identity
	     (list (concat "-mmcu=" (lr-config-get board "build/mcu"))
		   (concat "-DF_CPU=" (lr-config-get board "build/mcu"))
		   (concat "-DARDUINO_" (lr-config-get board "build/board"))
		   (concat "-DARDUINO=" (lr-format-version (lr-config-get "version" "value")))
		   (lr-config-get "compiler" "cpp/flags")
                   "-DARDUINO_ARCH_AVR") " "))


(defun lr-avr-tool(tool)
  "Returns the fullpath to the tools cpp, ar, objcopy, elf2hex, size"
  (concat (lr-arduino-base) "hardware/tools/avr/bin/" (lr-config-get "compiler" (concat tool "/cmd"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; API calls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lr-config-init()
  "Loads the boards.txt and platform.txt files from Arduino directory"
  (lr-parse-file (concat (lr-arduino-base) "hardware/arduino/avr/boards.txt"))
  (lr-parse-file (concat (lr-arduino-base) "hardware/arduino/avr/platform.txt"))
  (lr-config-get "version" "value"))

(defun lr-config-get(option value)
  (car (get (intern-soft option lr-config-obarray) (intern value lr-config-obarray))))
  

(lr-config-init)



;; (defun includes() 
;;   (let ((libraries (mapcar #'(lambda(x) (concat (lr-sub-directories (concat lr-arduino-base "libraries/"))))

;;  (let ((paths (list "cores/arduino" "variants/leonardo" "libraries/SPI")))
;;     (mapcar (lambda(x) (concat "-I" *headers-base-path* x " ")) paths)))


(defun concat-with(separator list)
    (let ((result (mapconcat #'identity list separator)))
        (if (zerop (length result)) nil result)))

(provide 'lr-config)


