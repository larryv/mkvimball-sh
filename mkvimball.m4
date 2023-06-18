changequote([, ])dnl
divert(1)dnl
dnl
dnl
dnl mkvimball.m4
dnl ------------
dnl
dnl SPDX-License-Identifier: CC0-1.0
dnl
dnl Written in 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
dnl
# To the extent possible under law, the author has dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
dnl
dnl
divert[]dnl
#!/bin/sh -

# mkvimball - Compatibility shim for mkvimball-sh 0.2
# ---------------------------------------------------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2022 by Lawrence Velazquez <vq@larryv.me>.
#
undivert(1)

# This shim provides drop-in compatibility with Charles E. Campbell's
# original `mkvimball` [*].  It doesn't recognize options or the
# conventional "--" end-of-options marker.  It rejects output paths
# containing "." and appends the deprecated ".vba" suffix to others.
#
#   [*]: https://www.drchip.org/astronaut/src/index.html#MKVIMBALL


# I've done terrible things here, in the name of portability.  To keep
# this file lean(-ish), I've shunted notes on those things to the wiki:
# https://github.com/larryv/mkvimball-sh/wiki/Portability


# TODO: Implement weird interactive mode.


if test "$#" -lt 2; then
    echo >&2 'usage: mkvimball archivebase file ...'
    exit 1
fi

case $1 in
    *.*)
        cat >&2 <<EOF
mkvimball: archivebase cannot contain '.': $1
EOF
        exit 1
        ;;
esac

archivepath=$1.vba
[shift]

ifdef([__MKVIMBALL_SH__], [], [define([__MKVIMBALL_SH__], [mkvimball-sh])])dnl
case $# in
    0) exec defn([__MKVIMBALL_SH__]) -f "$archivepath" ;;
    *) exec defn([__MKVIMBALL_SH__]) -f "$archivepath" -- "$@" ;;
esac
