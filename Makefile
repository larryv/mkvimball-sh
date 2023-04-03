# Makefile
# --------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
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


# ------------------
# USER-FACING MACROS

SHELL = /bin/sh

ASCIIDOCTOR = asciidoctor
# Reduce the number of shells in play by invoking install-sh with
# the same shell that make(1) uses.  Use "./install-sh" instead of
# "install-sh" to preclude inadvertent PATH searches [1][2].
INSTALL = $(SHELL) ./install-sh
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL)
M4 = m4

bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
man1dir = $(mandir)/man1
mandir = $(datarootdir)/man
prefix = /usr/local


# ---------------
# INTERNAL MACROS

# Assumes the default m4 quoting strings ("`" and "'").
all_m4flags = -D __MKVIMBALL_SH__=\`$(bindir)/$(prog)\' $(M4FLAGS)
cleanup = { rc=$$?; rm -f $@ && exit "$$rc"; }
manext = .1
prog = mkvimball-sh
progman = $(prog)$(manext)
shim = mkvimball
shimman = $(shim)$(manext)


# -------
# TARGETS

all: FORCE $(prog) $(progman) $(shim) $(shimman)

clean: FORCE
	rm -f $(shim)

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

# Doesn't delete the shim, so that a casual `make uninstall` won't
# remove the original `mkvimball` if present.  The `uninstallshim`
# target can be used to remove the shim.
uninstall: FORCE
	rm -f $(DESTDIR)$(bindir)/$(prog) $(DESTDIR)$(man1dir)/$(progman)

# Intentionally does not depend on `uninstall`, to allow removing the
# shim selectively.
uninstallshim: FORCE
	rm -f $(DESTDIR)$(bindir)/$(shim) $(DESTDIR)$(man1dir)/$(shimman)

# TODO: Decide if SOURCE_DATE_EPOCH is worth bothering with [3][4][5].
$(progman) $(shimman): $(prog).adoc
	$(ASCIIDOCTOR) --backend=manpage $(ASCIIDOCTORFLAGS) $(prog).adoc

# Portably imitate .DELETE_ON_ERROR [6] because m4(1) may fail after the
# shell creates/truncates the target.
$(shim): $(shim).m4
	$(M4) $(all_m4flags) $(shim).m4 >$@ || $(cleanup)

# Imitate .PHONY portably [7].
FORCE:


# ----------
# REFERENCES
#
#  1. https://www.gnu.org/software/autoconf/manual/autoconf-2.71/html_node/Invoking-the-Shell.html
#  2. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/sh.html
#  3. https://docs.asciidoctor.org/asciidoc/latest/attributes/document-attributes-ref/#note-sourcedateepoch
#  4. https://reproducible-builds.org/docs/source-date-epoch/
#  5. https://reproducible-builds.org/specs/source-date-epoch/
#  6. https://www.gnu.org/software/make/manual/html_node/Errors.html
#  7. https://www.gnu.org/software/make/manual/html_node/Force-Targets
