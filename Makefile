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


# Locations

bindir = $(exec_prefix)/bin
exec_prefix = $(prefix)
prefix = /usr/local

prog = mkvimball-sh


# Targets

all: FORCE $(prog)

FORCE:

install: FORCE $(prog) installdirs
	$(INSTALL_PROGRAM) $(prog) $(DESTDIR)$(bindir)/$(prog)

installdirs: FORCE
	$(INSTALL) -d $(DESTDIR)$(bindir)

uninstall: FORCE
	rm -f $(DESTDIR)$(bindir)/$(prog)
