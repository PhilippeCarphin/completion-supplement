modulefile=share/modulefiles/completion-supplement
PREFIX ?= localinstall

ifeq ($(shell uname),Darwin)
	INSTALL=ginstall
else
	INSTALL=install
endif

all: module

install:module
	install -D share/bash-completion/completions/_hcron $(DESTDIR)$(PREFIX)/share/bash-completion/completions/_hcron
	install -D share/modulefiles/completion-supplement $(DESTDIR)$(PREFIX)/share/modulefiles/completion-supplement

module:$(modulefile)
$(modulefile):modulefile.in
	sed 's|PREFIX|$(PWD)|g' $^ >$@

install-dev:module
	mkdir -p $(DESTDIR)$(PREFIX)/share/bash-completion/completions
	ln -snf  $(PWD)/share/bash-completion/completions/_hcron $(DESTDIR)$(PREFIX)/share/bash-completion/completions/_hcron
	mkdir -p $(DESTDIR)$(PREFIX)/share/modulefiles
	ln -snf  $(PWD)/share/modulefiles/completion-supplement $(DESTDIR)$(PREFIX)/share/modulefiles/completion-supplement
