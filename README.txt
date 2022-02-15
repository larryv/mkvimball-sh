mkvimball-sh README
===================

SPDX-License-Identifier: CC0-1.0

Written in 2022 by Lawrence Velázquez <vq@larryv.me>.

This is a public-domain [1] rewrite of Charles E. Campbell's
`mkvimball` [2] utility for creating vimball [3] archives.  Written in
portable Bourne shell, it can serve as a replacement for noninteractive
uses on a wide range of Unix and Unix-like systems.  A shim is available
for drop-in compatibility with `mkvimball`.


Requirements
------------

-   A relatively recent Bourne or Bourne-compatible (including
    POSIX-conformant [4]) shell, available at `/bin/sh`.

-   The typical Unix utilities, plus a couple that could be considered
    atypical:

    -   `m4` [5] for creating the compatibility shim.
    -   `make` [6] for installation.

    POSIX conformance [7] is ideal, but minor transgressions are fine.

-   Asciidoctor [8] for regenerating the manual pages.  Only necessary
    if modifying the documentation source.


Installation / Uninstallation
-----------------------------

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
`prefix` [9] macro when invoking `make`.  For example:

    cd /path/to/this/repo && make prefix=/opt installshim
    cd /path/to/this/repo && make prefix=/opt uninstall uninstallshim

The `bindir`, `datarootdir`, `exec_prefix`, `man1dir`, and `mandir`
macros are supported for unorthodox installation hierarchies [9].  The
`DESTDIR` macro is supported for staged installs [10].  The
`ASCIIDOCTOR`, `INSTALL`, `INSTALL_DATA`, `INSTALL_PROGRAM`, and `M4`
macros are supported for using alternate tools [11].


Usage
-----

    mkvimball-sh <outputfile> <inputfile> ...

The `mkvimball-sh` utility copies the contents of the text files [12]
named by the <inputfile> operands to a vimball archive at <outputfile>.

    mkvimball outputname inputfile ...

The `mkvimball` shim provides drop-in compatibility with the original
`mkvimball`.  It rejects <outputname> if it contains a "." character;
otherwise, it writes the archive to `<outputname>.vba`.

Consult the man page for more details.


Legal
-----

The bundled `install-sh` utility was copyrighted in 1994 by the
X Consortium and distributed under the X11 License [13]; subsequent
changes by the Free Software Foundation are in the public domain.

The remainder of this work was written in 2022 by Lawrence Velazquez and
published from the United States of America using the CC0 1.0 Universal
Public Domain Dedication [1].


References
----------

 1. https://creativecommons.org/publicdomain/zero/1.0/
 2. https://www.drchip.org/astronaut/src/index.html#MKVIMBALL
 3. https://www.drchip.org/astronaut/vim/index.html#VIMBALL
 4. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
 5. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/m4.html
 6. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html
 7. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap04.html
 8. https://asciidoctor.org/
 9. https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
10. https://www.gnu.org/software/make/manual/html_node/DESTDIR.html
11. https://www.gnu.org/software/make/manual/html_node/Command-Variables.html
12. https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_403
13. https://spdx.org/licenses/X11.html
