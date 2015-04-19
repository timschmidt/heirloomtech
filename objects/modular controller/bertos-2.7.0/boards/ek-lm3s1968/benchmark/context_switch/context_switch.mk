#
# Wizard autogenerated makefile.
# DO NOT EDIT, use the context_switch_user.mk file instead.
#

# Constants automatically defined by the selected modules


# Our target application
TRG += context_switch

context_switch_PREFIX = "arm-none-eabi-"

context_switch_SUFFIX = ""

context_switch_SRC_PATH = boards/ek-lm3s1968/benchmark/context_switch

context_switch_HW_PATH = boards/ek-lm3s1968

# Files automatically generated by the wizard. DO NOT EDIT, USE context_switch_USER_CSRC INSTEAD!
context_switch_WIZARD_CSRC = \
	bertos/benchmark/context_switch.c \
	bertos/cpu/cortex-m3/hw/switch_ctx_cm3.c \
	bertos/io/kfile.c \
	bertos/cpu/cortex-m3/drv/timer_cm3.c \
	bertos/drv/timer.c \
	bertos/mware/formatwr.c \
	bertos/cpu/cortex-m3/drv/ser_lm3s.c \
	bertos/mware/event.c \
	bertos/kern/proc.c \
	bertos/drv/ser.c \
	bertos/mware/hex.c \
	bertos/kern/signal.c \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE context_switch_USER_PCSRC INSTEAD!
context_switch_WIZARD_PCSRC = \
	 \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE context_switch_USER_CPPASRC INSTEAD!
context_switch_WIZARD_CPPASRC = \
	 \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE context_switch_USER_CXXSRC INSTEAD!
context_switch_WIZARD_CXXSRC = \
	 \
	#

# Files automatically generated by the wizard. DO NOT EDIT, USE context_switch_USER_ASRC INSTEAD!
context_switch_WIZARD_ASRC = \
	 \
	#

context_switch_CPPFLAGS = -D'CPU_FREQ=(50000000UL)' -D'ARCH=(ARCH_DEFAULT)' -D'WIZ_AUTOGEN' -I$(context_switch_HW_PATH) -I$(context_switch_SRC_PATH) $(context_switch_CPU_CPPFLAGS) $(context_switch_USER_CPPFLAGS)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_LDFLAGS = $(context_switch_CPU_LDFLAGS) $(context_switch_WIZARD_LDFLAGS) $(context_switch_USER_LDFLAGS)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_CPPAFLAGS = $(context_switch_CPU_CPPAFLAGS) $(context_switch_WIZARD_CPPAFLAGS) $(context_switch_USER_CPPAFLAGS)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_CSRC = $(context_switch_CPU_CSRC) $(context_switch_WIZARD_CSRC) $(context_switch_USER_CSRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_PCSRC = $(context_switch_CPU_PCSRC) $(context_switch_WIZARD_PCSRC) $(context_switch_USER_PCSRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_CPPASRC = $(context_switch_CPU_CPPASRC) $(context_switch_WIZARD_CPPASRC) $(context_switch_USER_CPPASRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_CXXSRC = $(context_switch_CPU_CXXSRC) $(context_switch_WIZARD_CXXSRC) $(context_switch_USER_CXXSRC)

# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_ASRC = $(context_switch_CPU_ASRC) $(context_switch_WIZARD_ASRC) $(context_switch_USER_ASRC)

# CPU specific flags and options, defined in the CPU definition files.
# Automatically generated by the wizard. PLEASE DO NOT EDIT!
context_switch_CPU_CPPASRC = bertos/cpu/cortex-m3/hw/crt_cm3.S bertos/cpu/cortex-m3/hw/vectors_cm3.S
context_switch_CPU_CPPAFLAGS = -g -gdwarf-2 -mthumb -mno-thumb-interwork
context_switch_CPU_CPPFLAGS = -O0 -g3 -gdwarf-2 -mthumb -mno-thumb-interwork -fno-strict-aliasing -fwrapv -fverbose-asm -Ibertos/cpu/cortex-m3/ -D__ARM_LM3S1968__
context_switch_CPU_CSRC = bertos/cpu/cortex-m3/hw/init_cm3.c bertos/cpu/cortex-m3/drv/irq_cm3.c bertos/cpu/cortex-m3/drv/gpio_lm3s.c bertos/cpu/cortex-m3/drv/clock_lm3s.c
context_switch_PROGRAMMER_CPU = lm3s
context_switch_STOPFLASH_SCRIPT = bertos/prg_scripts/arm/stopopenocd.sh
context_switch_CPU = cortex-m3
context_switch_STOPDEBUG_SCRIPT = bertos/prg_scripts/arm/stopopenocd.sh
context_switch_DEBUG_SCRIPT = bertos/prg_scripts/arm/debug.sh
context_switch_CPU_LDFLAGS = -mthumb -mno-thumb-interwork -nostartfiles -Wl,--no-warn-mismatch -T bertos/cpu/cortex-m3/scripts/lm3s1968_rom.ld
context_switch_FLASH_SCRIPT = bertos/prg_scripts/arm/flash-lm3s.sh

include $(context_switch_SRC_PATH)/context_switch_user.mk
