#
#   ejs-freebsd-default.mk -- Makefile to build Embedthis Ejscript for freebsd
#

NAME                  := ejs
VERSION               := 2.5.3
PROFILE               ?= default
ARCH                  ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
CC_ARCH               ?= $(shell echo $(ARCH) | sed 's/x86/i686/;s/x64/x86_64/')
OS                    ?= freebsd
CC                    ?= gcc
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_COMPILER       ?= 1
ME_COM_EST            ?= 0
ME_COM_HTTP           ?= 1
ME_COM_LIB            ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MBEDTLS        ?= 0
ME_COM_MPR            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 1
ME_COM_OSDEP          ?= 1
ME_COM_PCRE           ?= 1
ME_COM_SQLITE         ?= 1
ME_COM_SSL            ?= 1
ME_COM_VXWORKS        ?= 0
ME_COM_WINSDK         ?= 1
ME_COM_ZLIB           ?= 1

ME_COM_OPENSSL_PATH   ?= "/usr/lib"

ifeq ($(ME_COM_EST),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_LIB),1)
    ME_COM_COMPILER := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif

CFLAGS                += -fPIC -w
DFLAGS                += -D_REENTRANT -DPIC $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_COMPILER=$(ME_COM_COMPILER) -DME_COM_EST=$(ME_COM_EST) -DME_COM_HTTP=$(ME_COM_HTTP) -DME_COM_LIB=$(ME_COM_LIB) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MBEDTLS=$(ME_COM_MBEDTLS) -DME_COM_MPR=$(ME_COM_MPR) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_OSDEP=$(ME_COM_OSDEP) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_SQLITE=$(ME_COM_SQLITE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_VXWORKS=$(ME_COM_VXWORKS) -DME_COM_WINSDK=$(ME_COM_WINSDK) -DME_COM_ZLIB=$(ME_COM_ZLIB) 
IFLAGS                += "-I$(BUILD)/inc"
LDFLAGS               += 
LIBPATHS              += -L$(BUILD)/bin
LIBS                  += -ldl -lpthread -lm

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= 
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local
ME_DATA_PREFIX        ?= $(ME_ROOT_PREFIX)/
ME_STATE_PREFIX       ?= $(ME_ROOT_PREFIX)/var
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)/lib/$(NAME)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)/$(VERSION)
ME_BIN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/bin
ME_INC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/include
ME_LIB_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/lib
ME_MAN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/share/man
ME_SBIN_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local/sbin
ME_ETC_PREFIX         ?= $(ME_ROOT_PREFIX)/etc/$(NAME)
ME_WEB_PREFIX         ?= $(ME_ROOT_PREFIX)/var/www/$(NAME)
ME_LOG_PREFIX         ?= $(ME_ROOT_PREFIX)/var/log/$(NAME)
ME_SPOOL_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)
ME_CACHE_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)/cache
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)$(NAME)-$(VERSION)


TARGETS               += $(BUILD)/bin/ejs
TARGETS               += $(BUILD)/bin/ejs.db.mapper.mod
TARGETS               += $(BUILD)/bin/ejs.db.sqlite.mod
TARGETS               += $(BUILD)/bin/ejs.mail.mod
TARGETS               += $(BUILD)/bin/ejs.mvc.mod
TARGETS               += $(BUILD)/bin/ejs.tar.mod
TARGETS               += $(BUILD)/bin/ejsrun
ifeq ($(ME_COM_SSL),1)
    TARGETS           += $(BUILD)/bin
endif
TARGETS               += $(BUILD)/bin/libejs.db.sqlite.so
TARGETS               += $(BUILD)/bin/libejs.web.so
TARGETS               += $(BUILD)/bin/mvc
TARGETS               += $(BUILD)/bin/utest
TARGETS               += $(BUILD)/bin/ejsman
TARGETS               += $(BUILD)/bin/www

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(BUILD)/bin ] && mkdir -p $(BUILD)/bin; true
	@[ ! -x $(BUILD)/inc ] && mkdir -p $(BUILD)/inc; true
	@[ ! -x $(BUILD)/obj ] && mkdir -p $(BUILD)/obj; true
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/ejs-freebsd-default-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/ejs-freebsd-default-me.h >/dev/null ; then\
		cp projects/ejs-freebsd-default-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build" ; \
			echo "   [Warning] Previous build command: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo "$(MAKEFLAGS)" >$(BUILD)/.makeflags

clean:
	rm -f "$(BUILD)/obj/doc.o"
	rm -f "$(BUILD)/obj/docFiles.o"
	rm -f "$(BUILD)/obj/dtoa.o"
	rm -f "$(BUILD)/obj/ecAst.o"
	rm -f "$(BUILD)/obj/ecCodeGen.o"
	rm -f "$(BUILD)/obj/ecCompiler.o"
	rm -f "$(BUILD)/obj/ecLex.o"
	rm -f "$(BUILD)/obj/ecModuleWrite.o"
	rm -f "$(BUILD)/obj/ecParser.o"
	rm -f "$(BUILD)/obj/ecState.o"
	rm -f "$(BUILD)/obj/ejs.o"
	rm -f "$(BUILD)/obj/ejsApp.o"
	rm -f "$(BUILD)/obj/ejsArray.o"
	rm -f "$(BUILD)/obj/ejsBlock.o"
	rm -f "$(BUILD)/obj/ejsBoolean.o"
	rm -f "$(BUILD)/obj/ejsByteArray.o"
	rm -f "$(BUILD)/obj/ejsByteCode.o"
	rm -f "$(BUILD)/obj/ejsCache.o"
	rm -f "$(BUILD)/obj/ejsCmd.o"
	rm -f "$(BUILD)/obj/ejsConfig.o"
	rm -f "$(BUILD)/obj/ejsDate.o"
	rm -f "$(BUILD)/obj/ejsDebug.o"
	rm -f "$(BUILD)/obj/ejsError.o"
	rm -f "$(BUILD)/obj/ejsException.o"
	rm -f "$(BUILD)/obj/ejsFile.o"
	rm -f "$(BUILD)/obj/ejsFileSystem.o"
	rm -f "$(BUILD)/obj/ejsFrame.o"
	rm -f "$(BUILD)/obj/ejsFunction.o"
	rm -f "$(BUILD)/obj/ejsGC.o"
	rm -f "$(BUILD)/obj/ejsGlobal.o"
	rm -f "$(BUILD)/obj/ejsHelper.o"
	rm -f "$(BUILD)/obj/ejsHttp.o"
	rm -f "$(BUILD)/obj/ejsHttpServer.o"
	rm -f "$(BUILD)/obj/ejsInterp.o"
	rm -f "$(BUILD)/obj/ejsIterator.o"
	rm -f "$(BUILD)/obj/ejsJSON.o"
	rm -f "$(BUILD)/obj/ejsLoader.o"
	rm -f "$(BUILD)/obj/ejsLocalCache.o"
	rm -f "$(BUILD)/obj/ejsMath.o"
	rm -f "$(BUILD)/obj/ejsMemory.o"
	rm -f "$(BUILD)/obj/ejsModule.o"
	rm -f "$(BUILD)/obj/ejsMprLog.o"
	rm -f "$(BUILD)/obj/ejsNamespace.o"
	rm -f "$(BUILD)/obj/ejsNull.o"
	rm -f "$(BUILD)/obj/ejsNumber.o"
	rm -f "$(BUILD)/obj/ejsObject.o"
	rm -f "$(BUILD)/obj/ejsPath.o"
	rm -f "$(BUILD)/obj/ejsPot.o"
	rm -f "$(BUILD)/obj/ejsRegExp.o"
	rm -f "$(BUILD)/obj/ejsRequest.o"
	rm -f "$(BUILD)/obj/ejsScope.o"
	rm -f "$(BUILD)/obj/ejsService.o"
	rm -f "$(BUILD)/obj/ejsSession.o"
	rm -f "$(BUILD)/obj/ejsSocket.o"
	rm -f "$(BUILD)/obj/ejsSqlite.o"
	rm -f "$(BUILD)/obj/ejsString.o"
	rm -f "$(BUILD)/obj/ejsSystem.o"
	rm -f "$(BUILD)/obj/ejsTimer.o"
	rm -f "$(BUILD)/obj/ejsType.o"
	rm -f "$(BUILD)/obj/ejsUri.o"
	rm -f "$(BUILD)/obj/ejsVoid.o"
	rm -f "$(BUILD)/obj/ejsWeb.o"
	rm -f "$(BUILD)/obj/ejsWebSocket.o"
	rm -f "$(BUILD)/obj/ejsWorker.o"
	rm -f "$(BUILD)/obj/ejsXML.o"
	rm -f "$(BUILD)/obj/ejsXMLList.o"
	rm -f "$(BUILD)/obj/ejsXMLLoader.o"
	rm -f "$(BUILD)/obj/ejsZlib.o"
	rm -f "$(BUILD)/obj/ejsc.o"
	rm -f "$(BUILD)/obj/ejsmod.o"
	rm -f "$(BUILD)/obj/ejsrun.o"
	rm -f "$(BUILD)/obj/est.o"
	rm -f "$(BUILD)/obj/estLib.o"
	rm -f "$(BUILD)/obj/http.o"
	rm -f "$(BUILD)/obj/httpLib.o"
	rm -f "$(BUILD)/obj/listing.o"
	rm -f "$(BUILD)/obj/mprLib.o"
	rm -f "$(BUILD)/obj/openssl.o"
	rm -f "$(BUILD)/obj/pcre.o"
	rm -f "$(BUILD)/obj/slotGen.o"
	rm -f "$(BUILD)/obj/sqlite.o"
	rm -f "$(BUILD)/obj/sqlite3.o"
	rm -f "$(BUILD)/obj/watchdog.o"
	rm -f "$(BUILD)/obj/zlib.o"
	rm -f "$(BUILD)/bin/ejs"
	rm -f "$(BUILD)/bin/ejsc"
	rm -f "$(BUILD)/bin/ejsmod"
	rm -f "$(BUILD)/bin/ejsrun"
	rm -f "$(BUILD)/bin"
	rm -f "$(BUILD)/bin/libejs.so"
	rm -f "$(BUILD)/bin/libejs.db.sqlite.so"
	rm -f "$(BUILD)/bin/libejs.web.so"
	rm -f "$(BUILD)/bin/libejs.zlib.so"
	rm -f "$(BUILD)/bin/libhttp.so"
	rm -f "$(BUILD)/bin/libmpr.so"
	rm -f "$(BUILD)/bin/libpcre.so"
	rm -f "$(BUILD)/bin/libsql.so"
	rm -f "$(BUILD)/bin/libzlib.so"
	rm -f "$(BUILD)/bin/mvc.es"
	rm -f "$(BUILD)/bin/libmpr-openssl.a"
	rm -f "$(BUILD)/bin/utest"
	rm -f "$(BUILD)/bin/utest.es"
	rm -f "$(BUILD)/bin/utest.worker"
	rm -f "$(BUILD)/bin/ejsman"
	rm -f "$(BUILD)/bin/www"

clobber: clean
	rm -fr ./$(BUILD)

#
#   ejs.cache.local.slots.h
#
DEPS_1 += src/slots/ejs.cache.local.slots.h

$(BUILD)/inc/ejs.cache.local.slots.h: $(DEPS_1)
	@echo '      [Copy] $(BUILD)/inc/ejs.cache.local.slots.h'
	mkdir -p "$(BUILD)/inc"
	cp src/slots/ejs.cache.local.slots.h $(BUILD)/inc/ejs.cache.local.slots.h

#
#   ejs.db.sqlite.slots.h
#
DEPS_2 += src/slots/ejs.db.sqlite.slots.h

$(BUILD)/inc/ejs.db.sqlite.slots.h: $(DEPS_2)
	@echo '      [Copy] $(BUILD)/inc/ejs.db.sqlite.slots.h'
	mkdir -p "$(BUILD)/inc"
	cp src/slots/ejs.db.sqlite.slots.h $(BUILD)/inc/ejs.db.sqlite.slots.h

#
#   me.h
#

$(BUILD)/inc/me.h: $(DEPS_3)

#
#   osdep.h
#
DEPS_4 += src/osdep/osdep.h
DEPS_4 += $(BUILD)/inc/me.h

$(BUILD)/inc/osdep.h: $(DEPS_4)
	@echo '      [Copy] $(BUILD)/inc/osdep.h'
	mkdir -p "$(BUILD)/inc"
	cp src/osdep/osdep.h $(BUILD)/inc/osdep.h

#
#   mpr.h
#
DEPS_5 += src/mpr/mpr.h
DEPS_5 += $(BUILD)/inc/me.h
DEPS_5 += $(BUILD)/inc/osdep.h

$(BUILD)/inc/mpr.h: $(DEPS_5)
	@echo '      [Copy] $(BUILD)/inc/mpr.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mpr/mpr.h $(BUILD)/inc/mpr.h

#
#   http.h
#
DEPS_6 += src/http/http.h
DEPS_6 += $(BUILD)/inc/mpr.h

$(BUILD)/inc/http.h: $(DEPS_6)
	@echo '      [Copy] $(BUILD)/inc/http.h'
	mkdir -p "$(BUILD)/inc"
	cp src/http/http.h $(BUILD)/inc/http.h

#
#   ejsByteCode.h
#

src/ejsByteCode.h: $(DEPS_7)

#
#   ejsByteCodeTable.h
#

src/ejsByteCodeTable.h: $(DEPS_8)

#
#   ejs.slots.h
#
DEPS_9 += src/slots/ejs.slots.h

$(BUILD)/inc/ejs.slots.h: $(DEPS_9)
	@echo '      [Copy] $(BUILD)/inc/ejs.slots.h'
	mkdir -p "$(BUILD)/inc"
	cp src/slots/ejs.slots.h $(BUILD)/inc/ejs.slots.h

