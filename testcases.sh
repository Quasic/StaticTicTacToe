#!/bin/bash
x=0
if cd "$(dirname "${BASH_SOURCE[0]}")/tictactoe"
then printf 'Testing you moving first...\n'
	bash testcases.sh
	r=$?
	if cd c
	then printf 'Testing me moving first...\n'
		bash testcases.sh
		r=$((r+$?))
	else r=$((r+1))
		x=1
	fi
else r=1
	x=1
fi
printf '%i errors total\n' "$r"
if [ "$x" = 1 ]
then r=255
else [ 254 -lt "$r" ]&&r=254
fi
[[ $- = *i* ]]&&read -rn1 -p "Press a key to return $r..."
exit "$r"
