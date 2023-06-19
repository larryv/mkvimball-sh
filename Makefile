# Makefile
# --------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
#
# To the extent possible under law, the author has dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.


.POSIX:
.SUFFIXES:
.SUFFIXES: .m4


# ---------------
# "PUBLIC" MACROS

# Remember to update the READMEs after adding new macros here.

SHELL = /bin/sh

ASCIIDOCTOR = asciidoctor
INSTALL = ./install-sh
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL)
M4 = m4
SHELLCHECK = shellcheck

bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
exec_prefix = $(prefix)
man1dir = $(mandir)/man1
mandir = $(datarootdir)/man
prefix = /usr/local


# ----------------
# "PRIVATE" MACROS

do_cleanup = { rc=$$?; rm -f $@ && exit "$$rc"; }
# Insert M4FLAGS first to accommodate SysV options that must precede -D.
do_m4 = $(M4) $(M4FLAGS) -D __MKVIMBALL_SH__=$(bindir)/$(prog)
manext = .1
prog = mkvimball-sh
progman = $(prog)$(manext)
shim = mkvimball
shimman = $(shim)$(manext)


# --------------
# "PUBLIC" RULES

all: FORCE $(prog) $(progman) $(shim) $(shimman)

check: FORCE $(prog) $(shim)
	$(SHELLCHECK) $(SHELLCHECKFLAGS) $(prog) $(shim)

clean: FORCE
	rm -f $(shim)

# The `install` target doesn't install the shim, so that a casual `make
# install` won't overwrite the original `mkvimball` if present.  The
# `installshim` target can be used to install the shim.

# If BAR/FOO is a directory or a symlink to one, then the behavior of
# `install FOO BAR` varies *significantly* among implementations.
# Ensure consistent results by detecting this situation and bailing out.
install: FORCE $(prog) $(progman) installdirs
	@for p in $(DESTDIR)$(bindir)/$(prog) $(DESTDIR)$(man1dir)/$(progman); \
do \
    if test -d "$$p"; \
    then \
        printf 'will not overwrite directory: %s\n' "$$p" >&2; \
        exit 1; \
    fi; \
done
	$(INSTALL_PROGRAM) $(prog) $(DESTDIR)$(bindir)/$(prog)
	-$(INSTALL_DATA) $(progman) $(DESTDIR)$(man1dir)/$(progman)

installdirs: FORCE
	$(INSTALL) -d $(DESTDIR)$(bindir)
	-$(INSTALL) -d $(DESTDIR)$(man1dir)

# See the `install` target for an explanation of the gross prelude.
installshim: FORCE $(shim) $(shimman) install
	@for p in $(DESTDIR)$(bindir)/$(shim) $(DESTDIR)$(man1dir)/$(shimman); \
do \
    if test -d "$$p"; \
    then \
        printf 'will not overwrite directory: %s\n' "$$p" >&2; \
        exit 1; \
    fi; \
done
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


# ---------------
# "PRIVATE" RULES

# TODO: Decide if SOURCE_DATE_EPOCH is worth bothering with [1][2][3].
$(progman) $(shimman): $(prog).adoc
	$(ASCIIDOCTOR) --backend=manpage $(ASCIIDOCTORFLAGS) $(prog).adoc

# Portably imitate .DELETE_ON_ERROR [4] because m4(1) may fail after the
# shell creates/truncates the target.
.m4:
	$(do_m4) $< >$@ || $(do_cleanup)
	-chmod +x $@

# Imitate .PHONY portably [5].
FORCE:


# ----------
# REFERENCES
#
#  1. https://docs.asciidoctor.org/asciidoc/latest/attributes/document-attributes-ref/#note-sourcedateepoch
#  2. https://reproducible-builds.org/docs/source-date-epoch/
#  3. https://reproducible-builds.org/specs/source-date-epoch/
#  4. https://www.gnu.org/software/make/manual/html_node/Errors.html
#  5. https://www.gnu.org/software/make/manual/html_node/Force-Targets