#
#   ejsCustomize.h
#

src/ejsCustomize.h: $(DEPS_10)

#
#   ejs.h
#
DEPS_11 += src/ejs.h
DEPS_11 += $(BUILD)/inc/mpr.h
DEPS_11 += $(BUILD)/inc/http.h
DEPS_11 += src/ejsByteCode.h
DEPS_11 += src/ejsByteCodeTable.h
DEPS_11 += $(BUILD)/inc/ejs.slots.h
DEPS_11 += src/ejsCustomize.h

$(BUILD)/inc/ejs.h: $(DEPS_11)
	@echo '      [Copy] $(BUILD)/inc/ejs.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejs.h $(BUILD)/inc/ejs.h

#
#   ejs.web.slots.h
#
DEPS_12 += src/slots/ejs.web.slots.h

$(BUILD)/inc/ejs.web.slots.h: $(DEPS_12)
	@echo '      [Copy] $(BUILD)/inc/ejs.web.slots.h'
	mkdir -p "$(BUILD)/inc"
	cp src/slots/ejs.web.slots.h $(BUILD)/inc/ejs.web.slots.h

#
#   ejs.zlib.slots.h
#
DEPS_13 += src/slots/ejs.zlib.slots.h

$(BUILD)/inc/ejs.zlib.slots.h: $(DEPS_13)
	@echo '      [Copy] $(BUILD)/inc/ejs.zlib.slots.h'
	mkdir -p "$(BUILD)/inc"
	cp src/slots/ejs.zlib.slots.h $(BUILD)/inc/ejs.zlib.slots.h

#
#   ejsByteCode.h
#
DEPS_14 += src/ejsByteCode.h

$(BUILD)/inc/ejsByteCode.h: $(DEPS_14)
	@echo '      [Copy] $(BUILD)/inc/ejsByteCode.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejsByteCode.h $(BUILD)/inc/ejsByteCode.h

#
#   ejsByteCodeTable.h
#
DEPS_15 += src/ejsByteCodeTable.h

$(BUILD)/inc/ejsByteCodeTable.h: $(DEPS_15)
	@echo '      [Copy] $(BUILD)/inc/ejsByteCodeTable.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejsByteCodeTable.h $(BUILD)/inc/ejsByteCodeTable.h

#
#   ejs.h
#

src/ejs.h: $(DEPS_16)

#
#   ejsCompiler.h
#
DEPS_17 += src/ejsCompiler.h
DEPS_17 += src/ejs.h

$(BUILD)/inc/ejsCompiler.h: $(DEPS_17)
	@echo '      [Copy] $(BUILD)/inc/ejsCompiler.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejsCompiler.h $(BUILD)/inc/ejsCompiler.h

#
#   ejsCustomize.h
#
DEPS_18 += src/ejsCustomize.h

$(BUILD)/inc/ejsCustomize.h: $(DEPS_18)
	@echo '      [Copy] $(BUILD)/inc/ejsCustomize.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejsCustomize.h $(BUILD)/inc/ejsCustomize.h

#
#   ejsWeb.h
#
DEPS_19 += src/ejs.web/ejsWeb.h

$(BUILD)/inc/ejsWeb.h: $(DEPS_19)
	@echo '      [Copy] $(BUILD)/inc/ejsWeb.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejs.web/ejsWeb.h $(BUILD)/inc/ejsWeb.h

#
#   ejsmod.h
#
DEPS_20 += src/cmd/ejsmod.h

$(BUILD)/inc/ejsmod.h: $(DEPS_20)
	@echo '      [Copy] $(BUILD)/inc/ejsmod.h'
	mkdir -p "$(BUILD)/inc"
	cp src/cmd/ejsmod.h $(BUILD)/inc/ejsmod.h

#
#   est.h
#
DEPS_21 += src/est/est.h

$(BUILD)/inc/est.h: $(DEPS_21)
	@echo '      [Copy] $(BUILD)/inc/est.h'
	mkdir -p "$(BUILD)/inc"
	cp src/est/est.h $(BUILD)/inc/est.h

#
#   pcre.h
#
DEPS_22 += src/pcre/pcre.h

$(BUILD)/inc/pcre.h: $(DEPS_22)
	@echo '      [Copy] $(BUILD)/inc/pcre.h'
	mkdir -p "$(BUILD)/inc"
	cp src/pcre/pcre.h $(BUILD)/inc/pcre.h

#
#   sqlite3.h
#
DEPS_23 += src/sqlite/sqlite3.h

$(BUILD)/inc/sqlite3.h: $(DEPS_23)
	@echo '      [Copy] $(BUILD)/inc/sqlite3.h'
	mkdir -p "$(BUILD)/inc"
	cp src/sqlite/sqlite3.h $(BUILD)/inc/sqlite3.h

#
#   zlib.h
#
DEPS_24 += src/zlib/zlib.h
DEPS_24 += $(BUILD)/inc/me.h

$(BUILD)/inc/zlib.h: $(DEPS_24)
	@echo '      [Copy] $(BUILD)/inc/zlib.h'
	mkdir -p "$(BUILD)/inc"
	cp src/zlib/zlib.h $(BUILD)/inc/zlib.h

#
#   ejsmod.h
#

src/cmd/ejsmod.h: $(DEPS_25)

#
#   doc.o
#
DEPS_26 += src/cmd/ejsmod.h

$(BUILD)/obj/doc.o: \
    src/cmd/doc.c $(DEPS_26)
	@echo '   [Compile] $(BUILD)/obj/doc.o'
	$(CC) -c -o $(BUILD)/obj/doc.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/doc.c

#
#   docFiles.o
#
DEPS_27 += src/cmd/ejsmod.h

$(BUILD)/obj/docFiles.o: \
    src/cmd/docFiles.c $(DEPS_27)
	@echo '   [Compile] $(BUILD)/obj/docFiles.o'
	$(CC) -c -o $(BUILD)/obj/docFiles.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/docFiles.c

#
#   dtoa.o
#
DEPS_28 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/dtoa.o: \
    src/core/src/dtoa.c $(DEPS_28)
	@echo '   [Compile] $(BUILD)/obj/dtoa.o'
	$(CC) -c -o $(BUILD)/obj/dtoa.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/dtoa.c

#
#   ejsCompiler.h
#

src/ejsCompiler.h: $(DEPS_29)

#
#   ecAst.o
#
DEPS_30 += src/ejsCompiler.h

$(BUILD)/obj/ecAst.o: \
    src/compiler/ecAst.c $(DEPS_30)
	@echo '   [Compile] $(BUILD)/obj/ecAst.o'
	$(CC) -c -o $(BUILD)/obj/ecAst.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecAst.c

#
#   ecCodeGen.o
#
DEPS_31 += src/ejsCompiler.h

$(BUILD)/obj/ecCodeGen.o: \
    src/compiler/ecCodeGen.c $(DEPS_31)
	@echo '   [Compile] $(BUILD)/obj/ecCodeGen.o'
	$(CC) -c -o $(BUILD)/obj/ecCodeGen.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecCodeGen.c

#
#   ecCompiler.o
#
DEPS_32 += src/ejsCompiler.h

$(BUILD)/obj/ecCompiler.o: \
    src/compiler/ecCompiler.c $(DEPS_32)
	@echo '   [Compile] $(BUILD)/obj/ecCompiler.o'
	$(CC) -c -o $(BUILD)/obj/ecCompiler.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecCompiler.c

#
#   ecLex.o
#
DEPS_33 += src/ejsCompiler.h

$(BUILD)/obj/ecLex.o: \
    src/compiler/ecLex.c $(DEPS_33)
	@echo '   [Compile] $(BUILD)/obj/ecLex.o'
	$(CC) -c -o $(BUILD)/obj/ecLex.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecLex.c

#
#   ecModuleWrite.o
#
DEPS_34 += src/ejsCompiler.h

$(BUILD)/obj/ecModuleWrite.o: \
    src/compiler/ecModuleWrite.c $(DEPS_34)
	@echo '   [Compile] $(BUILD)/obj/ecModuleWrite.o'
	$(CC) -c -o $(BUILD)/obj/ecModuleWrite.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecModuleWrite.c

#
#   ecParser.o
#
DEPS_35 += src/ejsCompiler.h

$(BUILD)/obj/ecParser.o: \
    src/compiler/ecParser.c $(DEPS_35)
	@echo '   [Compile] $(BUILD)/obj/ecParser.o'
	$(CC) -c -o $(BUILD)/obj/ecParser.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecParser.c

#
#   ecState.o
#
DEPS_36 += src/ejsCompiler.h

$(BUILD)/obj/ecState.o: \
    src/compiler/ecState.c $(DEPS_36)
	@echo '   [Compile] $(BUILD)/obj/ecState.o'
	$(CC) -c -o $(BUILD)/obj/ecState.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/compiler/ecState.c

#
#   ejs.o
#
DEPS_37 += $(BUILD)/inc/me.h
DEPS_37 += $(BUILD)/inc/ejsCompiler.h

$(BUILD)/obj/ejs.o: \
    src/cmd/ejs.c $(DEPS_37)
	@echo '   [Compile] $(BUILD)/obj/ejs.o'
	$(CC) -c -o $(BUILD)/obj/ejs.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/ejs.c

#
#   ejsApp.o
#
DEPS_38 += src/ejs.h

$(BUILD)/obj/ejsApp.o: \
    src/core/src/ejsApp.c $(DEPS_38)
	@echo '   [Compile] $(BUILD)/obj/ejsApp.o'
	$(CC) -c -o $(BUILD)/obj/ejsApp.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsApp.c

#
#   ejsArray.o
#
DEPS_39 += src/ejs.h

$(BUILD)/obj/ejsArray.o: \
    src/core/src/ejsArray.c $(DEPS_39)
	@echo '   [Compile] $(BUILD)/obj/ejsArray.o'
	$(CC) -c -o $(BUILD)/obj/ejsArray.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsArray.c

#
#   ejsBlock.o
#
DEPS_40 += src/ejs.h

$(BUILD)/obj/ejsBlock.o: \
    src/core/src/ejsBlock.c $(DEPS_40)
	@echo '   [Compile] $(BUILD)/obj/ejsBlock.o'
	$(CC) -c -o $(BUILD)/obj/ejsBlock.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsBlock.c

#
#   ejsBoolean.o
#
DEPS_41 += src/ejs.h

$(BUILD)/obj/ejsBoolean.o: \
    src/core/src/ejsBoolean.c $(DEPS_41)
	@echo '   [Compile] $(BUILD)/obj/ejsBoolean.o'
	$(CC) -c -o $(BUILD)/obj/ejsBoolean.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsBoolean.c

#
#   ejsByteArray.o
#
DEPS_42 += src/ejs.h

$(BUILD)/obj/ejsByteArray.o: \
    src/core/src/ejsByteArray.c $(DEPS_42)
	@echo '   [Compile] $(BUILD)/obj/ejsByteArray.o'
	$(CC) -c -o $(BUILD)/obj/ejsByteArray.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsByteArray.c

#
#   ejsByteCode.o
#
DEPS_43 += src/ejs.h

$(BUILD)/obj/ejsByteCode.o: \
    src/vm/ejsByteCode.c $(DEPS_43)
	@echo '   [Compile] $(BUILD)/obj/ejsByteCode.o'
	$(CC) -c -o $(BUILD)/obj/ejsByteCode.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsByteCode.c

#
#   ejsCache.o
#
DEPS_44 += src/ejs.h

$(BUILD)/obj/ejsCache.o: \
    src/core/src/ejsCache.c $(DEPS_44)
	@echo '   [Compile] $(BUILD)/obj/ejsCache.o'
	$(CC) -c -o $(BUILD)/obj/ejsCache.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsCache.c

#
#   ejsCmd.o
#
DEPS_45 += src/ejs.h

$(BUILD)/obj/ejsCmd.o: \
    src/core/src/ejsCmd.c $(DEPS_45)
	@echo '   [Compile] $(BUILD)/obj/ejsCmd.o'
	$(CC) -c -o $(BUILD)/obj/ejsCmd.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsCmd.c

#
#   ejsConfig.o
#
DEPS_46 += src/ejs.h

$(BUILD)/obj/ejsConfig.o: \
    src/core/src/ejsConfig.c $(DEPS_46)
	@echo '   [Compile] $(BUILD)/obj/ejsConfig.o'
	$(CC) -c -o $(BUILD)/obj/ejsConfig.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsConfig.c

#
#   ejsDate.o
#
DEPS_47 += src/ejs.h

$(BUILD)/obj/ejsDate.o: \
    src/core/src/ejsDate.c $(DEPS_47)
	@echo '   [Compile] $(BUILD)/obj/ejsDate.o'
	$(CC) -c -o $(BUILD)/obj/ejsDate.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsDate.c

#
#   ejsDebug.o
#
DEPS_48 += src/ejs.h

$(BUILD)/obj/ejsDebug.o: \
    src/core/src/ejsDebug.c $(DEPS_48)
	@echo '   [Compile] $(BUILD)/obj/ejsDebug.o'
	$(CC) -c -o $(BUILD)/obj/ejsDebug.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsDebug.c

#
#   ejsError.o
#
DEPS_49 += src/ejs.h

$(BUILD)/obj/ejsError.o: \
    src/core/src/ejsError.c $(DEPS_49)
	@echo '   [Compile] $(BUILD)/obj/ejsError.o'
	$(CC) -c -o $(BUILD)/obj/ejsError.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsError.c

#
#   ejsException.o
#
DEPS_50 += src/ejs.h

$(BUILD)/obj/ejsException.o: \
    src/vm/ejsException.c $(DEPS_50)
	@echo '   [Compile] $(BUILD)/obj/ejsException.o'
	$(CC) -c -o $(BUILD)/obj/ejsException.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsException.c

