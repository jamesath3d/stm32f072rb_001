# Instructions: 
# 1) add a rule for your board to the bottom of this file
# 2) profit!

#LFLAGS_STM32=$(LFLAGS) template_stm32.c -T ld.stm32.basic
LFLAGS_STM32=$(LFLAGS) dyn_stm32.c -T ld.stm32.basic

#arm-none-eabi-gcc -DRCC_LED1=RCC_GPIOA -DPORT_LED1=GPIOA -DPIN_LED1=GPIO5   \
--static -nostartfiles -std=c11 -g3 -Os -fno-common -ffunction-sections -fdata-sections  \
-I./libopencm3/include -L./libopencm3/lib -mcpu=cortex-m0 -mthumb  \
-msoft-float -DSTM32F0 -DLITTLE_BIT=100000  \
-Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group template_stm32.c -T ld.stm32.basic  \
-lopencm3_stm32f0 -o bin/stm32/nucleo-f072rb.elf

# STM32F0 starts up with HSI at 8Mhz
STM32F0_CFLAGS=$(M0_FLAGS) -DSTM32F0 -DLITTLE_BIT=100000 $(LFLAGS_STM32) -lopencm3_stm32f0
# STM32F1 starts up with HSI at 8Mhz
STM32F1_CFLAGS=$(M3_FLAGS) -DSTM32F1 -DLITTLE_BIT=200000 $(LFLAGS_STM32) -lopencm3_stm32f1
# STM32F2 starts up with HSI at 16MHz
STM32F2_CFLAGS=$(M3_FLAGS) -DSTM32F2 -DLITTLE_BIT=400000 $(LFLAGS_STM32) -lopencm3_stm32f2
# STM32F3 starts up with HSI at 8MHz
STM32F3_CFLAGS=$(M4FH_FLAGS) -DSTM32F3 -DLITTLE_BIT=400000 $(LFLAGS_STM32) -lopencm3_stm32f3
# STM32F4 starts up with HSI at 16MHz
STM32F4_CFLAGS=$(M4FH_FLAGS) -DSTM32F4 -DLITTLE_BIT=800000 $(LFLAGS_STM32) -lopencm3_stm32f4
# STM32F7 starts up with HSI at 16MHz
STM32F7_CFLAGS=$(M7SP_FLAGS) -DSTM32F7 -DLITTLE_BIT=800000 $(LFLAGS_STM32) -lopencm3_stm32f7
# STM32L0 starts up with MSI at 2.1Mhz
STM32L0_CFLAGS=$(M0P_FLAGS) -DSTM32L0 -DLITTLE_BIT=50000 $(LFLAGS_STM32) -lopencm3_stm32l0
# STM32L1 starts up with MSI at 4MHz
STM32L1_CFLAGS=$(M3_FLAGS) -DSTM32L1 -DLITTLE_BIT=100000 $(LFLAGS_STM32) -lopencm3_stm32l1
# STM32L4 starts up with MSI at 4MHz
STM32L4_CFLAGS=$(M4FH_FLAGS) -DSTM32L4 -DLITTLE_BIT=100000 $(LFLAGS_STM32) -lopencm3_stm32l4
# STM32G0 starts up with HSI at 16MHz
STM32G0_CFLAGS=$(M0P_FLAGS) -DSTM32G0 -DLITTLE_BIT=400000 $(LFLAGS_STM32) -lopencm3_stm32g0
# STM32G4 starts up with HSI at 16MHz
STM32G4_CFLAGS=$(M4FH_FLAGS) -DSTM32G4 -DLITTLE_BIT=400000 $(LFLAGS_STM32) -lopencm3_stm32g4
# STM32H7 starts up with HSI at 64MHz
STM32H7_CFLAGS=$(M7DP_FLAGS) -DSTM32H7 -DLITTLE_BIT=3200000 $(LFLAGS_STM32) -lopencm3_stm32h7

define RAWMakeBoard
	$(CC) -DRCC_LED1=RCC_$(1) -DPORT_LED1=$(1) -DPIN_LED1=$(2) \
		$(if $(5),-DRCC_LED2=RCC_$(5) -DPORT_LED2=$(5) -DPIN_LED2=$(6),) \
		$(3) -o $(OD)/stm32/$(4)
endef

define MakeBoard
BOARDS_ELF+=$(OD)/stm32/$(1).elf
BOARDS_BIN+=$(OD)/stm32/$(1).bin
BOARDS_HEX+=$(OD)/stm32/$(1).hex
#$(OD)/stm32/$(1).elf: template_stm32.c libopencm3/lib/libopencm3_$(5).a
$(OD)/stm32/$(1).elf: dyn_stm32.c libopencm3/lib/libopencm3_$(5).a
	@echo "  $(5) -> Creating $(OD)/stm32/$(1).elf"
	$(call RAWMakeBoard,$(2),$(3),$(4),$(1).elf,$(6),$(7))
endef

define stm32f0board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F0_CFLAGS),stm32f0,$(4),$(5))
endef
define stm32f1board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F1_CFLAGS),stm32f1,$(4),$(5))
endef
define stm32f2board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F2_CFLAGS),stm32f2,$(4),$(5))
endef
define stm32f3board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F3_CFLAGS),stm32f3,$(4),$(5))
endef
define stm32f4board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F4_CFLAGS),stm32f4,$(4),$(5))
endef
define stm32f7board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F7_CFLAGS),stm32f7,$(4),$(5))
endef
define stm32l0board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32L0_CFLAGS),stm32l0,$(4),$(5))
endef
define stm32l1board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32L1_CFLAGS),stm32l1,$(4),$(5))
endef
define stm32l4board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32L4_CFLAGS),stm32l4,$(4),$(5))
endef
define stm32g0board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32G0_CFLAGS),stm32g0)
endef
define stm32g4board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32G4_CFLAGS),stm32g4)
endef
define stm32h7board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32H7_CFLAGS),stm32h7,$(4),$(5))
endef

# STM32F0 boards
#$(eval $(call stm32f0board,stm32f0-discovery,GPIOC,GPIO8))
#$(eval $(call stm32f0board,nucleo-f030r8,GPIOA,GPIO5))
#$(eval $(call stm32f0board,nucleo-f031k6,GPIOB,GPIO3))
#$(eval $(call stm32f0board,nucleo-f042k6,GPIOB,GPIO3))
#$(eval $(call stm32f0board,nucleo-f070rb,GPIOA,GPIO5))
#$(eval $(call stm32f0board,nucleo-f072rb,GPIOA,GPIO5))

$(eval $(call stm32f0board,nucleo-f072rb,GPIOA,GPIO5))
# stm32f0 -> Creating bin/stm32/nucleo-f072rb.elf
#arm-none-eabi-gcc -DRCC_LED1=RCC_GPIOA -DPORT_LED1=GPIOA -DPIN_LED1=GPIO5  --static -nostartfiles -std=c11 -g3 -Os -fno-common -ffunction-sections -fdata-sections -I./libopencm3/include -L./libopencm3/lib -mcpu=cortex-m0 -mthumb -msoft-float -DSTM32F0 -DLITTLE_BIT=100000 -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group template_stm32.c -T ld.stm32.basic -lopencm3_stm32f0 -o bin/stm32/nucleo-f072rb.elf
#arm-none-eabi-objcopy -Obinary bin/stm32/nucleo-f072rb.elf bin/stm32/nucleo-f072rb.bin
#arm-none-eabi-objcopy -Oihex bin/stm32/nucleo-f072rb.elf bin/stm32/nucleo-f072rb.hex


