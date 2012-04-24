#
#	Makefile - Makefile to build Ejscript with bit.
#
#	This Makefile will build a "minimal" Ejscript without external packages.
#	It is used to build Ejscript the first time before bit is available.
#	Once built, use bit to configure and rebuild as required.
#	

UNAME 	:= $(shell uname)
MAKE	:= make
EXT 	:= mk

ifeq ($(UNAME),Darwin)
	OS	:= macosx
endif
ifeq ($(UNAME),Linux)
	OS	:= linux
endif
ifeq ($(UNAME),Solaris)
	OS	:= solaris
endif
ifeq ($(UNAME),CYGWIN_NT-5.1)
	OS	:= win
	MAKE:= nmake
	EXT := nmake
endif

all compile:
	$(MAKE) -f projects/ejs-$(OS).$(EXT) $@
	@echo ; echo 'You can now use Ejscript or use "bit" to customize and re-build Ejscript, via:'
	@echo ; echo "   " $(OS)-*-*/bin/bit "configure build" ; echo

build configure generate test package:
	@bit $@

clean clobber:
	$(MAKE) -f projects/ejs-$(OS).$(EXT) $@

version:
	@bit -q version