#
#   ejsFile.o
#
DEPS_51 += src/ejs.h

$(BUILD)/obj/ejsFile.o: \
    src/core/src/ejsFile.c $(DEPS_51)
	@echo '   [Compile] $(BUILD)/obj/ejsFile.o'
	$(CC) -c -o $(BUILD)/obj/ejsFile.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsFile.c

#
#   ejsFileSystem.o
#
DEPS_52 += src/ejs.h

$(BUILD)/obj/ejsFileSystem.o: \
    src/core/src/ejsFileSystem.c $(DEPS_52)
	@echo '   [Compile] $(BUILD)/obj/ejsFileSystem.o'
	$(CC) -c -o $(BUILD)/obj/ejsFileSystem.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsFileSystem.c

#
#   ejsFrame.o
#
DEPS_53 += src/ejs.h

$(BUILD)/obj/ejsFrame.o: \
    src/core/src/ejsFrame.c $(DEPS_53)
	@echo '   [Compile] $(BUILD)/obj/ejsFrame.o'
	$(CC) -c -o $(BUILD)/obj/ejsFrame.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsFrame.c

#
#   ejsFunction.o
#
DEPS_54 += src/ejs.h

$(BUILD)/obj/ejsFunction.o: \
    src/core/src/ejsFunction.c $(DEPS_54)
	@echo '   [Compile] $(BUILD)/obj/ejsFunction.o'
	$(CC) -c -o $(BUILD)/obj/ejsFunction.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsFunction.c

#
#   ejsGC.o
#
DEPS_55 += src/ejs.h

$(BUILD)/obj/ejsGC.o: \
    src/core/src/ejsGC.c $(DEPS_55)
	@echo '   [Compile] $(BUILD)/obj/ejsGC.o'
	$(CC) -c -o $(BUILD)/obj/ejsGC.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsGC.c

#
#   ejsGlobal.o
#
DEPS_56 += src/ejs.h

$(BUILD)/obj/ejsGlobal.o: \
    src/core/src/ejsGlobal.c $(DEPS_56)
	@echo '   [Compile] $(BUILD)/obj/ejsGlobal.o'
	$(CC) -c -o $(BUILD)/obj/ejsGlobal.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsGlobal.c

#
#   ejsHelper.o
#
DEPS_57 += src/ejs.h

$(BUILD)/obj/ejsHelper.o: \
    src/vm/ejsHelper.c $(DEPS_57)
	@echo '   [Compile] $(BUILD)/obj/ejsHelper.o'
	$(CC) -c -o $(BUILD)/obj/ejsHelper.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsHelper.c

#
#   ejsHttp.o
#
DEPS_58 += src/ejs.h

$(BUILD)/obj/ejsHttp.o: \
    src/core/src/ejsHttp.c $(DEPS_58)
	@echo '   [Compile] $(BUILD)/obj/ejsHttp.o'
	$(CC) -c -o $(BUILD)/obj/ejsHttp.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsHttp.c

#
#   ejsWeb.h
#

src/ejs.web/ejsWeb.h: $(DEPS_59)

#
#   ejsHttpServer.o
#
DEPS_60 += $(BUILD)/inc/me.h
DEPS_60 += $(BUILD)/inc/ejs.h
DEPS_60 += $(BUILD)/inc/ejsCompiler.h
DEPS_60 += src/ejs.web/ejsWeb.h
DEPS_60 += $(BUILD)/inc/ejs.web.slots.h

$(BUILD)/obj/ejsHttpServer.o: \
    src/ejs.web/ejsHttpServer.c $(DEPS_60)
	@echo '   [Compile] $(BUILD)/obj/ejsHttpServer.o'
	$(CC) -c -o $(BUILD)/obj/ejsHttpServer.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/ejs.web/ejsHttpServer.c

#
#   ejsInterp.o
#
DEPS_61 += src/ejs.h

$(BUILD)/obj/ejsInterp.o: \
    src/vm/ejsInterp.c $(DEPS_61)
	@echo '   [Compile] $(BUILD)/obj/ejsInterp.o'
	$(CC) -c -o $(BUILD)/obj/ejsInterp.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsInterp.c

#
#   ejsIterator.o
#
DEPS_62 += src/ejs.h

$(BUILD)/obj/ejsIterator.o: \
    src/core/src/ejsIterator.c $(DEPS_62)
	@echo '   [Compile] $(BUILD)/obj/ejsIterator.o'
	$(CC) -c -o $(BUILD)/obj/ejsIterator.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsIterator.c

#
#   ejsJSON.o
#
DEPS_63 += src/ejs.h

$(BUILD)/obj/ejsJSON.o: \
    src/core/src/ejsJSON.c $(DEPS_63)
	@echo '   [Compile] $(BUILD)/obj/ejsJSON.o'
	$(CC) -c -o $(BUILD)/obj/ejsJSON.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsJSON.c

#
#   ejsLoader.o
#
DEPS_64 += src/ejs.h

$(BUILD)/obj/ejsLoader.o: \
    src/vm/ejsLoader.c $(DEPS_64)
	@echo '   [Compile] $(BUILD)/obj/ejsLoader.o'
	$(CC) -c -o $(BUILD)/obj/ejsLoader.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsLoader.c

#
#   ejsLocalCache.o
#
DEPS_65 += src/ejs.h

$(BUILD)/obj/ejsLocalCache.o: \
    src/core/src/ejsLocalCache.c $(DEPS_65)
	@echo '   [Compile] $(BUILD)/obj/ejsLocalCache.o'
	$(CC) -c -o $(BUILD)/obj/ejsLocalCache.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsLocalCache.c

#
#   ejsMath.o
#
DEPS_66 += src/ejs.h

$(BUILD)/obj/ejsMath.o: \
    src/core/src/ejsMath.c $(DEPS_66)
	@echo '   [Compile] $(BUILD)/obj/ejsMath.o'
	$(CC) -c -o $(BUILD)/obj/ejsMath.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsMath.c

#
#   ejsMemory.o
#
DEPS_67 += src/ejs.h

$(BUILD)/obj/ejsMemory.o: \
    src/core/src/ejsMemory.c $(DEPS_67)
	@echo '   [Compile] $(BUILD)/obj/ejsMemory.o'
	$(CC) -c -o $(BUILD)/obj/ejsMemory.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsMemory.c

#
#   ejsModule.o
#
DEPS_68 += src/ejs.h

$(BUILD)/obj/ejsModule.o: \
    src/vm/ejsModule.c $(DEPS_68)
	@echo '   [Compile] $(BUILD)/obj/ejsModule.o'
	$(CC) -c -o $(BUILD)/obj/ejsModule.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsModule.c

#
#   ejsMprLog.o
#
DEPS_69 += src/ejs.h

$(BUILD)/obj/ejsMprLog.o: \
    src/core/src/ejsMprLog.c $(DEPS_69)
	@echo '   [Compile] $(BUILD)/obj/ejsMprLog.o'
	$(CC) -c -o $(BUILD)/obj/ejsMprLog.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsMprLog.c

#
#   ejsNamespace.o
#
DEPS_70 += src/ejs.h

$(BUILD)/obj/ejsNamespace.o: \
    src/core/src/ejsNamespace.c $(DEPS_70)
	@echo '   [Compile] $(BUILD)/obj/ejsNamespace.o'
	$(CC) -c -o $(BUILD)/obj/ejsNamespace.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsNamespace.c

#
#   ejsNull.o
#
DEPS_71 += src/ejs.h

$(BUILD)/obj/ejsNull.o: \
    src/core/src/ejsNull.c $(DEPS_71)
	@echo '   [Compile] $(BUILD)/obj/ejsNull.o'
	$(CC) -c -o $(BUILD)/obj/ejsNull.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsNull.c

#
#   ejsNumber.o
#
DEPS_72 += src/ejs.h

$(BUILD)/obj/ejsNumber.o: \
    src/core/src/ejsNumber.c $(DEPS_72)
	@echo '   [Compile] $(BUILD)/obj/ejsNumber.o'
	$(CC) -c -o $(BUILD)/obj/ejsNumber.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsNumber.c

#
#   ejsObject.o
#
DEPS_73 += src/ejs.h

$(BUILD)/obj/ejsObject.o: \
    src/core/src/ejsObject.c $(DEPS_73)
	@echo '   [Compile] $(BUILD)/obj/ejsObject.o'
	$(CC) -c -o $(BUILD)/obj/ejsObject.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsObject.c

#
#   ejsPath.o
#
DEPS_74 += src/ejs.h
DEPS_74 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/ejsPath.o: \
    src/core/src/ejsPath.c $(DEPS_74)
	@echo '   [Compile] $(BUILD)/obj/ejsPath.o'
	$(CC) -c -o $(BUILD)/obj/ejsPath.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsPath.c

#
#   ejsPot.o
#
DEPS_75 += src/ejs.h

$(BUILD)/obj/ejsPot.o: \
    src/core/src/ejsPot.c $(DEPS_75)
	@echo '   [Compile] $(BUILD)/obj/ejsPot.o'
	$(CC) -c -o $(BUILD)/obj/ejsPot.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsPot.c

#
#   ejsRegExp.o
#
DEPS_76 += src/ejs.h
DEPS_76 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/ejsRegExp.o: \
    src/core/src/ejsRegExp.c $(DEPS_76)
	@echo '   [Compile] $(BUILD)/obj/ejsRegExp.o'
	$(CC) -c -o $(BUILD)/obj/ejsRegExp.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsRegExp.c

#
#   ejsRequest.o
#
DEPS_77 += $(BUILD)/inc/me.h
DEPS_77 += $(BUILD)/inc/ejs.h
DEPS_77 += $(BUILD)/inc/ejsCompiler.h
DEPS_77 += src/ejs.web/ejsWeb.h
DEPS_77 += $(BUILD)/inc/ejs.web.slots.h

$(BUILD)/obj/ejsRequest.o: \
    src/ejs.web/ejsRequest.c $(DEPS_77)
	@echo '   [Compile] $(BUILD)/obj/ejsRequest.o'
	$(CC) -c -o $(BUILD)/obj/ejsRequest.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/ejs.web/ejsRequest.c

#
#   ejsScope.o
#
DEPS_78 += src/ejs.h

$(BUILD)/obj/ejsScope.o: \
    src/vm/ejsScope.c $(DEPS_78)
	@echo '   [Compile] $(BUILD)/obj/ejsScope.o'
	$(CC) -c -o $(BUILD)/obj/ejsScope.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsScope.c

#
#   ejsService.o
#
DEPS_79 += src/ejs.h

$(BUILD)/obj/ejsService.o: \
    src/vm/ejsService.c $(DEPS_79)
	@echo '   [Compile] $(BUILD)/obj/ejsService.o'
	$(CC) -c -o $(BUILD)/obj/ejsService.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/vm/ejsService.c

#
#   ejsSession.o
#
DEPS_80 += $(BUILD)/inc/me.h
DEPS_80 += $(BUILD)/inc/ejs.h
DEPS_80 += src/ejs.web/ejsWeb.h

$(BUILD)/obj/ejsSession.o: \
    src/ejs.web/ejsSession.c $(DEPS_80)
	@echo '   [Compile] $(BUILD)/obj/ejsSession.o'
	$(CC) -c -o $(BUILD)/obj/ejsSession.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/ejs.web/ejsSession.c

#
#   ejsSocket.o
#
DEPS_81 += src/ejs.h

$(BUILD)/obj/ejsSocket.o: \
    src/core/src/ejsSocket.c $(DEPS_81)
	@echo '   [Compile] $(BUILD)/obj/ejsSocket.o'
	$(CC) -c -o $(BUILD)/obj/ejsSocket.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsSocket.c

#
#   ejsSqlite.o
#
DEPS_82 += $(BUILD)/inc/ejs.h
DEPS_82 += $(BUILD)/inc/ejs.db.sqlite.slots.h

$(BUILD)/obj/ejsSqlite.o: \
    src/ejs.db.sqlite/ejsSqlite.c $(DEPS_82)
	@echo '   [Compile] $(BUILD)/obj/ejsSqlite.o'
	$(CC) -c -o $(BUILD)/obj/ejsSqlite.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/ejs.db.sqlite/ejsSqlite.c

#
#   ejsString.o
#
DEPS_83 += src/ejs.h
DEPS_83 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/ejsString.o: \
    src/core/src/ejsString.c $(DEPS_83)
	@echo '   [Compile] $(BUILD)/obj/ejsString.o'
	$(CC) -c -o $(BUILD)/obj/ejsString.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsString.c

#
#   ejsSystem.o
#
DEPS_84 += src/ejs.h

$(BUILD)/obj/ejsSystem.o: \
    src/core/src/ejsSystem.c $(DEPS_84)
	@echo '   [Compile] $(BUILD)/obj/ejsSystem.o'
	$(CC) -c -o $(BUILD)/obj/ejsSystem.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsSystem.c

#
#   ejsTimer.o
#
DEPS_85 += src/ejs.h

$(BUILD)/obj/ejsTimer.o: \
    src/core/src/ejsTimer.c $(DEPS_85)
	@echo '   [Compile] $(BUILD)/obj/ejsTimer.o'
	$(CC) -c -o $(BUILD)/obj/ejsTimer.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsTimer.c

#
#   ejsType.o
#
DEPS_86 += src/ejs.h

$(BUILD)/obj/ejsType.o: \
    src/core/src/ejsType.c $(DEPS_86)
	@echo '   [Compile] $(BUILD)/obj/ejsType.o'
	$(CC) -c -o $(BUILD)/obj/ejsType.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsType.c

#
#   ejsUri.o
#
DEPS_87 += src/ejs.h

