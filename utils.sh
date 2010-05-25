#!/bin/bash

set -e

case "$1" in

    'clean' )   find . -name '*.pyc' -delete
		rm -Rf a b d
    ;;

    'tar' )     $0 clean
		(cd .. ; tar cf lkddb-`date --rfc-3339=date`.tar --exclude='*.list' --exclude='*.data' --exclude='log-*' lkddb ;
		gzip -9 lkddb-`date --rfc-3339=date`.tar)
    ;;

    'print' )   find . -name '*.py' | xargs grep '[^#.]print'
    ;;

    'diff' )
cat "$2" | cut --complement -f 1 | sed 's/::/ /g' | tr '\t' ' ' | sed 's/   */ /g' | sed 's/i2c_snd/i2c-snd/' | sed 's/^\(usb .... ....\) \(..\)\(..\)\(..\) \(..\)\(..\)\(..\) \(.*\)$/\1 \2 \3 \4 \5 \6 \7 \8/p' | sed 's/^\(input .*\)ff ff ff ff\(.*\)$/\1.. .. .. ..\2/g' | sed 's/^\(input .*\)ffff\(.*\)$/\1....\2/g' | sed 's/^\(input .*\)ff\(.*\)$/\1..\2/g' | sed 's/^\(input .*\)ff\(.*\)$/\1..\2/g' | sed 's/^\(input .*\)ff\(.*\)$/\1..\2/g' | sed 's/^sbb /ssb /' | sed 's/^\(pnp "[^"]*"\) \(.*\)$/\1 "" "" "" "" "" "" "" "" \2/' | sed 's/^pnp_card /pnp /' | sort | uniq > a
cat "$3" | sed 's/   */ /g' | sort | uniq > b
diff -u a b > d
    ;;

esac
