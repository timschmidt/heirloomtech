#
# Wizard autogenerated makefile.
# DO NOT EDIT, use the arduino_empty_user.mk file instead.
#

# Constants automatically defined by the selected modules
arduino_empty_DEBUG = 1

# Our target application
TRG += arduino_empty

arduino_empty_PREFIX = "avr-"

arduino_empty_SUFFIX = ""

arduino_empty_SRC_PATH = boards/arduino/templates/arduino_empty

arduino_empty_HW_PATH = boards/arduino

# Files automatically generated by the wizard. DO NOT EDIT, USE arduino_empty_USER_CSRC INSTEAD!
arduino_empty_WIZARD_CSRC = \
	bertos/cpu/avr/drv/ser_avr.c \
	bertos/cpu/avr/drv/ser_mega.c \
	bertos/cpu/avr/drv/timer_avr.c \
	bertos/cpu/avr/drv/timer_mega.c \
	bertos/drv/ser.c \
	bertos/drv/timer.c \
	bertos/io/kfile.c \
	bertos/mware/event.c \
	bertos/mware/formatwr.c \
	bertos/mware/hex.c \
	bertos/struct/heap.c \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE arduino_empty_USER_PCSRC INSTEAD!
arduino_empty_WIZARD_PCSRC = \
	bertos/mware/formatwr.c \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE arduino_empty_USER_CPPASRC INSTEAD!
arduino_empty_WIZARD_CPPASRC = \
	 \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE arduino_empty_USER_CXXSRC INSTEAD!
arduino_empty_WIZARD_CXXSRC = \
	 \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE arduino_empty_USER_ASRC INSTEAD!
arduino_empty_WIZARD_ASRC = \
	 \
	#

arduino_empty_CPPFLAGS = -D'CPU_FREQ=(16000000UL)' -D'ARCH=(ARCH_DEFAULT)' -D'WIZ_AUTOGEN' -I$(arduino_empty_HW_PATH) -I$(arduino_empty_SRC_PATH) $(arduino_empty_CPU_CPPFLAGS) $(arduino_empty_USER_CPPFLAGS)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_LDFLAGS = $(arduino_empty_CPU_LDFLAGS) $(arduino_empty_WIZARD_LDFLAGS) $(arduino_empty_USER_LDFLAGS)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_CPPAFLAGS = $(arduino_empty_CPU_CPPAFLAGS) $(arduino_empty_WIZARD_CPPAFLAGS) $(arduino_empty_USER_CPPAFLAGS)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_CSRC = $(arduino_empty_CPU_CSRC) $(arduino_empty_WIZARD_CSRC) $(arduino_empty_USER_CSRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_PCSRC = $(arduino_empty_CPU_PCSRC) $(arduino_empty_WIZARD_PCSRC) $(arduino_empty_USER_PCSRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_CPPASRC = $(arduino_empty_CPU_CPPASRC) $(arduino_empty_WIZARD_CPPASRC) $(arduino_empty_USER_CPPASRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_CXXSRC = $(arduino_empty_CPU_CXXSRC) $(arduino_empty_WIZARD_CXXSRC) $(arduino_empty_USER_CXXSRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_ASRC = $(arduino_empty_CPU_ASRC) $(arduino_empty_WIZARD_ASRC) $(arduino_empty_USER_ASRC)

# CPU specific flags and options, defined in the CPU definition files.
# Automatically generated by the wizard. PLEASE DO NOT EDIT!
arduino_empty_MCU = atmega328p
arduino_empty_CPU_CPPFLAGS = -Os -Ibertos/cpu/avr/
arduino_empty_PROGRAMMER_CPU = atmega328p
arduino_empty_STOPFLASH_SCRIPT = bertos/prg_scripts/avr/stopflash.sh
arduino_empty_STOPDEBUG_SCRIPT = bertos/prg_scripts/none.sh
arduino_empty_DEBUG_SCRIPT = bertos/prg_scripts/nodebug.sh
arduino_empty_FLASH_SCRIPT = bertos/prg_scripts/avr/flash.sh

include $(arduino_empty_SRC_PATH)/arduino_empty_user.mk