$(BUILD)/obj/ejsUri.o: \
    src/core/src/ejsUri.c $(DEPS_87)
	@echo '   [Compile] $(BUILD)/obj/ejsUri.o'
	$(CC) -c -o $(BUILD)/obj/ejsUri.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsUri.c

#
#   ejsVoid.o
#
DEPS_88 += src/ejs.h

$(BUILD)/obj/ejsVoid.o: \
    src/core/src/ejsVoid.c $(DEPS_88)
	@echo '   [Compile] $(BUILD)/obj/ejsVoid.o'
	$(CC) -c -o $(BUILD)/obj/ejsVoid.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsVoid.c

#
#   ejsWeb.o
#
DEPS_89 += $(BUILD)/inc/me.h
DEPS_89 += $(BUILD)/inc/ejs.h
DEPS_89 += $(BUILD)/inc/ejsCompiler.h
DEPS_89 += src/ejs.web/ejsWeb.h
DEPS_89 += $(BUILD)/inc/ejs.web.slots.h

$(BUILD)/obj/ejsWeb.o: \
    src/ejs.web/ejsWeb.c $(DEPS_89)
	@echo '   [Compile] $(BUILD)/obj/ejsWeb.o'
	$(CC) -c -o $(BUILD)/obj/ejsWeb.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/ejs.web/ejsWeb.c

#
#   ejsWebSocket.o
#
DEPS_90 += src/ejs.h

$(BUILD)/obj/ejsWebSocket.o: \
    src/core/src/ejsWebSocket.c $(DEPS_90)
	@echo '   [Compile] $(BUILD)/obj/ejsWebSocket.o'
	$(CC) -c -o $(BUILD)/obj/ejsWebSocket.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsWebSocket.c

#
#   ejsWorker.o
#
DEPS_91 += src/ejs.h

$(BUILD)/obj/ejsWorker.o: \
    src/core/src/ejsWorker.c $(DEPS_91)
	@echo '   [Compile] $(BUILD)/obj/ejsWorker.o'
	$(CC) -c -o $(BUILD)/obj/ejsWorker.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsWorker.c

#
#   ejsXML.o
#
DEPS_92 += src/ejs.h

$(BUILD)/obj/ejsXML.o: \
    src/core/src/ejsXML.c $(DEPS_92)
	@echo '   [Compile] $(BUILD)/obj/ejsXML.o'
	$(CC) -c -o $(BUILD)/obj/ejsXML.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsXML.c

#
#   ejsXMLList.o
#
DEPS_93 += src/ejs.h

$(BUILD)/obj/ejsXMLList.o: \
    src/core/src/ejsXMLList.c $(DEPS_93)
	@echo '   [Compile] $(BUILD)/obj/ejsXMLList.o'
	$(CC) -c -o $(BUILD)/obj/ejsXMLList.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsXMLList.c

#
#   ejsXMLLoader.o
#
DEPS_94 += src/ejs.h

$(BUILD)/obj/ejsXMLLoader.o: \
    src/core/src/ejsXMLLoader.c $(DEPS_94)
	@echo '   [Compile] $(BUILD)/obj/ejsXMLLoader.o'
	$(CC) -c -o $(BUILD)/obj/ejsXMLLoader.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/core/src/ejsXMLLoader.c

#
#   ejsZlib.o
#
DEPS_95 += $(BUILD)/inc/ejs.h
DEPS_95 += $(BUILD)/inc/zlib.h
DEPS_95 += $(BUILD)/inc/ejs.zlib.slots.h

$(BUILD)/obj/ejsZlib.o: \
    src/ejs.zlib/ejsZlib.c $(DEPS_95)
	@echo '   [Compile] $(BUILD)/obj/ejsZlib.o'
	$(CC) -c -o $(BUILD)/obj/ejsZlib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/ejs.zlib/ejsZlib.c

#
#   ejsc.o
#
DEPS_96 += $(BUILD)/inc/ejsCompiler.h

$(BUILD)/obj/ejsc.o: \
    src/cmd/ejsc.c $(DEPS_96)
	@echo '   [Compile] $(BUILD)/obj/ejsc.o'
	$(CC) -c -o $(BUILD)/obj/ejsc.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/ejsc.c

#
#   ejsmod.o
#
DEPS_97 += src/cmd/ejsmod.h

$(BUILD)/obj/ejsmod.o: \
    src/cmd/ejsmod.c $(DEPS_97)
	@echo '   [Compile] $(BUILD)/obj/ejsmod.o'
	$(CC) -c -o $(BUILD)/obj/ejsmod.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/ejsmod.c

#
#   ejsrun.o
#
DEPS_98 += $(BUILD)/inc/ejsCompiler.h

$(BUILD)/obj/ejsrun.o: \
    src/cmd/ejsrun.c $(DEPS_98)
	@echo '   [Compile] $(BUILD)/obj/ejsrun.o'
	$(CC) -c -o $(BUILD)/obj/ejsrun.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/ejsrun.c

#
#   est.o
#
DEPS_99 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/est.o: \
    src/mpr-est/est.c $(DEPS_99)
	@echo '   [Compile] $(BUILD)/obj/est.o'
	$(CC) -c -o $(BUILD)/obj/est.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/mpr-est/est.c

#
#   est.h
#

src/est/est.h: $(DEPS_100)

#
#   estLib.o
#
DEPS_101 += src/est/est.h

$(BUILD)/obj/estLib.o: \
    src/est/estLib.c $(DEPS_101)
	@echo '   [Compile] $(BUILD)/obj/estLib.o'
	$(CC) -c -o $(BUILD)/obj/estLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/est/estLib.c

#
#   http.h
#

src/http/http.h: $(DEPS_102)

#
#   http.o
#
DEPS_103 += src/http/http.h

$(BUILD)/obj/http.o: \
    src/http/http.c $(DEPS_103)
	@echo '   [Compile] $(BUILD)/obj/http.o'
	$(CC) -c -o $(BUILD)/obj/http.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/http/http.c

#
#   httpLib.o
#
DEPS_104 += src/http/http.h
DEPS_104 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/httpLib.o: \
    src/http/httpLib.c $(DEPS_104)
	@echo '   [Compile] $(BUILD)/obj/httpLib.o'
	$(CC) -c -o $(BUILD)/obj/httpLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http/httpLib.c

#
#   listing.o
#
DEPS_105 += src/cmd/ejsmod.h
DEPS_105 += $(BUILD)/inc/ejsByteCodeTable.h

$(BUILD)/obj/listing.o: \
    src/cmd/listing.c $(DEPS_105)
	@echo '   [Compile] $(BUILD)/obj/listing.o'
	$(CC) -c -o $(BUILD)/obj/listing.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/listing.c

#
#   mpr.h
#

src/mpr/mpr.h: $(DEPS_106)

#
#   mprLib.o
#
DEPS_107 += src/mpr/mpr.h

$(BUILD)/obj/mprLib.o: \
    src/mpr/mprLib.c $(DEPS_107)
	@echo '   [Compile] $(BUILD)/obj/mprLib.o'
	$(CC) -c -o $(BUILD)/obj/mprLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr/mprLib.c

#
#   openssl.o
#
DEPS_108 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/openssl.o: \
    src/mpr-openssl/openssl.c $(DEPS_108)
	@echo '   [Compile] $(BUILD)/obj/openssl.o'
	$(CC) -c -o $(BUILD)/obj/openssl.o $(LDFLAGS) $(CFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr-openssl/openssl.c

#
#   pcre.h
#

src/pcre/pcre.h: $(DEPS_109)

#
#   pcre.o
#
DEPS_110 += $(BUILD)/inc/me.h
DEPS_110 += src/pcre/pcre.h

$(BUILD)/obj/pcre.o: \
    src/pcre/pcre.c $(DEPS_110)
	@echo '   [Compile] $(BUILD)/obj/pcre.o'
	$(CC) -c -o $(BUILD)/obj/pcre.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/pcre/pcre.c

#
#   slotGen.o
#
DEPS_111 += src/cmd/ejsmod.h

$(BUILD)/obj/slotGen.o: \
    src/cmd/slotGen.c $(DEPS_111)
	@echo '   [Compile] $(BUILD)/obj/slotGen.o'
	$(CC) -c -o $(BUILD)/obj/slotGen.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cmd/slotGen.c

#
#   sqlite3.h
#

src/sqlite/sqlite3.h: $(DEPS_112)

#
#   sqlite.o
#
DEPS_113 += $(BUILD)/inc/me.h
DEPS_113 += src/sqlite/sqlite3.h

$(BUILD)/obj/sqlite.o: \
    src/sqlite/sqlite.c $(DEPS_113)
	@echo '   [Compile] $(BUILD)/obj/sqlite.o'
	$(CC) -c -o $(BUILD)/obj/sqlite.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/sqlite/sqlite.c

#
#   sqlite3.o
#
DEPS_114 += $(BUILD)/inc/me.h
DEPS_114 += src/sqlite/sqlite3.h

$(BUILD)/obj/sqlite3.o: \
    src/sqlite/sqlite3.c $(DEPS_114)
	@echo '   [Compile] $(BUILD)/obj/sqlite3.o'
	$(CC) -c -o $(BUILD)/obj/sqlite3.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/sqlite/sqlite3.c

#
#   watchdog.o
#
DEPS_115 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/watchdog.o: \
    src/watchdog/watchdog.c $(DEPS_115)
	@echo '   [Compile] $(BUILD)/obj/watchdog.o'
	$(CC) -c -o $(BUILD)/obj/watchdog.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/watchdog/watchdog.c

#
#   zlib.h
#

src/zlib/zlib.h: $(DEPS_116)

#
#   zlib.o
#
DEPS_117 += $(BUILD)/inc/me.h
DEPS_117 += src/zlib/zlib.h

$(BUILD)/obj/zlib.o: \
    src/zlib/zlib.c $(DEPS_117)
	@echo '   [Compile] $(BUILD)/obj/zlib.o'
	$(CC) -c -o $(BUILD)/obj/zlib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/zlib/zlib.c

#
#   slots
#

slots: $(DEPS_118)

ifeq ($(ME_COM_SSL),1)
#
#   openssl
#
DEPS_119 += $(BUILD)/obj/openssl.o

$(BUILD)/bin/libmpr-openssl.a: $(DEPS_119)
	@echo '      [Link] $(BUILD)/bin/libmpr-openssl.a'
	ar -cr $(BUILD)/bin/libmpr-openssl.a "$(BUILD)/obj/openssl.o"
endif

ifeq ($(ME_COM_EST),1)
#
#   libest
#
DEPS_120 += $(BUILD)/inc/osdep.h
DEPS_120 += $(BUILD)/inc/est.h
DEPS_120 += $(BUILD)/obj/estLib.o

$(BUILD)/bin/libest.a: $(DEPS_120)
	@echo '      [Link] $(BUILD)/bin/libest.a'
	ar -cr $(BUILD)/bin/libest.a "$(BUILD)/obj/estLib.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   est
#
ifeq ($(ME_COM_EST),1)
    DEPS_121 += $(BUILD)/bin/libest.a
endif
DEPS_121 += $(BUILD)/obj/est.o

$(BUILD)/bin/libmpr-estssl.a: $(DEPS_121)
	@echo '      [Link] $(BUILD)/bin/libmpr-estssl.a'
	ar -cr $(BUILD)/bin/libmpr-estssl.a "$(BUILD)/obj/est.o"
endif

#
#   libmpr
#
DEPS_122 += $(BUILD)/inc/osdep.h
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_OPENSSL),1)
    DEPS_122 += $(BUILD)/bin/libmpr-openssl.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_EST),1)
    DEPS_122 += $(BUILD)/bin/libmpr-estssl.a
endif
endif
DEPS_122 += $(BUILD)/inc/mpr.h
DEPS_122 += $(BUILD)/obj/mprLib.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_122 += -lmpr-openssl
    LIBPATHS_122 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_122 += -lssl
    LIBPATHS_122 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_122 += -lcrypto
    LIBPATHS_122 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_122 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_122 += -lmpr-estssl
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_122 += -lmpr-openssl
    LIBPATHS_122 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/libmpr.so: $(DEPS_122)
	@echo '      [Link] $(BUILD)/bin/libmpr.so'
	$(CC) -shared -o $(BUILD)/bin/libmpr.so $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/mprLib.o" $(LIBPATHS_122) $(LIBS_122) $(LIBS_122) $(LIBS) 

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_123 += $(BUILD)/inc/pcre.h
DEPS_123 += $(BUILD)/obj/pcre.o

$(BUILD)/bin/libpcre.so: $(DEPS_123)
	@echo '      [Link] $(BUILD)/bin/libpcre.so'
	$(CC) -shared -o $(BUILD)/bin/libpcre.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/pcre.o" $(LIBS) 
endif

ifeq ($(ME_COM_HTTP),1)
#
#   libhttp
#
DEPS_124 += $(BUILD)/bin/libmpr.so
ifeq ($(ME_COM_PCRE),1)
    DEPS_124 += $(BUILD)/bin/libpcre.so
endif
DEPS_124 += $(BUILD)/inc/http.h
DEPS_124 += $(BUILD)/obj/httpLib.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_124 += -lmpr-openssl
    LIBPATHS_124 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_124 += -lssl
    LIBPATHS_124 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_124 += -lcrypto
    LIBPATHS_124 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_124 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_124 += -lmpr-estssl
endif
LIBS_124 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_124 += -lmpr-openssl
    LIBPATHS_124 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_124 += -lpcre
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_124 += -lpcre
endif
LIBS_124 += -lmpr

$(BUILD)/bin/libhttp.so: $(DEPS_124)
	@echo '      [Link] $(BUILD)/bin/libhttp.so'
	$(CC) -shared -o $(BUILD)/bin/libhttp.so $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/httpLib.o" $(LIBPATHS_124) $(LIBS_124) $(LIBS_124) $(LIBS) 
endif

#
#   libejs
#
DEPS_125 += slots
ifeq ($(ME_COM_HTTP),1)
    DEPS_125 += $(BUILD)/bin/libhttp.so
endif
DEPS_125 += $(BUILD)/inc/ejs.cache.local.slots.h
DEPS_125 += $(BUILD)/inc/ejs.db.sqlite.slots.h
DEPS_125 += $(BUILD)/inc/ejs.slots.h
DEPS_125 += $(BUILD)/inc/ejs.web.slots.h
DEPS_125 += $(BUILD)/inc/ejs.zlib.slots.h
DEPS_125 += $(BUILD)/inc/ejs.h
DEPS_125 += $(BUILD)/inc/ejsByteCode.h
DEPS_125 += $(BUILD)/inc/ejsByteCodeTable.h
DEPS_125 += $(BUILD)/inc/ejsCompiler.h
DEPS_125 += $(BUILD)/inc/ejsCustomize.h
DEPS_125 += $(BUILD)/obj/ecAst.o
DEPS_125 += $(BUILD)/obj/ecCodeGen.o
DEPS_125 += $(BUILD)/obj/ecCompiler.o
DEPS_125 += $(BUILD)/obj/ecLex.o
DEPS_125 += $(BUILD)/obj/ecModuleWrite.o
DEPS_125 += $(BUILD)/obj/ecParser.o
DEPS_125 += $(BUILD)/obj/ecState.o
DEPS_125 += $(BUILD)/obj/dtoa.o
DEPS_125 += $(BUILD)/obj/ejsApp.o
DEPS_125 += $(BUILD)/obj/ejsArray.o
DEPS_125 += $(BUILD)/obj/ejsBlock.o
DEPS_125 += $(BUILD)/obj/ejsBoolean.o
DEPS_125 += $(BUILD)/obj/ejsByteArray.o
DEPS_125 += $(BUILD)/obj/ejsCache.o
DEPS_125 += $(BUILD)/obj/ejsCmd.o
DEPS_125 += $(BUILD)/obj/ejsConfig.o
DEPS_125 += $(BUILD)/obj/ejsDate.o
DEPS_125 += $(BUILD)/obj/ejsDebug.o
DEPS_125 += $(BUILD)/obj/ejsError.o
DEPS_125 += $(BUILD)/obj/ejsFile.o
DEPS_125 += $(BUILD)/obj/ejsFileSystem.o
DEPS_125 += $(BUILD)/obj/ejsFrame.o
DEPS_125 += $(BUILD)/obj/ejsFunction.o
DEPS_125 += $(BUILD)/obj/ejsGC.o
DEPS_125 += $(BUILD)/obj/ejsGlobal.o
DEPS_125 += $(BUILD)/obj/ejsHttp.o
DEPS_125 += $(BUILD)/obj/ejsIterator.o
DEPS_125 += $(BUILD)/obj/ejsJSON.o
DEPS_125 += $(BUILD)/obj/ejsLocalCache.o
DEPS_125 += $(BUILD)/obj/ejsMath.o
DEPS_125 += $(BUILD)/obj/ejsMemory.o
DEPS_125 += $(BUILD)/obj/ejsMprLog.o
DEPS_125 += $(BUILD)/obj/ejsNamespace.o
DEPS_125 += $(BUILD)/obj/ejsNull.o
DEPS_125 += $(BUILD)/obj/ejsNumber.o
DEPS_125 += $(BUILD)/obj/ejsObject.o
DEPS_125 += $(BUILD)/obj/ejsPath.o
DEPS_125 += $(BUILD)/obj/ejsPot.o
DEPS_125 += $(BUILD)/obj/ejsRegExp.o
DEPS_125 += $(BUILD)/obj/ejsSocket.o
DEPS_125 += $(BUILD)/obj/ejsString.o
DEPS_125 += $(BUILD)/obj/ejsSystem.o
DEPS_125 += $(BUILD)/obj/ejsTimer.o
DEPS_125 += $(BUILD)/obj/ejsType.o
DEPS_125 += $(BUILD)/obj/ejsUri.o
DEPS_125 += $(BUILD)/obj/ejsVoid.o
DEPS_125 += $(BUILD)/obj/ejsWebSocket.o
DEPS_125 += $(BUILD)/obj/ejsWorker.o
DEPS_125 += $(BUILD)/obj/ejsXML.o
DEPS_125 += $(BUILD)/obj/ejsXMLList.o
DEPS_125 += $(BUILD)/obj/ejsXMLLoader.o
DEPS_125 += $(BUILD)/obj/ejsByteCode.o
DEPS_125 += $(BUILD)/obj/ejsException.o
DEPS_125 += $(BUILD)/obj/ejsHelper.o
DEPS_125 += $(BUILD)/obj/ejsInterp.o
DEPS_125 += $(BUILD)/obj/ejsLoader.o
DEPS_125 += $(BUILD)/obj/ejsModule.o
DEPS_125 += $(BUILD)/obj/ejsScope.o
DEPS_125 += $(BUILD)/obj/ejsService.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_125 += -lmpr-openssl
    LIBPATHS_125 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_125 += -lssl
    LIBPATHS_125 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_125 += -lcrypto
    LIBPATHS_125 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_125 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_125 += -lmpr-estssl
endif
LIBS_125 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_125 += -lmpr-openssl
    LIBPATHS_125 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_125 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_125 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_125 += -lpcre
endif
LIBS_125 += -lmpr
ifeq ($(ME_COM_HTTP),1)
    LIBS_125 += -lhttp
endif

$(BUILD)/bin/libejs.so: $(DEPS_125)
	@echo '      [Link] $(BUILD)/bin/libejs.so'
	$(CC) -shared -o $(BUILD)/bin/libejs.so $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ecAst.o" "$(BUILD)/obj/ecCodeGen.o" "$(BUILD)/obj/ecCompiler.o" "$(BUILD)/obj/ecLex.o" "$(BUILD)/obj/ecModuleWrite.o" "$(BUILD)/obj/ecParser.o" "$(BUILD)/obj/ecState.o" "$(BUILD)/obj/dtoa.o" "$(BUILD)/obj/ejsApp.o" "$(BUILD)/obj/ejsArray.o" "$(BUILD)/obj/ejsBlock.o" "$(BUILD)/obj/ejsBoolean.o" "$(BUILD)/obj/ejsByteArray.o" "$(BUILD)/obj/ejsCache.o" "$(BUILD)/obj/ejsCmd.o" "$(BUILD)/obj/ejsConfig.o" "$(BUILD)/obj/ejsDate.o" "$(BUILD)/obj/ejsDebug.o" "$(BUILD)/obj/ejsError.o" "$(BUILD)/obj/ejsFile.o" "$(BUILD)/obj/ejsFileSystem.o" "$(BUILD)/obj/ejsFrame.o" "$(BUILD)/obj/ejsFunction.o" "$(BUILD)/obj/ejsGC.o" "$(BUILD)/obj/ejsGlobal.o" "$(BUILD)/obj/ejsHttp.o" "$(BUILD)/obj/ejsIterator.o" "$(BUILD)/obj/ejsJSON.o" "$(BUILD)/obj/ejsLocalCache.o" "$(BUILD)/obj/ejsMath.o" "$(BUILD)/obj/ejsMemory.o" "$(BUILD)/obj/ejsMprLog.o" "$(BUILD)/obj/ejsNamespace.o" "$(BUILD)/obj/ejsNull.o" "$(BUILD)/obj/ejsNumber.o" "$(BUILD)/obj/ejsObject.o" "$(BUILD)/obj/ejsPath.o" "$(BUILD)/obj/ejsPot.o" "$(BUILD)/obj/ejsRegExp.o" "$(BUILD)/obj/ejsSocket.o" "$(BUILD)/obj/ejsString.o" "$(BUILD)/obj/ejsSystem.o" "$(BUILD)/obj/ejsTimer.o" "$(BUILD)/obj/ejsType.o" "$(BUILD)/obj/ejsUri.o" "$(BUILD)/obj/ejsVoid.o" "$(BUILD)/obj/ejsWebSocket.o" "$(BUILD)/obj/ejsWorker.o" "$(BUILD)/obj/ejsXML.o" "$(BUILD)/obj/ejsXMLList.o" "$(BUILD)/obj/ejsXMLLoader.o" "$(BUILD)/obj/ejsByteCode.o" "$(BUILD)/obj/ejsException.o" "$(BUILD)/obj/ejsHelper.o" "$(BUILD)/obj/ejsInterp.o" "$(BUILD)/obj/ejsLoader.o" "$(BUILD)/obj/ejsModule.o" "$(BUILD)/obj/ejsScope.o" "$(BUILD)/obj/ejsService.o" $(LIBPATHS_125) $(LIBS_125) $(LIBS_125) $(LIBS) 

#
#   ejs
#
DEPS_126 += $(BUILD)/bin/libejs.so
DEPS_126 += $(BUILD)/obj/ejs.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_126 += -lmpr-openssl
    LIBPATHS_126 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_126 += -lssl
    LIBPATHS_126 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_126 += -lcrypto
    LIBPATHS_126 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_126 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_126 += -lmpr-estssl
endif
LIBS_126 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_126 += -lmpr-openssl
    LIBPATHS_126 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_126 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_126 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_126 += -lpcre
endif
LIBS_126 += -lmpr
LIBS_126 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_126 += -lhttp
endif

$(BUILD)/bin/ejs: $(DEPS_126)
	@echo '      [Link] $(BUILD)/bin/ejs'
	$(CC) -o $(BUILD)/bin/ejs $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejs.o" $(LIBPATHS_126) $(LIBS_126) $(LIBS_126) $(LIBS) $(LIBS) 

#
#   ejsc
#
DEPS_127 += $(BUILD)/bin/libejs.so
DEPS_127 += $(BUILD)/obj/ejsc.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_127 += -lmpr-openssl
    LIBPATHS_127 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_127 += -lssl
    LIBPATHS_127 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_127 += -lcrypto
    LIBPATHS_127 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_127 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_127 += -lmpr-estssl
endif
LIBS_127 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_127 += -lmpr-openssl
    LIBPATHS_127 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_127 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_127 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_127 += -lpcre
endif
LIBS_127 += -lmpr
LIBS_127 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_127 += -lhttp
endif

$(BUILD)/bin/ejsc: $(DEPS_127)
	@echo '      [Link] $(BUILD)/bin/ejsc'
	$(CC) -o $(BUILD)/bin/ejsc $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsc.o" $(LIBPATHS_127) $(LIBS_127) $(LIBS_127) $(LIBS) $(LIBS) 

#
#   ejsmod
#
DEPS_128 += $(BUILD)/bin/libejs.so
DEPS_128 += $(BUILD)/inc/ejsmod.h
DEPS_128 += $(BUILD)/obj/ejsmod.o
DEPS_128 += $(BUILD)/obj/doc.o
DEPS_128 += $(BUILD)/obj/docFiles.o
DEPS_128 += $(BUILD)/obj/listing.o
DEPS_128 += $(BUILD)/obj/slotGen.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_128 += -lmpr-openssl
    LIBPATHS_128 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_128 += -lssl
    LIBPATHS_128 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_128 += -lcrypto
    LIBPATHS_128 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_128 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_128 += -lmpr-estssl
endif
LIBS_128 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_128 += -lmpr-openssl
    LIBPATHS_128 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_128 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_128 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_128 += -lpcre
endif
LIBS_128 += -lmpr
LIBS_128 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_128 += -lhttp
endif

$(BUILD)/bin/ejsmod: $(DEPS_128)
	@echo '      [Link] $(BUILD)/bin/ejsmod'
	$(CC) -o $(BUILD)/bin/ejsmod $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsmod.o" "$(BUILD)/obj/doc.o" "$(BUILD)/obj/docFiles.o" "$(BUILD)/obj/listing.o" "$(BUILD)/obj/slotGen.o" $(LIBPATHS_128) $(LIBS_128) $(LIBS_128) $(LIBS) $(LIBS) 

#
#   ejs.mod
#
DEPS_129 += src/core/App.es
DEPS_129 += src/core/Args.es
DEPS_129 += src/core/Array.es
DEPS_129 += src/core/BinaryStream.es
DEPS_129 += src/core/Block.es
DEPS_129 += src/core/Boolean.es
DEPS_129 += src/core/ByteArray.es
DEPS_129 += src/core/Cache.es
DEPS_129 += src/core/Cmd.es
DEPS_129 += src/core/Compat.es
DEPS_129 += src/core/Config.es
DEPS_129 += src/core/Date.es
DEPS_129 += src/core/Debug.es
DEPS_129 += src/core/Emitter.es
DEPS_129 += src/core/Error.es
DEPS_129 += src/core/File.es
DEPS_129 += src/core/FileSystem.es
DEPS_129 += src/core/Frame.es
DEPS_129 += src/core/Function.es
DEPS_129 += src/core/GC.es
DEPS_129 += src/core/Global.es
DEPS_129 += src/core/Http.es
DEPS_129 += src/core/Inflector.es
DEPS_129 += src/core/Iterator.es
DEPS_129 += src/core/JSON.es
DEPS_129 += src/core/Loader.es
DEPS_129 += src/core/LocalCache.es
DEPS_129 += src/core/Locale.es
DEPS_129 += src/core/Logger.es
DEPS_129 += src/core/Math.es
DEPS_129 += src/core/Memory.es
DEPS_129 += src/core/MprLog.es
DEPS_129 += src/core/Name.es
DEPS_129 += src/core/Namespace.es
DEPS_129 += src/core/Null.es
DEPS_129 += src/core/Number.es
DEPS_129 += src/core/Object.es
DEPS_129 += src/core/Path.es
DEPS_129 += src/core/Promise.es
DEPS_129 += src/core/RegExp.es
DEPS_129 += src/core/Socket.es
DEPS_129 += src/core/Stream.es
DEPS_129 += src/core/String.es
DEPS_129 += src/core/System.es
DEPS_129 += src/core/TextStream.es
DEPS_129 += src/core/Timer.es
DEPS_129 += src/core/Type.es
DEPS_129 += src/core/Uri.es
DEPS_129 += src/core/Void.es
DEPS_129 += src/core/WebSocket.es
DEPS_129 += src/core/Worker.es
DEPS_129 += src/core/XML.es
DEPS_129 += src/core/XMLHttp.es
DEPS_129 += src/core/XMLList.es
DEPS_129 += $(BUILD)/bin/ejsc
DEPS_129 += $(BUILD)/bin/ejsmod

