SRCS = math.asm memory.asm nexys3.asm uart.asm
ASMFLAGS = -g -el -z0
TARGET = lowlevel.lib
KIND = library
include rules.mk
