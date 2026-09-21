completions=$(wildcard share/bash-completion/completions/_*)
PREFIX ?= $(HOME)/.local

moduledir=share/modulefiles
modulefile=$(moduledir)/completion-supplement

ifeq ($(shell uname),Darwin)
	INSTALL=ginstall
else
	INSTALL=install
endif

all: $(modulefile)

install:$(modulefile)
	for comp in $(completions) ; do install -vD -m 644 $${comp} $(DESTDIR)$(PREFIX)/$${comp} ; done
	install -D -m 644 $(modulefile) $(DESTDIR)$(PREFIX)/share/modulefiles/completion-supplement-cmc

$(modulefile):$(modulefile).in
	sed 's|PREFIX|$(PWD)|g' $^ >$@

install-dev:$(modulefile)
	mkdir -p $(DESTDIR)$(PREFIX)/share/bash-completion/completions $(DESTDIR)$(PREFIX)/share/modulefiles
	for comp in $(completions) ; do ln -snfv $(PWD)/$${comp} $(DESTDIR)$(PREFIX)/$${comp} ; done
	ln -snf $(PWD)/$(modulefile) $(DESTDIR)$(PREFIX)/share/modulefiles/completion-supplement
