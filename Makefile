define EOL


endef
dateX1:=$(shell LC_ALL=C date +%Y_%m%d_%H%M%P_%S)

PREFIX?=arm-none-eabi-
CC=$(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy
OD=bin

b:=build
f:=flash

allX:=b f
all: 
	@$(foreach aa1,$(allX),@echo "$(aa1) --> $($(aa1))"$(EOL))
b $(b): 
	make V=1 realall.really
#f_cfg:=interface/stlink-v2-1.cfg
f_cfg:=interface/stlink.cfg
f $(f): bin/stm32/nucleo-f072rb.elf
	openocd \
		-f $(f_cfg) \
		-f target/stm32f0x.cfg \
		-c "program $<  \
		verify  \
		reset \
		exit"

SFLAGS= --static -nostartfiles -std=c11 -g3 -Os
SFLAGS+= -fno-common -ffunction-sections -fdata-sections
SFLAGS+= -I./libopencm3/include -L./libopencm3/lib
LFLAGS+=-Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group

M0_FLAGS= $(SFLAGS) -mcpu=cortex-m0 -mthumb -msoft-float
M0P_FLAGS= $(SFLAGS) -mcpu=cortex-m0plus -mthumb -msoft-float
M3_FLAGS= $(SFLAGS) -mcpu=cortex-m3 -mthumb -msoft-float
M4FH_FLAGS= $(SFLAGS) -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
M7SP_FLAGS= $(SFLAGS) -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16
M7DP_FLAGS= $(SFLAGS) -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-d16

#include boards.efm32.mk
#include boards.sam.mk
#include boards.stm32.mk
include boards.stm32.stm32f072rb.mk
#include boards.ti.mk
#include boards.nrf.mk

realall.really: outdir $(BOARDS_ELF) $(BOARDS_BIN) $(BOARDS_HEX)

libopencm3/Makefile:
	@echo "Initializing libopencm3 submodule"
	git submodule update --init

libopencm3/lib/libopencm3_%.a: libopencm3/Makefile
	$(MAKE) -C libopencm3

%.bin: %.elf
	@#printf "  OBJCOPY $(*).bin\n"
	$(OBJCOPY) -Obinary $(*).elf $(*).bin

%.hex: %.elf
	@#printf "  OBJCOPY $(*).hex\n"
	$(OBJCOPY) -Oihex $(*).elf $(*).hex

outdir:
	mkdir -p $(OD)/efm32
	mkdir -p $(OD)/sam
	mkdir -p $(OD)/stm32
	mkdir -p $(OD)/ti
	mkdir -p $(OD)/nrf52

c : clean
m:
	vim Makefile
v:
	vim template_stm32.c
gs:
	git status
gc:
	git commit
ga:
	git add .
gcX: 
	git commit -a -m '$(dateX1)'
X:ga gcX up


up:
	git push -u origin main

clean:
	$(RM) $(BOARDS_ELF) $(BOARDS_BIN) $(BOARDS_HEX)

.PHONY: realall.really outdir clean all
$(V).SILENT:

