
ROOT        := .

SHELL       := /bin/bash

SCRIPTS     := $(wildcard bin/antiX-* bin/*-select bin/backlight-brightness)
SHARE_DIR   := $(ROOT)/usr/share/antiX-cli-cc
LIB_DIR     := $(ROOT)/usr/lib/shell
BIN_DIR     := $(ROOT)/usr/local/bin
LOCALE_DIR  := $(ROOT)/usr/share/locale
DESK_DIR    := $(ROOT)/usr/share/applications/antix
MAN_DIR     := $(ROOT)/usr/share/man/man1
RULES_DIR   := $(ROOT)/etc/udev/rules.d/

MAN_PAGES   := $(wildcard man/*.1)
MAN_FINAL   := $(patsubst man/%,$(MAN_DIR)/%.gz,$(MAN_PAGES))

ALL_DIRS   := $(LIB_DIR) $(BIN_DIR) $(LOCALE_DIR) $(MAN_DIR) $(RULES_DIR) $(SHARE_DIR)

.PHONY: scripts help all lib rules man-pages shared locales


help:

	@echo "make help                show this help"
	@echo "make all                 install to current directory"
	@echo "make all ROOT=           install to /"
	@echo "make all ROOT=dir        install to directory dir"
	@echo "make lib                 install the lib files"
	@echo "make man-pages           install man pages"
	@#echo ""

all: scripts lib rules man-pages shared locales

lib: | $(LIB_DIR) $(LOCALE_DIR)
	cp -r lib/* $(LIB_DIR)
	@#cp -r locale $(LOCALE_DIR)

scripts: | $(BIN_DIR)
	cp $(SCRIPTS) $(BIN_DIR)

rules: | $(RULES_DIR)
	cp udev-rules/*.rules $(RULES_DIR)

man-pages: $(MAN_FINAL)

$(MAN_FINAL): $(MAN_DIR)/%.gz : man/% | $(MAN_DIR)
	gzip -c $< > $@

shared: | $(SHARE_DIR)
	cp -r share/* $(SHARE_DIR)

locales: | $(LOCALE_DIR)
	cp -r locale/* $(LOCALE_DIR)

$(ALL_DIRS):
	test -d $(ROOT)/
	mkdir -p $@