$(BUILD)/bin/ejs.mod: $(DEPS_129)
	( \
	cd src/core; \
	echo '   [Compile] Core EJS classes' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.mod"  --optimize 9 --bind --require null App.es Args.es Array.es BinaryStream.es Block.es Boolean.es ByteArray.es Cache.es Cmd.es Compat.es Config.es Date.es Debug.es Emitter.es Error.es File.es FileSystem.es Frame.es Function.es GC.es Global.es Http.es Inflector.es Iterator.es JSON.es Loader.es LocalCache.es Locale.es Logger.es Math.es Memory.es MprLog.es Name.es Namespace.es Null.es Number.es Object.es Path.es Promise.es RegExp.es Socket.es Stream.es String.es System.es TextStream.es Timer.es Type.es Uri.es Void.es WebSocket.es Worker.es XML.es XMLHttp.es XMLList.es ; \
	"../../$(BUILD)/bin/ejsmod" --cslots --dir "../../$(BUILD)/inc" --require null "../../$(BUILD)/bin/ejs.mod" ; \
	)

#
#   ejs.db.mod
#
DEPS_130 += src/ejs.db/Database.es
DEPS_130 += src/ejs.db/DatabaseConnector.es
DEPS_130 += $(BUILD)/bin/ejsc
DEPS_130 += $(BUILD)/bin/ejs.mod

$(BUILD)/bin/ejs.db.mod: $(DEPS_130)
	( \
	cd src/ejs.db; \
	echo '   [Compile] ejs.db.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.db.mod"  --optimize 9 Database.es DatabaseConnector.es ; \
	)

#
#   ejs.db.mapper.mod
#
DEPS_131 += src/ejs.db.mapper/Record.es
DEPS_131 += $(BUILD)/bin/ejsc
DEPS_131 += $(BUILD)/bin/ejs.mod
DEPS_131 += $(BUILD)/bin/ejs.db.mod

$(BUILD)/bin/ejs.db.mapper.mod: $(DEPS_131)
	( \
	cd src/ejs.db.mapper; \
	echo '   [Compile] ejs.db.mapper.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.db.mapper.mod"  --optimize 9 Record.es ; \
	)

#
#   ejs.db.sqlite.mod
#
DEPS_132 += src/ejs.db.sqlite/Sqlite.es
DEPS_132 += $(BUILD)/bin/ejsc
DEPS_132 += $(BUILD)/bin/ejsmod
DEPS_132 += $(BUILD)/bin/ejs.mod

$(BUILD)/bin/ejs.db.sqlite.mod: $(DEPS_132)
	( \
	cd src/ejs.db.sqlite; \
	echo '   [Compile] ejs.db.sqlite.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.db.sqlite.mod"  --optimize 9 Sqlite.es ; \
	"../../$(BUILD)/bin/ejsmod" --cslots --dir "../../$(BUILD)/bin" "../../$(BUILD)/bin/ejs.db.sqlite.mod" ; \
	)

#
#   ejs.mail.mod
#
DEPS_133 += src/ejs.mail/Mail.es
DEPS_133 += $(BUILD)/bin/ejsc
DEPS_133 += $(BUILD)/bin/ejs.mod

$(BUILD)/bin/ejs.mail.mod: $(DEPS_133)
	( \
	cd src/ejs.mail; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.mail.mod"  --optimize 9 Mail.es ; \
	)

#
#   ejs.web.mod
#
DEPS_134 += src/ejs.web/Cascade.es
DEPS_134 += src/ejs.web/CommonLog.es
DEPS_134 += src/ejs.web/ContentType.es
DEPS_134 += src/ejs.web/Controller.es
DEPS_134 += src/ejs.web/Dir.es
DEPS_134 += src/ejs.web/Google.es
DEPS_134 += src/ejs.web/Head.es
DEPS_134 += src/ejs.web/Html.es
DEPS_134 += src/ejs.web/HttpServer.es
DEPS_134 += src/ejs.web/MethodOverride.es
DEPS_134 += src/ejs.web/Middleware.es
DEPS_134 += src/ejs.web/Mvc.es
DEPS_134 += src/ejs.web/Request.es
DEPS_134 += src/ejs.web/Router.es
DEPS_134 += src/ejs.web/Script.es
DEPS_134 += src/ejs.web/Session.es
DEPS_134 += src/ejs.web/ShowExceptions.es
DEPS_134 += src/ejs.web/Static.es
DEPS_134 += src/ejs.web/Template.es
DEPS_134 += src/ejs.web/UploadFile.es
DEPS_134 += src/ejs.web/UrlMap.es
DEPS_134 += src/ejs.web/Utils.es
DEPS_134 += src/ejs.web/View.es
DEPS_134 += $(BUILD)/bin/ejsc
DEPS_134 += $(BUILD)/bin/ejsmod
DEPS_134 += $(BUILD)/bin/ejs.mod

$(BUILD)/bin/ejs.web.mod: $(DEPS_134)
	( \
	cd src/ejs.web; \
	echo '   [Compile] ejs.web.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.web.mod"  --optimize 9 Cascade.es CommonLog.es ContentType.es Controller.es Dir.es Google.es Head.es Html.es HttpServer.es MethodOverride.es Middleware.es Mvc.es Request.es Router.es Script.es Session.es ShowExceptions.es Static.es Template.es UploadFile.es UrlMap.es Utils.es View.es ; \
	"../../$(BUILD)/bin/ejsmod" --cslots --dir "../../$(BUILD)/bin" "../../$(BUILD)/bin/ejs.web.mod" ; \
	)

#
#   ejs.template.mod
#
DEPS_135 += src/ejs.template/TemplateParser.es
DEPS_135 += $(BUILD)/bin/ejsc
DEPS_135 += $(BUILD)/bin/ejs.mod

$(BUILD)/bin/ejs.template.mod: $(DEPS_135)
	( \
	cd src/ejs.template; \
	echo '   [Compile] ejs.template.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.template.mod"  --optimize 9 TemplateParser.es ; \
	)

#
#   ejs.unix.mod
#
DEPS_136 += src/ejs.unix/Unix.es
DEPS_136 += $(BUILD)/bin/ejsc
DEPS_136 += $(BUILD)/bin/ejs.mod

$(BUILD)/bin/ejs.unix.mod: $(DEPS_136)
	( \
	cd src/ejs.unix; \
	echo '   [Compile] ejs.unix.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.unix.mod"  --optimize 9 Unix.es ; \
	)

#
#   ejs.mvc.mod
#
DEPS_137 += src/ejs.mvc/mvc.es
DEPS_137 += $(BUILD)/bin/ejsc
DEPS_137 += $(BUILD)/bin/ejs.mod
DEPS_137 += $(BUILD)/bin/ejs.web.mod
DEPS_137 += $(BUILD)/bin/ejs.template.mod
DEPS_137 += $(BUILD)/bin/ejs.unix.mod

$(BUILD)/bin/ejs.mvc.mod: $(DEPS_137)
	( \
	cd src/ejs.mvc; \
	echo '   [Compile] ejs.mvc.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.mvc.mod"  --optimize 9 mvc.es ; \
	)

ifeq ($(ME_COM_ZLIB),1)
#
#   libzlib
#
DEPS_138 += $(BUILD)/inc/zlib.h
DEPS_138 += $(BUILD)/obj/zlib.o

$(BUILD)/bin/libzlib.so: $(DEPS_138)
	@echo '      [Link] $(BUILD)/bin/libzlib.so'
	$(CC) -shared -o $(BUILD)/bin/libzlib.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/zlib.o" $(LIBS) 
endif

#
#   libejs.zlib
#
DEPS_139 += $(BUILD)/bin/libejs.so
DEPS_139 += $(BUILD)/bin/ejs.mod
ifeq ($(ME_COM_ZLIB),1)
    DEPS_139 += $(BUILD)/bin/libzlib.so
endif
DEPS_139 += $(BUILD)/obj/ejsZlib.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_139 += -lmpr-openssl
    LIBPATHS_139 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_139 += -lssl
    LIBPATHS_139 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_139 += -lcrypto
    LIBPATHS_139 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_139 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_139 += -lmpr-estssl
endif
LIBS_139 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_139 += -lmpr-openssl
    LIBPATHS_139 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_139 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_139 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_139 += -lpcre
endif
LIBS_139 += -lmpr
LIBS_139 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_139 += -lhttp
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_139 += -lzlib
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_139 += -lzlib
endif
LIBS_139 += -lejs

$(BUILD)/bin/libejs.zlib.so: $(DEPS_139)
	@echo '      [Link] $(BUILD)/bin/libejs.zlib.so'
	$(CC) -shared -o $(BUILD)/bin/libejs.zlib.so $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsZlib.o" $(LIBPATHS_139) $(LIBS_139) $(LIBS_139) $(LIBS) 

#
#   ejs.zlib.mod
#
DEPS_140 += src/ejs.zlib/Zlib.es
DEPS_140 += $(BUILD)/bin/ejsc
DEPS_140 += $(BUILD)/bin/ejs.mod
DEPS_140 += $(BUILD)/bin/libejs.zlib.so

$(BUILD)/bin/ejs.zlib.mod: $(DEPS_140)
	( \
	cd src/ejs.zlib; \
	echo '   [Compile] ejs.zlib.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.zlib.mod"  --optimize 9 Zlib.es ; \
	)

#
#   ejs.tar.mod
#
DEPS_141 += src/ejs.tar/Tar.es
DEPS_141 += $(BUILD)/bin/ejsc
DEPS_141 += $(BUILD)/bin/ejs.mod
DEPS_141 += $(BUILD)/bin/ejs.zlib.mod
DEPS_141 += $(BUILD)/bin/libejs.zlib.so

$(BUILD)/bin/ejs.tar.mod: $(DEPS_141)
	( \
	cd src/ejs.tar; \
	echo '   [Compile] ejs.tar.mod' ; \
	"../../$(BUILD)/bin/ejsc" --out "../../$(BUILD)/bin/ejs.tar.mod"  --optimize 9 Tar.es ; \
	)

#
#   ejsrun
#
DEPS_142 += $(BUILD)/bin/libejs.so
DEPS_142 += $(BUILD)/obj/ejsrun.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_142 += -lmpr-openssl
    LIBPATHS_142 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_142 += -lssl
    LIBPATHS_142 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_142 += -lcrypto
    LIBPATHS_142 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_142 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_142 += -lmpr-estssl
endif
LIBS_142 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_142 += -lmpr-openssl
    LIBPATHS_142 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_142 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_142 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_142 += -lpcre
endif
LIBS_142 += -lmpr
LIBS_142 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_142 += -lhttp
endif

$(BUILD)/bin/ejsrun: $(DEPS_142)
	@echo '      [Link] $(BUILD)/bin/ejsrun'
	$(CC) -o $(BUILD)/bin/ejsrun $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsrun.o" $(LIBPATHS_142) $(LIBS_142) $(LIBS_142) $(LIBS) $(LIBS) 

ifeq ($(ME_COM_HTTP),1)
#
#   httpcmd
#
DEPS_143 += $(BUILD)/bin/libhttp.so
DEPS_143 += $(BUILD)/obj/http.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_143 += -lmpr-openssl
    LIBPATHS_143 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_143 += -lssl
    LIBPATHS_143 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_143 += -lcrypto
    LIBPATHS_143 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_143 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_143 += -lmpr-estssl
endif
LIBS_143 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_143 += -lmpr-openssl
    LIBPATHS_143 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_143 += -lpcre
endif
LIBS_143 += -lhttp
ifeq ($(ME_COM_PCRE),1)
    LIBS_143 += -lpcre
endif
LIBS_143 += -lmpr

$(BUILD)/bin/http: $(DEPS_143)
	@echo '      [Link] $(BUILD)/bin/http'
	$(CC) -o $(BUILD)/bin/http $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/http.o" $(LIBPATHS_143) $(LIBS_143) $(LIBS_143) $(LIBS) $(LIBS) 
endif

ifeq ($(ME_COM_SSL),1)
#
#   install-certs
#
DEPS_144 += src/certs/samples/ca.crt
DEPS_144 += src/certs/samples/ca.key
DEPS_144 += src/certs/samples/dh.pem
DEPS_144 += src/certs/samples/ec.crt
DEPS_144 += src/certs/samples/ec.key
DEPS_144 += src/certs/samples/roots.crt
DEPS_144 += src/certs/samples/self.crt
DEPS_144 += src/certs/samples/self.key
DEPS_144 += src/certs/samples/test.crt
DEPS_144 += src/certs/samples/test.key

$(BUILD)/bin: $(DEPS_144)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/certs/samples/ca.crt $(BUILD)/bin/ca.crt
	cp src/certs/samples/ca.key $(BUILD)/bin/ca.key
	cp src/certs/samples/dh.pem $(BUILD)/bin/dh.pem
	cp src/certs/samples/ec.crt $(BUILD)/bin/ec.crt
	cp src/certs/samples/ec.key $(BUILD)/bin/ec.key
	cp src/certs/samples/roots.crt $(BUILD)/bin/roots.crt
	cp src/certs/samples/self.crt $(BUILD)/bin/self.crt
	cp src/certs/samples/self.key $(BUILD)/bin/self.key
	cp src/certs/samples/test.crt $(BUILD)/bin/test.crt
	cp src/certs/samples/test.key $(BUILD)/bin/test.key
endif

ifeq ($(ME_COM_SQLITE),1)
#
#   libsql
#
DEPS_145 += $(BUILD)/inc/sqlite3.h
DEPS_145 += $(BUILD)/obj/sqlite3.o

$(BUILD)/bin/libsql.so: $(DEPS_145)
	@echo '      [Link] $(BUILD)/bin/libsql.so'
	$(CC) -shared -o $(BUILD)/bin/libsql.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/sqlite3.o" $(LIBS) 
endif

#
#   libejs.db.sqlite
#
DEPS_146 += $(BUILD)/bin/libmpr.so
DEPS_146 += $(BUILD)/bin/libejs.so
DEPS_146 += $(BUILD)/bin/ejs.mod
DEPS_146 += $(BUILD)/bin/ejs.db.sqlite.mod
ifeq ($(ME_COM_SQLITE),1)
    DEPS_146 += $(BUILD)/bin/libsql.so
endif
DEPS_146 += $(BUILD)/obj/ejsSqlite.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_146 += -lmpr-openssl
    LIBPATHS_146 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_146 += -lssl
    LIBPATHS_146 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_146 += -lcrypto
    LIBPATHS_146 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_146 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_146 += -lmpr-estssl
endif
LIBS_146 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_146 += -lmpr-openssl
    LIBPATHS_146 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_146 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_146 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_146 += -lpcre
endif
LIBS_146 += -lmpr
LIBS_146 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_146 += -lhttp
endif
ifeq ($(ME_COM_SQLITE),1)
    LIBS_146 += -lsql
endif
ifeq ($(ME_COM_SQLITE),1)
    LIBS_146 += -lsql
endif
LIBS_146 += -lejs

$(BUILD)/bin/libejs.db.sqlite.so: $(DEPS_146)
	@echo '      [Link] $(BUILD)/bin/libejs.db.sqlite.so'
	$(CC) -shared -o $(BUILD)/bin/libejs.db.sqlite.so $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsSqlite.o" $(LIBPATHS_146) $(LIBS_146) $(LIBS_146) $(LIBS) 

#
#   libejs.web
#
DEPS_147 += $(BUILD)/bin/libejs.so
DEPS_147 += $(BUILD)/bin/ejs.mod
DEPS_147 += $(BUILD)/inc/ejsWeb.h
DEPS_147 += $(BUILD)/obj/ejsHttpServer.o
DEPS_147 += $(BUILD)/obj/ejsRequest.o
DEPS_147 += $(BUILD)/obj/ejsSession.o
DEPS_147 += $(BUILD)/obj/ejsWeb.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_147 += -lmpr-openssl
    LIBPATHS_147 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_147 += -lssl
    LIBPATHS_147 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_147 += -lcrypto
    LIBPATHS_147 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_147 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_147 += -lmpr-estssl
endif
LIBS_147 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_147 += -lmpr-openssl
    LIBPATHS_147 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_147 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_147 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_147 += -lpcre
endif
LIBS_147 += -lmpr
LIBS_147 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_147 += -lhttp
endif
LIBS_147 += -lejs

$(BUILD)/bin/libejs.web.so: $(DEPS_147)
	@echo '      [Link] $(BUILD)/bin/libejs.web.so'
	$(CC) -shared -o $(BUILD)/bin/libejs.web.so $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsHttpServer.o" "$(BUILD)/obj/ejsRequest.o" "$(BUILD)/obj/ejsSession.o" "$(BUILD)/obj/ejsWeb.o" $(LIBPATHS_147) $(LIBS_147) $(LIBS_147) $(LIBS) 

#
#   mvc.es
#
DEPS_148 += src/ejs.mvc/mvc.es

$(BUILD)/bin/mvc.es: $(DEPS_148)
	@echo '      [Copy] $(BUILD)/bin/mvc.es'
	mkdir -p "$(BUILD)/bin"
	cp src/ejs.mvc/mvc.es $(BUILD)/bin/mvc.es

#
#   mvc
#
DEPS_149 += $(BUILD)/bin/libejs.so
DEPS_149 += $(BUILD)/bin/mvc.es
DEPS_149 += $(BUILD)/obj/ejsrun.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_149 += -lmpr-openssl
    LIBPATHS_149 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_149 += -lssl
    LIBPATHS_149 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_149 += -lcrypto
    LIBPATHS_149 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_149 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_149 += -lmpr-estssl
endif
LIBS_149 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_149 += -lmpr-openssl
    LIBPATHS_149 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_149 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_149 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_149 += -lpcre
endif
LIBS_149 += -lmpr
LIBS_149 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_149 += -lhttp
endif

$(BUILD)/bin/mvc: $(DEPS_149)
	@echo '      [Link] $(BUILD)/bin/mvc'
	$(CC) -o $(BUILD)/bin/mvc $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsrun.o" $(LIBPATHS_149) $(LIBS_149) $(LIBS_149) $(LIBS) $(LIBS) 

#
#   utest.es
#
DEPS_150 += src/ejs.utest/utest.es

$(BUILD)/bin/utest.es: $(DEPS_150)
	@echo '      [Copy] $(BUILD)/bin/utest.es'
	mkdir -p "$(BUILD)/bin"
	cp src/ejs.utest/utest.es $(BUILD)/bin/utest.es

#
#   utest.worker
#
DEPS_151 += src/ejs.utest/utest.worker

$(BUILD)/bin/utest.worker: $(DEPS_151)
	@echo '      [Copy] $(BUILD)/bin/utest.worker'
	mkdir -p "$(BUILD)/bin"
	cp src/ejs.utest/utest.worker $(BUILD)/bin/utest.worker

#
#   utest
#
DEPS_152 += $(BUILD)/bin/libejs.so
DEPS_152 += $(BUILD)/bin/utest.es
DEPS_152 += $(BUILD)/bin/utest.worker
DEPS_152 += $(BUILD)/obj/ejsrun.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_152 += -lmpr-openssl
    LIBPATHS_152 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_152 += -lssl
    LIBPATHS_152 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_152 += -lcrypto
    LIBPATHS_152 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_152 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_152 += -lmpr-estssl
endif
LIBS_152 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_152 += -lmpr-openssl
    LIBPATHS_152 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_152 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_152 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_152 += -lpcre
endif
LIBS_152 += -lmpr
LIBS_152 += -lejs
ifeq ($(ME_COM_HTTP),1)
    LIBS_152 += -lhttp
endif

$(BUILD)/bin/utest: $(DEPS_152)
	@echo '      [Link] $(BUILD)/bin/utest'
	$(CC) -o $(BUILD)/bin/utest $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/ejsrun.o" $(LIBPATHS_152) $(LIBS_152) $(LIBS_152) $(LIBS) $(LIBS) 

#
#   watchdog
#
DEPS_153 += $(BUILD)/bin/libmpr.so
DEPS_153 += $(BUILD)/obj/watchdog.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_153 += -lmpr-openssl
    LIBPATHS_153 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_153 += -lssl
    LIBPATHS_153 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_153 += -lcrypto
    LIBPATHS_153 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_153 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_153 += -lmpr-estssl
endif
LIBS_153 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_153 += -lmpr-openssl
    LIBPATHS_153 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/ejsman: $(DEPS_153)
	@echo '      [Link] $(BUILD)/bin/ejsman'
	$(CC) -o $(BUILD)/bin/ejsman $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/watchdog.o" $(LIBPATHS_153) $(LIBS_153) $(LIBS_153) $(LIBS) $(LIBS) 

#
#   www
#
DEPS_154 += src/ejs.web/www/images/banner.jpg
DEPS_154 += src/ejs.web/www/images/favicon.ico
DEPS_154 += src/ejs.web/www/images/splash.jpg
DEPS_154 += src/ejs.web/www/js/jquery.ejs.min.js
DEPS_154 += src/ejs.web/www/js/jquery.min.js
DEPS_154 += src/ejs.web/www/js/jquery.simplemodal.min.js
DEPS_154 += src/ejs.web/www/js/jquery.tablesorter.js
DEPS_154 += src/ejs.web/www/js/jquery.tablesorter.min.js
DEPS_154 += src/ejs.web/www/js/jquery.treeview.min.js
DEPS_154 += src/ejs.web/www/js/tree-images/file.gif
DEPS_154 += src/ejs.web/www/js/tree-images/folder-closed.gif
DEPS_154 += src/ejs.web/www/js/tree-images/folder.gif
DEPS_154 += src/ejs.web/www/js/tree-images/minus.gif
DEPS_154 += src/ejs.web/www/js/tree-images/plus.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-black-line.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-black.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-default-line.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-default.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-famfamfam-line.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-famfamfam.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-gray-line.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-gray.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-red-line.gif
DEPS_154 += src/ejs.web/www/js/tree-images/treeview-red.gif
DEPS_154 += src/ejs.web/www/js/treeview.css
DEPS_154 += src/ejs.web/www/layout.css
DEPS_154 += src/ejs.web/www/themes/default.css

$(BUILD)/bin/www: $(DEPS_154)
	@echo '      [Copy] $(BUILD)/bin/www'
	mkdir -p "$(BUILD)/bin/www/images"
	cp src/ejs.web/www/images/banner.jpg $(BUILD)/bin/www/images/banner.jpg
	cp src/ejs.web/www/images/favicon.ico $(BUILD)/bin/www/images/favicon.ico
	cp src/ejs.web/www/images/splash.jpg $(BUILD)/bin/www/images/splash.jpg
	mkdir -p "$(BUILD)/bin/www/js"
	cp src/ejs.web/www/js/jquery.ejs.min.js $(BUILD)/bin/www/js/jquery.ejs.min.js
	cp src/ejs.web/www/js/jquery.min.js $(BUILD)/bin/www/js/jquery.min.js
	cp src/ejs.web/www/js/jquery.simplemodal.min.js $(BUILD)/bin/www/js/jquery.simplemodal.min.js
	cp src/ejs.web/www/js/jquery.tablesorter.js $(BUILD)/bin/www/js/jquery.tablesorter.js
	cp src/ejs.web/www/js/jquery.tablesorter.min.js $(BUILD)/bin/www/js/jquery.tablesorter.min.js
	cp src/ejs.web/www/js/jquery.treeview.min.js $(BUILD)/bin/www/js/jquery.treeview.min.js
	mkdir -p "$(BUILD)/bin/www/js/tree-images"
	cp src/ejs.web/www/js/tree-images/file.gif $(BUILD)/bin/www/js/tree-images/file.gif
	cp src/ejs.web/www/js/tree-images/folder-closed.gif $(BUILD)/bin/www/js/tree-images/folder-closed.gif
	cp src/ejs.web/www/js/tree-images/folder.gif $(BUILD)/bin/www/js/tree-images/folder.gif
	cp src/ejs.web/www/js/tree-images/minus.gif $(BUILD)/bin/www/js/tree-images/minus.gif
	cp src/ejs.web/www/js/tree-images/plus.gif $(BUILD)/bin/www/js/tree-images/plus.gif
	cp src/ejs.web/www/js/tree-images/treeview-black-line.gif $(BUILD)/bin/www/js/tree-images/treeview-black-line.gif
	cp src/ejs.web/www/js/tree-images/treeview-black.gif $(BUILD)/bin/www/js/tree-images/treeview-black.gif
	cp src/ejs.web/www/js/tree-images/treeview-default-line.gif $(BUILD)/bin/www/js/tree-images/treeview-default-line.gif
	cp src/ejs.web/www/js/tree-images/treeview-default.gif $(BUILD)/bin/www/js/tree-images/treeview-default.gif
	cp src/ejs.web/www/js/tree-images/treeview-famfamfam-line.gif $(BUILD)/bin/www/js/tree-images/treeview-famfamfam-line.gif
	cp src/ejs.web/www/js/tree-images/treeview-famfamfam.gif $(BUILD)/bin/www/js/tree-images/treeview-famfamfam.gif
	cp src/ejs.web/www/js/tree-images/treeview-gray-line.gif $(BUILD)/bin/www/js/tree-images/treeview-gray-line.gif
	cp src/ejs.web/www/js/tree-images/treeview-gray.gif $(BUILD)/bin/www/js/tree-images/treeview-gray.gif
	cp src/ejs.web/www/js/tree-images/treeview-red-line.gif $(BUILD)/bin/www/js/tree-images/treeview-red-line.gif
	cp src/ejs.web/www/js/tree-images/treeview-red.gif $(BUILD)/bin/www/js/tree-images/treeview-red.gif
	cp src/ejs.web/www/js/treeview.css $(BUILD)/bin/www/js/treeview.css
	mkdir -p "$(BUILD)/bin/www"
	cp src/ejs.web/www/layout.css $(BUILD)/bin/www/layout.css
	mkdir -p "$(BUILD)/bin/www/themes"
	cp src/ejs.web/www/themes/default.css $(BUILD)/bin/www/themes/default.css

#
#   installPrep
#

installPrep: $(DEPS_155)
	if [ "`id -u`" != 0 ] ; \
	then echo "Must run as root. Rerun with "sudo"" ; \
	exit 255 ; \
	fi

#
#   stop
#

stop: $(DEPS_156)

#
#   installBinary
#

installBinary: $(DEPS_157)
	mkdir -p "$(ME_APP_PREFIX)" ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	ln -s "$(VERSION)" "$(ME_APP_PREFIX)/latest" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/ejs $(ME_VAPP_PREFIX)/bin/ejs ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/ejs" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/ejs" "$(ME_BIN_PREFIX)/ejs" ; \
	cp $(BUILD)/bin/ejsc $(ME_VAPP_PREFIX)/bin/ejsc ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/ejsc" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/ejsc" "$(ME_BIN_PREFIX)/ejsc" ; \
	cp $(BUILD)/bin/ejsman $(ME_VAPP_PREFIX)/bin/ejsman ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/ejsman" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/ejsman" "$(ME_BIN_PREFIX)/ejsman" ; \
	cp $(BUILD)/bin/ejsmod $(ME_VAPP_PREFIX)/bin/ejsmod ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/ejsmod" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/ejsmod" "$(ME_BIN_PREFIX)/ejsmod" ; \
	cp $(BUILD)/bin/ejsrun $(ME_VAPP_PREFIX)/bin/ejsrun ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/ejsrun" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/ejsrun" "$(ME_BIN_PREFIX)/ejsrun" ; \
	cp $(BUILD)/bin/mvc $(ME_VAPP_PREFIX)/bin/mvc ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/mvc" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/mvc" "$(ME_BIN_PREFIX)/mvc" ; \
	cp $(BUILD)/bin/utest $(ME_VAPP_PREFIX)/bin/utest ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/utest" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/utest" "$(ME_BIN_PREFIX)/utest" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/libejs.db.sqlite.so $(ME_VAPP_PREFIX)/bin/libejs.db.sqlite.so ; \
	cp $(BUILD)/bin/libejs.so $(ME_VAPP_PREFIX)/bin/libejs.so ; \
	cp $(BUILD)/bin/libejs.web.so $(ME_VAPP_PREFIX)/bin/libejs.web.so ; \
	cp $(BUILD)/bin/libejs.zlib.so $(ME_VAPP_PREFIX)/bin/libejs.zlib.so ; \
	cp $(BUILD)/bin/libhttp.so $(ME_VAPP_PREFIX)/bin/libhttp.so ; \
	cp $(BUILD)/bin/libmpr.so $(ME_VAPP_PREFIX)/bin/libmpr.so ; \
	cp $(BUILD)/bin/libpcre.so $(ME_VAPP_PREFIX)/bin/libpcre.so ; \
	cp $(BUILD)/bin/libsql.so $(ME_VAPP_PREFIX)/bin/libsql.so ; \
	cp $(BUILD)/bin/libzlib.so $(ME_VAPP_PREFIX)/bin/libzlib.so ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/ejs.db.mapper.mod $(ME_VAPP_PREFIX)/bin/ejs.db.mapper.mod ; \
	cp $(BUILD)/bin/ejs.db.mod $(ME_VAPP_PREFIX)/bin/ejs.db.mod ; \
	cp $(BUILD)/bin/ejs.db.sqlite.mod $(ME_VAPP_PREFIX)/bin/ejs.db.sqlite.mod ; \
	cp $(BUILD)/bin/ejs.mod $(ME_VAPP_PREFIX)/bin/ejs.mod ; \
	cp $(BUILD)/bin/ejs.mvc.mod $(ME_VAPP_PREFIX)/bin/ejs.mvc.mod ; \
	cp $(BUILD)/bin/ejs.tar.mod $(ME_VAPP_PREFIX)/bin/ejs.tar.mod ; \
	cp $(BUILD)/bin/ejs.template.mod $(ME_VAPP_PREFIX)/bin/ejs.template.mod ; \
	cp $(BUILD)/bin/ejs.unix.mod $(ME_VAPP_PREFIX)/bin/ejs.unix.mod ; \
	cp $(BUILD)/bin/ejs.web.mod $(ME_VAPP_PREFIX)/bin/ejs.web.mod ; \
	cp $(BUILD)/bin/ejs.zlib.mod $(ME_VAPP_PREFIX)/bin/ejs.zlib.mod ; \
	cp $(BUILD)/bin/mvc.es $(ME_VAPP_PREFIX)/bin/mvc.es ; \
	cp $(BUILD)/bin/utest.es $(ME_VAPP_PREFIX)/bin/utest.es ; \
	cp $(BUILD)/bin/utest.worker $(ME_VAPP_PREFIX)/bin/utest.worker ; \
	if [ "$(ME_COM_SSL)" = 1 ]; then true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/roots.crt $(ME_VAPP_PREFIX)/bin/roots.crt ; \
	fi ; \
	if [ "$(ME_COM_EST)" = 1 ]; then true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/libest.so $(ME_VAPP_PREFIX)/bin/libest.so ; \
	fi ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/www" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/www/images" ; \
	cp src/ejs.web/www/images/banner.jpg $(ME_VAPP_PREFIX)/bin/www/images/banner.jpg ; \
	cp src/ejs.web/www/images/favicon.ico $(ME_VAPP_PREFIX)/bin/www/images/favicon.ico ; \
	cp src/ejs.web/www/images/splash.jpg $(ME_VAPP_PREFIX)/bin/www/images/splash.jpg ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/www/js" ; \
	cp src/ejs.web/www/js/jquery.ejs.min.js $(ME_VAPP_PREFIX)/bin/www/js/jquery.ejs.min.js ; \
	cp src/ejs.web/www/js/jquery.min.js $(ME_VAPP_PREFIX)/bin/www/js/jquery.min.js ; \
	cp src/ejs.web/www/js/jquery.simplemodal.min.js $(ME_VAPP_PREFIX)/bin/www/js/jquery.simplemodal.min.js ; \
	cp src/ejs.web/www/js/jquery.tablesorter.js $(ME_VAPP_PREFIX)/bin/www/js/jquery.tablesorter.js ; \
	cp src/ejs.web/www/js/jquery.tablesorter.min.js $(ME_VAPP_PREFIX)/bin/www/js/jquery.tablesorter.min.js ; \
	cp src/ejs.web/www/js/jquery.treeview.min.js $(ME_VAPP_PREFIX)/bin/www/js/jquery.treeview.min.js ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/www/js/tree-images" ; \
	cp src/ejs.web/www/js/tree-images/file.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/file.gif ; \
	cp src/ejs.web/www/js/tree-images/folder-closed.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/folder-closed.gif ; \
	cp src/ejs.web/www/js/tree-images/folder.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/folder.gif ; \
	cp src/ejs.web/www/js/tree-images/minus.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/minus.gif ; \
	cp src/ejs.web/www/js/tree-images/plus.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/plus.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-black-line.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-black-line.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-black.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-black.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-default-line.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-default-line.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-default.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-default.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-famfamfam-line.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-famfamfam-line.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-famfamfam.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-famfamfam.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-gray-line.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-gray-line.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-gray.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-gray.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-red-line.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-red-line.gif ; \
	cp src/ejs.web/www/js/tree-images/treeview-red.gif $(ME_VAPP_PREFIX)/bin/www/js/tree-images/treeview-red.gif ; \
	cp src/ejs.web/www/js/treeview.css $(ME_VAPP_PREFIX)/bin/www/js/treeview.css ; \
	cp src/ejs.web/www/layout.css $(ME_VAPP_PREFIX)/bin/www/layout.css ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/www/themes" ; \
	cp src/ejs.web/www/themes/default.css $(ME_VAPP_PREFIX)/bin/www/themes/default.css ; \
	mkdir -p "$(ME_VAPP_PREFIX)/inc" ; \
	cp src/ejs.h $(ME_VAPP_PREFIX)/inc/ejs.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejs.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejs.h" "$(ME_INC_PREFIX)/ejs/ejs.h" ; \
	cp src/ejsByteCode.h $(ME_VAPP_PREFIX)/inc/ejsByteCode.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsByteCode.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsByteCode.h" "$(ME_INC_PREFIX)/ejs/ejsByteCode.h" ; \
	cp src/ejsByteCodeTable.h $(ME_VAPP_PREFIX)/inc/ejsByteCodeTable.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsByteCodeTable.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsByteCodeTable.h" "$(ME_INC_PREFIX)/ejs/ejsByteCodeTable.h" ; \
	cp src/ejsCompiler.h $(ME_VAPP_PREFIX)/inc/ejsCompiler.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsCompiler.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsCompiler.h" "$(ME_INC_PREFIX)/ejs/ejsCompiler.h" ; \
	cp src/ejsCustomize.h $(ME_VAPP_PREFIX)/inc/ejsCustomize.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsCustomize.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsCustomize.h" "$(ME_INC_PREFIX)/ejs/ejsCustomize.h" ; \
	cp src/vm/ejsByteGoto.h $(ME_VAPP_PREFIX)/inc/ejsByteGoto.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsByteGoto.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsByteGoto.h" "$(ME_INC_PREFIX)/ejs/ejsByteGoto.h" ; \
	cp src/slots/ejs.cache.local.slots.h $(ME_VAPP_PREFIX)/inc/ejs.cache.local.slots.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejs.cache.local.slots.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejs.cache.local.slots.h" "$(ME_INC_PREFIX)/ejs/ejs.cache.local.slots.h" ; \
	cp src/slots/ejs.db.sqlite.slots.h $(ME_VAPP_PREFIX)/inc/ejs.db.sqlite.slots.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejs.db.sqlite.slots.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejs.db.sqlite.slots.h" "$(ME_INC_PREFIX)/ejs/ejs.db.sqlite.slots.h" ; \
	cp src/slots/ejs.slots.h $(ME_VAPP_PREFIX)/inc/ejs.slots.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejs.slots.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejs.slots.h" "$(ME_INC_PREFIX)/ejs/ejs.slots.h" ; \
	cp src/slots/ejs.web.slots.h $(ME_VAPP_PREFIX)/inc/ejs.web.slots.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejs.web.slots.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejs.web.slots.h" "$(ME_INC_PREFIX)/ejs/ejs.web.slots.h" ; \
	cp src/slots/ejs.zlib.slots.h $(ME_VAPP_PREFIX)/inc/ejs.zlib.slots.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejs.zlib.slots.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejs.zlib.slots.h" "$(ME_INC_PREFIX)/ejs/ejs.zlib.slots.h" ; \
	cp src/cmd/ejsmod.h $(ME_VAPP_PREFIX)/inc/ejsmod.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsmod.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsmod.h" "$(ME_INC_PREFIX)/ejs/ejsmod.h" ; \
	cp src/ejs.web/ejsWeb.h $(ME_VAPP_PREFIX)/inc/ejsWeb.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/ejsWeb.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/ejsWeb.h" "$(ME_INC_PREFIX)/ejs/ejsWeb.h" ; \
	cp src/est/est.h $(ME_VAPP_PREFIX)/inc/est.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/est.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/est.h" "$(ME_INC_PREFIX)/ejs/est.h" ; \
	cp src/http/http.h $(ME_VAPP_PREFIX)/inc/http.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/http.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/http.h" "$(ME_INC_PREFIX)/ejs/http.h" ; \
	cp src/mpr/mpr.h $(ME_VAPP_PREFIX)/inc/mpr.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/mpr.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/mpr.h" "$(ME_INC_PREFIX)/ejs/mpr.h" ; \
	cp src/osdep/osdep.h $(ME_VAPP_PREFIX)/inc/osdep.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/osdep.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/osdep.h" "$(ME_INC_PREFIX)/ejs/osdep.h" ; \
	cp src/pcre/pcre.h $(ME_VAPP_PREFIX)/inc/pcre.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/pcre.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/pcre.h" "$(ME_INC_PREFIX)/ejs/pcre.h" ; \
	cp src/sqlite/sqlite3.h $(ME_VAPP_PREFIX)/inc/sqlite3.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/sqlite3.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/sqlite3.h" "$(ME_INC_PREFIX)/ejs/sqlite3.h" ; \
	cp src/zlib/zlib.h $(ME_VAPP_PREFIX)/inc/zlib.h ; \
	mkdir -p "$(ME_INC_PREFIX)/ejs" ; \
	rm -f "$(ME_INC_PREFIX)/ejs/zlib.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/zlib.h" "$(ME_INC_PREFIX)/ejs/zlib.h" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/doc/man1" ; \
	cp doc/dist/man/ejs.1 $(ME_VAPP_PREFIX)/doc/man1/ejs.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/ejs.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/ejs.1" "$(ME_MAN_PREFIX)/man1/ejs.1" ; \
	cp doc/dist/man/ejsc.1 $(ME_VAPP_PREFIX)/doc/man1/ejsc.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/ejsc.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/ejsc.1" "$(ME_MAN_PREFIX)/man1/ejsc.1" ; \
	cp doc/dist/man/ejsmod.1 $(ME_VAPP_PREFIX)/doc/man1/ejsmod.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/ejsmod.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/ejsmod.1" "$(ME_MAN_PREFIX)/man1/ejsmod.1" ; \
	cp doc/dist/man/http.1 $(ME_VAPP_PREFIX)/doc/man1/http.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/http.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/http.1" "$(ME_MAN_PREFIX)/man1/http.1" ; \
	cp doc/dist/man/manager.1 $(ME_VAPP_PREFIX)/doc/man1/manager.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/manager.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/manager.1" "$(ME_MAN_PREFIX)/man1/manager.1" ; \
	cp doc/dist/man/mvc.1 $(ME_VAPP_PREFIX)/doc/man1/mvc.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/mvc.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/mvc.1" "$(ME_MAN_PREFIX)/man1/mvc.1"

#
#   start
#

start: $(DEPS_158)

#
#   install
#
DEPS_159 += installPrep
DEPS_159 += stop
DEPS_159 += installBinary
DEPS_159 += start

install: $(DEPS_159)

#
#   uninstall
#
DEPS_160 += stop

uninstall: $(DEPS_160)

#
#   version
#

version: $(DEPS_161)
	echo $(VERSION)

