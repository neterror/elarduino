(defcustom elar-arduino-app  "/Applications/Arduino.app/"
  "Base directory of Arduino IDE")

(defvar elar-avr-bin (concat elar-arduino-app "/Contents/Resources/Java/hardware/tools/avr/bin")
  "Path to avr-gcc binaries")
                             
(defvar elar-headers (concat elar-arduino-app "/Contents/Resources/Java/hardware/arduino/avr/")
  "Base path to avr-gcc include dir")

(defvar elar-board-options (list "-mmcu=atmega32u4" "-DF_CPU=16000000L" "-DARDUINO=10601" "-DARDUINO_AVR_LEONARDO" "-DARDUINO_ARCH_AVR" " ")
  "TODO: The board options should be taken from board.txt file")

(defvar elar-compiler-options (list "-c" "-g" "-Os" "-w" "-fno-exceptions" "-ffunction-sections" "-fdata-sections"  "-fno-threadsafe-statics" "-MMD" " ")
  "TODO: The compiler options should be taken from some config file")
  
leonardo.build.mcu=atmega32u4
leonardo.build.f_cpu=16000000L
leonardo.build.vid=0x2341
leonardo.build.pid=0x8036
leonardo.build.usb_product="Arduino Leonardo"
leonardo.build.board=AVR_LEONARDO
leonardo.build.core=arduino
leonardo.build.variant=leonardo
leonardo.build.extra_flags={build.usb_flags}


(provide 'lr-config)
