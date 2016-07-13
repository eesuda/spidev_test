# Makefile
#
# ============================================================================
# Copyright (c) Soochow University. 2013
#
# Use of this software is controlled by the terms and conditions found in the
# license agreement under which this software has been supplied or provided.
# ============================================================================

# Comment this out if you want to see full compiler and linker output.
VERBOSE = @
#
TARGET = $(notdir $(CURDIR))

CROSS_PREFIX = arm-linux-gnueabihf-

RM = rm
STRIP = $(CROSS_PREFIX)strip
#SYSROOT = /home/xbuild/poky/build/tmp/sysroots/tele
C_FLAGS += -O2 -Wall --sysroot=$(SYSROOT)

LD_FLAGS += -Wl,-lpthread --sysroot=$(SYSROOT)

COMPILE.c = $(VERBOSE) $(CROSS_PREFIX)gcc $(C_FLAGS) $(CPP_FLAGS) -c
LINK.c = $(VERBOSE) $(CROSS_PREFIX)gcc $(LD_FLAGS)

SOURCES = $(wildcard *.c) $(wildcard ../*.c)
HEADERS = $(wildcard *.h) $(wildcard ../*.h)

OBJFILES = $(SOURCES:%.c=%.o)

.PHONY: clean

all:	$(TARGET)

$(TARGET):	$(OBJFILES)
	@echo
	@echo Linking $@ from $^..
	$(LINK.c) -o $@ $^
	$(STRIP) $@

$(OBJFILES):	%.o: %.c $(HEADERS)
	@echo Compiling $@ from $<..
	$(COMPILE.c) -o $@ $<

clean:
	@echo Removing generated files..
	$(VERBOSE) -$(RM) -rf $(OBJFILES) $(TARGET) *~ *.d .dep
