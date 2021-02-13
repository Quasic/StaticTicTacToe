#!/bin/bash
declare -A M
declare -A feet
declare -A msgs
msgs['<p id="msg"></p>']='<empty>'
declare -A notchk
for f in *.html
do M["$f"]=0
done
warn(){
	printf '\e[33m%s\e[0m\n' "$1"
}
fail(){
	printf '\e[31m%s\e[0m\n' "$1"
	((r++))
}
chkturn(){
	local t
	shopt -s extglob
	t=${1%%*(_)}
	shopt -u extglob
	[ -f "$t.html" ]&&printf '%s can be turned to replace %s\n' "$t.html" "$2"
}
r=0
fpass(){
	[ "${1:0:1}" = x ]||[ "${1:0:1}" = _ ]||[ "${1:0:1}" = o ]||return 0
	[ "${2:0:1}" = x ]||[ "${2:0:1}" = _ ]||[ "${2:0:1}" = o ]||return 0
	local A
	local B
	B="${2:0:${#B}-5}"
	[ "${B:${#B}-1}" = t ]&&return 0
	while [ "${#B}" -lt 9 ]
	do B="${B}_"
	done
	A="${1:0:${#A}-5}"
	[ "${A:${#A}-1}" = t ]&&A="${A:0:${#A}-1}"
	while [ "${#A}" -lt 9 ]
	do A="${A}_"
	done
	local j
	local a
	local b
	local p=0
	local -A C
	C["x"]=0
	C["o"]=0
	local _x=0
	local _o=0
	for j in 0 1 2 3 4 5 6 7 8
	do
		a="${A:$j:1}"
		b="${B:$j:1}"
		if [ "$a" = _ ]
		then
			if [ "$b" = x ]
			then
				if [ "$_x" = 0 ]
				then _x=1
				else
					warn "another new x at position $j in $2 from $1"
					((p++))
				fi
			elif [ "$b" = o ]
			then
				if [ "$_o" = 0 ]
				then _o=1
				else
					warn "another new o at position $j in $2 from $1"
					((p++))
				fi
			elif ! [ "$b" = _ ]
			then
				warn "$b unexpected ($A->$B|$1->$2)"
				((p++))
			fi
		elif [ "$a" = x ]||[ "$a" = o ]
		then
			((C["$a"]++))
			if ! [ "$a" = "$b" ]
			then
				warn "$a changed to $b in ($A->$B|$1->$2)"
				((p++))
			fi
		else
			warn "$a unexpected ($A->$B|$1->$2)"
			((p++))
		fi
	done
	if [ "$_x" = 0 ]
	then
		warn "no new x's from $1 to $2"
		((p++))
	fi
	if [ "$_o" = 0 ]
	then
		if [[ "$B" = *_* ]]
		then
			warn "no new o's from $1 to $2"
			((p++))
		#else tie
		fi
	fi
	#count of x's and o's should be = unless computer first, then one more x
	if [ "$oneMoreX" = 1 ]
	then
		if [ "${C[x]}" -ne "$((${C[o]}+1))" ]
		then
			warn "${C[x]} x's, but ${C[o]} o's (should be 1 more x) in $1"
			((p++))
		fi
	elif ! [ "${C[x]}" = "${C[o]}" ]
	then
		warn "${C[x]} x's, but ${C[o]} o's in $1"
		((p++))
	fi
	#[ "$p" = 0 ]||warn "$p errors in ($A->$B|$1->$2)"
	return "$p"
}
gawk -f "$(dirname "${BASH_SOURCE[0]}")/chkboard.awk" "${!M[@]}"</dev/null
r=$?
for f in "${!M[@]}"
do
	mapfile -t h< <(grep -o 'href="[^"]*\.html"' "$f")
	for i in "${h[@]}"
	do
		i="${i:6:${#i}-7}"
		if [ "$i" = "$f" ]
		then fail "$f links to itself"
		elif ! fpass "$f" "$i"
		then fail "$i doesn't follow from $f"
		elif [ "${M["$i"]+set}" ]
		then M["$i"]=$((M["$i"]+1))
		else
			if [ -f "$i" ]
			then notchk["$i"]="$f"
			else
				t="${i:0:${#i}-5}"
				[ "${t:${#t}-1}" = t ]&&t="${t:0:${#t}-1}"
				while [ "${#t}" -lt 9 ]
				do t="${t}_"
				done
				chkturn "${t:2:1}${t:5:1}${t:8:1}${t:1:1}${t:4:1}${t:7:1}${t:0:1}${t:3:1}${t:6:1}" "$i (from left, 3 turns to convert using turnleft.awk)"
				chkturn "${t:8:1}${t:7:1}${t:6:1}${t:5:1}${t:4:1}${t:3:1}${t:2:1}${t:1:1}${t:0:1}" "$i (updside down, 2 turns to convert using turnleft.awk)"
				chkturn "${t:6:1}${t:3:1}${t:0:1}${t:7:1}${t:4:1}${t:1:1}${t:8:1}${t:5:1}${t:2:1}" "$i (from right, 1 turn to convert using turnleft.awk)"
				fail "$i needs creating for $f"
			fi
		fi
	done
	# if msg=$(grep '<p id="msg">' "$f")
	# then
		# if [ "${msgs["$msg"]+set}" ]
		# then fail "$f duplicates msg from ${msgs["$msg"]}: $msg"
		# else msgs["$msg"]="$f"
		# fi
	# else fail "msg not found in $f"
	# fi
	# if foot=$(grep '<p id="foot">' "$f")
	# then [ "${feet["$foot"]+set}" ]||feet["$foot"]=$f
	# else fail "Footer not found in $f"
	# fi
done
for f in "${!M[@]}"
do
	if [ "${M["$f"]}" = 0 ]
	then fail "$f appears unused"
	#elif ! [ "${M["$f"]}" = 1 ]
	#then printf '#%s has %i incoming links\n' "$f" "${M["$f"]}"
	fi
done
# printf '#Footers:\n# Example File> Footer:\n'
# i=0
# for f in "${!feet[@]}"
# do printf '# %s> %s\n' "${feet["$f"]}" "$f"
	# ((i++))
# done
# if [ 1 -lt "$i" ]
# then
	# printf '\e[31m%i different footers, but should be only one\e[0m\n'
	# ((r+=i-1))
# fi
for f in "${!notchk[@]}"
do warn "Did NOT check $f from ${notchk[$f]}"
done
printf '%i errors\n' "$r"
[ 254 -lt "$r" ]&&r=254
[[ $- = *i* ]]&&read -rn1 -p "Press a key to return $r..."
exit "$r"
