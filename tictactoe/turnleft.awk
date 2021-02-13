BEGINFILE{
F=turnleft(FILENAME)"~"
print "Creating "F
}
function fail(m){
	X++
	print "\x1b[31m"m"\x1b[0m"
}
/<p id="board">/{
	print>F
	delete S
	inboard=1
	next #start board on new line
}
inboard{
	if(inboard<3)sub(/<[Bb][Rr]>$/,"")
	else sub(/<\/[Pp]>.*$/,"")
	gsub(/&nbsp;/," ")
	if(!length)$0="   "
	else if(length==1)$0=$0"  "
	else if(length==2)$0=$0" "
	match($0,/^([ XO]|<a [^>]+>[XO]<\/a>)([ XO]|<a [^>]+>[XO]<\/a>)([ XO]|<a [^>]+>[XO]<\/a>)$/,M)
	for(i=1;i<4;i++)if(match(M[i],/^<a href="([ox_t]+\.html)">(X|O)<\/a>$/,L))M[i]="<a href=\""turnleft(L[1])"\">"L[2]"</a>"
	S[inboard*3-3]=M[1]
	S[inboard*3-2]=M[2]
	S[inboard*3-1]=M[3]
	inboard++ # base 1 counter
	if(inboard<4)next
	print (S[2]==" "?"&nbsp;":S[2])S[5]S[8]"<br>">F
	print (S[1]==" "?"&nbsp;":S[1])S[4]S[7]"<br>">F
	print (S[0]==" "?"&nbsp;":S[0])S[3]S[6]"</p>">F
	checkedboard=1
	inboard=0
	next
}
{print>F}
ENDFILE{
	if(!checkedboard)fail("no board found in "FILENAME)
	checkedboard=0
}
END{exit X}
function turnleft(f){
	if(!match(f,/^([ox_]+)(t?\.html~*)$/,T)){
		fail(f" doesn't match turnleft")
		exit
	}
	t=T[1]
	while(length(t)<9){
		t=t"_"
	}
	t=substr(t,3,1)substr(t,6,1)substr(t,9,1)substr(t,2,1)substr(t,5,1)substr(t,8,1)substr(t,1,1)substr(t,4,1)substr(t,7,1)
	sub(/_+$/,"",t)
	return t T[2]
}
