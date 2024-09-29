LIBPL := string.pl colors.pl array.pl io.pl path.pl
LIBPL := $(LIBPL:%=inc/%)

all: bin/pcpp $(LIBPL) inc/printhelp.pl inc/verbose.pl inc/config.pl

bin/pcpp: /map/pcpp/bin/pcpp | bin
	cp $< $@

inc/%.pl: /map/libpl/inc/%.pl | inc
	cp $< $@

inc/printhelp.pl: /map/helpman/inc/printhelp.pl | inc
	cp $< $@

inc/verbose.pl: /map/verbose/inc/verbose.pl | inc
	cp $< $@

inc/config.pl: /map/config/inc/config.pl | inc
	cp $< $@

bin inc:
	mkdir -p $@

mrproper:
	rm -rf inc bin

