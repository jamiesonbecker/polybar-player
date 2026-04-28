PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

install:
	install -Dm755 polybar-player $(DESTDIR)$(BINDIR)/polybar-player

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/polybar-player

test:
	bash tests/run_tests.sh

.PHONY: install uninstall test
