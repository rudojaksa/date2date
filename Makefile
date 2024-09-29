PACKAGE	:= date2date
VERSION	:= 0.2
AUTHORS	:= R.Jaksa 2017,2024 GPLv3
SUBVERS	:= 

SHELL	:= /bin/bash
PATH	:= usr/bin:$(PATH)
PKGNAME	:= $(PACKAGE)-$(VERSION)$(SUBVERSION)
PROJECT := $(shell getversion -prj)
DATE	:= $(shell date '+%Y-%m-%d')

BIN := date2date
DEP := $(BIN:%=.%.d)
DOC := $(BIN:%=%.md)

all: $(BIN)

$(BIN): %: %.pl .%.d .version.pl .%.built.pl Makefile
	@echo -e '#!/usr/bin/perl' > $@
	@echo "# $@ generated from $(PKGNAME)/$< $(DATE)" >> $@
	pcpp -v $< >> $@
	@chmod 755 $@
	@sync

$(DEP): .%.d: %.pl
	pcpp -d $(<:%.pl=%) $< > $@

$(DOC): %.md: %
	./$* -h | man2md > $@

.version.pl: Makefile
	@echo 'our $$PACKAGE = "$(PACKAGE)";' > $@
	@echo 'our $$VERSION = "$(VERSION)";' >> $@
	@echo 'our $$AUTHOR = "$(AUTHORS)";' >> $@
	@echo 'our $$SUBVERSION = "$(SUBVERS)";' >> $@
	@echo "make $@"

.PRECIOUS: .%.built.pl
.%.built.pl: %.pl .version.pl Makefile
	@echo 'our $$BUILT = "$(DATE)";' > $@
	@echo "make $@"

# /map install
ifneq ($(wildcard /map),)
install: $(BIN) $(DOC) README.md
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) bin $(BIN)
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) doc $(DOC) README.md

# /usr/local install
else
install: $(BIN)
	install $^ /usr/local/bin
endif

clean:
	rm -f .version.pl
	rm -f .*.built.pl
	rm -f $(DEP)

mrproper: clean
	rm -f $(DOC) $(BIN)

-include $(DEP)
-include ~/.github/Makefile.git
