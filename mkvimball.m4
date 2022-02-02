#!/bin/sh -

# mkvimball - Compatibility shim for mkvimball-sh 0.0
# ---------------------------------------------------
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


# This shim provides drop-in compatibility with Charles E. Campbell's
# original `mkvimball` [*].  It doesn't recognize options or the
# conventional "--" end-of-options marker.  It rejects output paths
# containing "." and appends the deprecated ".vba" suffix to others.
#
#   [*]: https://www.drchip.org/astronaut/src/index.html#MKVIMBALL

# TODO: Implement weird interactive mode.


if test "$#" -lt 2; then
    echo "usage: mkvimball outputname inputfile ..." >&2
    exit 1
fi

case $1 in
    *.*)
        cat >&2 <<EOF
mkvimball: outputname cannot contain '.': $1
EOF
        exit 1
        ;;
esac

outputpath=$1.vba
`shift'

case $# in
    0) exec __MKVIMBALL_SH__ "$outputpath" ;;
    *) exec __MKVIMBALL_SH__ "$outputpath" "$@" ;;
esac
