PREFIX ?= localinstall

moduledir=share/modulefiles
compdir=share/bash-comletion/completions

modulefile=$(moduledir)/completion-supplement
hcron_comp=$(compdir)/_hcron

ifeq ($(shell uname),Darwin)
	INSTALL=ginstall
else
	INSTALL=install
endif

all: $(modulefile)

install:$(modulefile)
	install -D $(hcron_comp) $(DESTDIR)$(PREFIX)/$(hcron_comp)
	install -D $(modulefile) $(DESTDIR)$(PREFIX)/$(modulefile)

$(modulefile):$(modulefile).in
	sed 's|PREFIX|$(PWD)|g' $^ >$@

install-dev:$(modulefile)
	mkdir -p $(DESTDIR)$(PREFIX)/$(compdir)
	ln -snf  $(PWD)/$(hcron_comp) $(DESTDIR)$(PREFIX)/$(hcron_comp)
	mkdir -p $(DESTDIR)$(PREFIX)/$(moduledir)
	ln -snf  $(PWD)/$(modulefile) $(DESTDIR)$(PREFIX)/$(modulefile)
