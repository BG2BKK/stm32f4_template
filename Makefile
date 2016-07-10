# put your *.o targets here, make should handle the rest!

SRCS = main.c syscalls.c stm32f4xx_it.c system_stm32f4xx.c

# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)

PROJ_NAME=main

# that's it, no need to change anything below this line!

###################################################

CC=arm-none-eabi-gcc
SIZE=arm-none-eabi-size
OBJCOPY=arm-none-eabi-objcopy

CFLAGS  = -g -O2 -Wall -TLinkerScript.ld -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16

###################################################

vpath %.c src
vpath %.a lib

ROOT=$(shell pwd)

CFLAGS += -Iinc -ICMSIS/core  -ICMSIS/device -IStdPeriph_Driver/inc

SRCS += startup/startup_stm32f4xx.S # add startup file to build

OBJS = $(SRCS:.c=.o)

###################################################

.PHONY: lib proj

all: lib proj

lib:
	$(MAKE) -C StdPeriph_Driver

proj: 	$(PROJ_NAME).elf 

$(PROJ_NAME).elf: $(SRCS)  
	$(CC) $(CFLAGS) $^ -o $@ -LStdPeriph_Driver -lstm32f4
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin
	@echo "" 
	$(SIZE) $(PROJ_NAME).elf
	@echo "" 
	$(SIZE) $(PROJ_NAME).hex

clean:
#	$(MAKE) -C StdPeriph_Driver clean
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
	rm -rf Debug Release
	rm -f *~ out core

flash:
	st-flash --reset write main.bin 0x08000000

debug:
	echo "echo Executing GDB with .gdbinit to connect to OpenOCD. \n" > .gdbinit
	echo "echo .gdbinit is a hidden file.\n echo Press Ctrl-H in the current working directory to see it. \n" >> .gdbinit
	echo "# Connect to OpenOCD" >> .gdbinit
	echo "target extended-remote localhost:4242" >> .gdbinit
	echo "# Reset the target and call its init script" >> .gdbinit
	echo "monitor reset init" >> .gdbinit
	echo "# Halt the target. The init script should halt the target, but just in case" >> .gdbinit
	echo "monitor halt" >> .gdbinit
	echo "b main" >> .gdbinit
	echo "jump main" >> .gdbinit
	arm-none-eabi-gdb main.elf -iex 'add-auto-load-safe-path .'
