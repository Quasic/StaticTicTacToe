# gawk
function fail(m){
	X++
	print "\x1b[31m"m"\x1b[0m"
}
/^(<![Dd][Oo][Cc][Tt][Yy][Pp][Ee] html>|<html><head>|<\/head><body>|<title>Quasic's Static Tic-Tac-Toe<\/title>|<h1>Tic-Tac-Toe<\/h1>|<\/body><\/html>)$/{next}
/<link rel="stylesheet" href="(|\.\.\/)board\.css" type="text\/css" \/>/{
if(LNK&&LNK!=$0)fail("link doesn't match in "FILENAME)
LNK=$0
next
}
/^<p id="board">$/{
	S=""
	delete BRD
	inboard=1
	next #start board on new line
}
inboard{
	if(inboard<3)sub(/<[Bb][Rr]>$/,"")
	else sub(/<\/[Pp]>.*$/,"")
	gsub(/&nbsp;/," ")
	if(!length)wa="   "
	else if(length==1)wa=$0"  "
	else if(length==2)wa=$0" "
		match($0,/^([ XO]|<a [^>]+>[XO]<\/a>)([ XO]|<a [^>]+>[XO]<\/a>)([ XO]|<a [^>]+>[XO]<\/a>)$/,BRD)
	gsub(/( |<a [^>]+>[XO]<\/a>)/,"_")
	if(!length)S=S"___"
	else if(length==1)S=S $0"__"
	else if(length==2)S=S $0"_"
	else S=S $0
	inboard++ # base 1 counter
	if(inboard<4)next
	sub(/_+$/,"",S)
	if(toupper(S)!=S)fail("board "S" has lowercase letters in "FILENAME)
	if(tolower(S)".html"!=FILENAME&&tolower(S)"t.html"!=FILENAME)fail("board "S" doesn't match "FILENAME)
	checkedboard=1
	inboard=0
	next
}
/<p id="msg">/{
if($0 in MSGS)fail("Msg duplicated in "FILENAME": "$0)
MSGS[$0]=1
MSG=$0
next
}
/<p id="foot">/{
if(FOOT&&FOOT!=$0)fail("foot doesn't match in "FILENAME)
FOOT=$0
next
}
{fail("Unknown line "FNR" in "FILENAME": "$0)}
ENDFILE{
	if(!checkedboard)fail("no board found in "FILENAME)
	checkedboard=0
}
END{exit X}
