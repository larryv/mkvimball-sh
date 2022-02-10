# Makefile
# --------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2022 by Lawrence Velázquez <vq@larryv.me>.
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.


.POSIX:
.SUFFIXES:
SHELL = /bin/sh


# Utilities

ASCIIDOCTOR = asciidoctor
INSTALL = ./install-sh
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL)
M4 = m4


# Locations

bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
man1dir = $(mandir)/man1
mandir = $(datarootdir)/man
prefix = /usr/local


# Locations (internal use only; do not override)

manext = .1
prog = mkvimball-sh
progman = $(prog)$(manext)
shim = mkvimball
shimman = $(shim)$(manext)


# Targets

all: FORCE $(prog) $(progman) $(shim) $(shimman)

clean: FORCE
	rm -f $(shim)

FORCE:

# Doesn't install the shim, so that a casual `make install` won't
# overwrite the original `mkvimball` if present.  The `installshim`
# target can be used to install the shim.
install: FORCE $(prog) $(progman) installdirs
	$(INSTALL_PROGRAM) $(prog) $(DESTDIR)$(bindir)/$(prog)
	-$(INSTALL_DATA) $(progman) $(DESTDIR)$(man1dir)/$(progman)

installdirs: FORCE
	$(INSTALL) -d $(DESTDIR)$(bindir)
	-$(INSTALL) -d $(DESTDIR)$(man1dir)

installshim: FORCE $(shim) $(shimman) install
	$(INSTALL_PROGRAM) $(shim) $(DESTDIR)$(bindir)/$(shim)
	-$(INSTALL_DATA) $(shimman) $(DESTDIR)$(man1dir)/$(shimman)

maintainerclean: FORCE clean
	rm -f $(progman) $(shimman)

# TODO: Decide if SOURCE_DATE_EPOCH is worth bothering with.
#   https://docs.asciidoctor.org/asciidoc/latest/attributes/document-attributes-ref/#note-sourcedateepoch
#   https://reproducible-builds.org/docs/source-date-epoch/
#   https://reproducible-builds.org/specs/source-date-epoch/
$(progman) $(shimman): $(prog).adoc
	$(ASCIIDOCTOR) --backend=manpage $(prog).adoc

# Assumes the default m4 quoting strings ("`" and "'").
$(shim): $(shim).m4
	$(M4) -D __MKVIMBALL_SH__=\`$(bindir)/$(prog)\' $(shim).m4 >$@

# Doesn't delete the shim, so that a casual `make uninstall` won't
# remove the original `mkvimball` if present.  The `uninstallshim`
# target can be used to remove the shim.
uninstall: FORCE
	rm -f $(DESTDIR)$(bindir)/$(prog) $(DESTDIR)$(man1dir)/$(progman)

# Intentionally does not depend on `uninstall`, to allow removing the
# shim selectively.
uninstallshim: FORCE
	rm -f $(DESTDIR)$(bindir)/$(shim) $(DESTDIR)$(man1dir)/$(shimman)
