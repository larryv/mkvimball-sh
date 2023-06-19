mkvimball-sh
============

This is a public-domain [1] rewrite of Charles E. Campbell's
`mkvimball` [2] utility for creating vimball [3] archives.  Written in
portable Bourne shell, it can serve as a replacement for noninteractive
uses on a wide range of Unix and Unix-like systems.  A shim is available
for drop-in compatibility with `mkvimball`.


Requirements
------------

  - A relatively recent Bourne or Bourne-compatible (including
    POSIX-conformant [4]) shell, available at `/bin/sh`.

  - The typical Unix utilities, plus a couple that could be considered
    atypical:

      - `m4` [5] for creating the compatibility shim.
      - `make` [6] for installation.

    POSIX conformance [7] is ideal, but minor transgressions are fine.

  - ShellCheck [8] for optional testing.

  - Asciidoctor [9] for regenerating the manual pages.  Only necessary
    if modifying the documentation source.


Installation, etc.
------------------

To install/uninstall the `mkvimball-sh` utility to/from `/usr/local`
(privileges required, presumably):

    cd /path/to/this/repo && make install
    cd /path/to/this/repo && make uninstall

To avoid overwriting the original `mkvimball`, the standard targets omit
the compatibility shim, which is also named `mkvimball`.  To install
both `mkvimball-sh` and the shim:

    cd /path/to/this/repo && make installshim

To uninstall the shim (but not `mkvimball-sh`):

    cd /path/to/this/repo && make uninstallshim

To use an installation prefix other than `/usr/local`, define the
`prefix` [10] macro when invoking `make`.  For example:

    cd /path/to/this/repo && make prefix=/opt installshim
    cd /path/to/this/repo && make prefix=/opt uninstall uninstallshim

To run basic tests:

    cd /path/to/this/repo && make check

The `bindir`, `datarootdir`, `exec_prefix`, `man1dir`, and `mandir`
macros are supported for unorthodox installation hierarchies [10].  The
`DESTDIR` macro is supported for staged installs [11].  The
`ASCIIDOCTOR` (with `ASCIIDOCTORFLAGS`), `INSTALL`, `INSTALL_DATA`,
`INSTALL_PROGRAM`, `M4` (with `M4FLAGS`), and `SHELLCHECK` (with
`SHELLCHECKFLAGS`) macros are supported for using alternate tools [12].


Usage
-----

    mkvimball-sh [-a] [-f <archive>] [--] [<file> ...]

The `mkvimball-sh` utility copies the contents of its input text files
[13] to a vimball archive.  The input files can be specified as <file>
operands or as a list of LF-terminated paths on standard input.  The
archive is written to standard output or, if `-f` is specified, to
<archive>.  If `-a` is specified, the archive header is omitted from the
output so it can be appended to an existing archive; if both `-a` and
`-f` are specified, <archive> is appended to instead of overwritten.

    mkvimball <archivebase> <file> ...

The `mkvimball` shim provides drop-in compatibility with the original
`mkvimball`.  It rejects <archivebase> if it contains a "." character;
otherwise, it writes the archive to `<archivebase>.vba`.

Consult the man page for more details.


Legal
-----

To the extent possible under law, the author has dedicated [1] all
copyright and related and neighboring rights to this software to the
public domain worldwide.  This software is published from the United
States of America and distributed without any warranty.

Refer to `install-sh` for its separate licensing terms.


References
----------

 1. https://creativecommons.org/publicdomain/zero/1.0/
 2. https://www.drchip.org/astronaut/src/index.html#MKVIMBALL
 3. https://www.drchip.org/astronaut/vim/index.html#VIMBALL
 4. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
 5. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/m4.html
 6. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html
 7. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap04.html
 8. https://www.shellcheck.net
 9. https://asciidoctor.org
10. https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
11. https://www.gnu.org/software/make/manual/html_node/DESTDIR.html
12. https://www.gnu.org/software/make/manual/html_node/Command-Variables.html
13. https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_403


SPDX-License-Identifier: CC0-1.0

Written in 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
