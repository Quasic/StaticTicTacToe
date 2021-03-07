@include "./chkboard"
ENDFILE{
	F=turnleft(FILENAME)"~"
	print "Creating "F
	print "<!DOCTYPE html>">F
	print "<html><head>">F
	print "<title>Quasic's Static Tic-Tac-Toe</title>">F
	print LNK>F
	print "</head><body>">F
	print "<h1>Tic-Tac-Toe</h1>">F
	print "<p id=\"board\">">F
	for(i=0;i<9;i++)if(match(BRD[i],/^<a href="([ox_t]+\.html)">(X|O)<\/a>$/,M))BRD[i]="<a href=\""turnleft(M[1])"\">"M[2]"</a>"
	print (BRD[2]==" "?"&nbsp;":BRD[2])BRD[5]BRD[8]"<br>">F
	print (BRD[1]==" "?"&nbsp;":BRD[1])BRD[4]BRD[7]"<br>">F
	print (BRD[0]==" "?"&nbsp;":BRD[0])BRD[3]BRD[6]"</p>">F
	print "<p id=\"msg\"></p>">F
	print FOOT>F
	print "</body></html>">F
}
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
