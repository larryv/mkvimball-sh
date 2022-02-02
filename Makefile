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

INSTALL = ./install-sh
INSTALL_PROGRAM = $(INSTALL)
M4 = m4


# Locations

bindir = $(exec_prefix)/bin
exec_prefix = $(prefix)
prefix = /usr/local

prog = mkvimball-sh
shim = mkvimball


# Targets

all: FORCE $(prog) $(shim)

clean: FORCE
	rm -f $(shim)

FORCE:

# Doesn't install the shim, so that a casual `make install` won't
# overwrite the original `mkvimball` if present.  The `installshim`
# target can be used to install the shim.
install: FORCE $(prog) installdirs
	$(INSTALL_PROGRAM) $(prog) $(DESTDIR)$(bindir)/$(prog)

installdirs: FORCE
	$(INSTALL) -d $(DESTDIR)$(bindir)

installshim: FORCE $(shim) install
	$(INSTALL_PROGRAM) $(shim) $(DESTDIR)$(bindir)/$(shim)

# Assumes the default m4 quoting strings ("`" and "'").
$(shim): $(shim).m4
	$(M4) -D __MKVIMBALL_SH__=\`$(bindir)/$(prog)\' $(shim).m4 >$@

# Doesn't delete the shim, so that a casual `make uninstall` won't
# remove the original `mkvimball` if present.  The `uninstallshim`
# target can be used to remove the shim.
uninstall: FORCE
	rm -f $(DESTDIR)$(bindir)/$(prog)

# Intentionally does not depend on `uninstall`, to allow removing the
# shim selectively.
uninstallshim: FORCE
	rm -f $(DESTDIR)$(bindir)/$(shim)
