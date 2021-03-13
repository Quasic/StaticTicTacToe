BEGIN{
	if(!match(F,/^(c\/|)([xo_]+)\.html~*$/,M)){
		print "I don't understand F="F
		exit 1
	}
	print "Creating "F
	gsub(/_/," ",M[2])
	while(length(M[2])<9)M[2]=M[2]" "
	for(i=0;i<9;i++)BRD[i]=toupper(substr(M[2],i+1,1))
		MSG=""
		if(BRD[0]!=" "&&BRD[0]==BRD[1]&&BRD[1]==BRD[2])MSG=BRD[2]
		else if(BRD[3]!=" "&&BRD[3]==BRD[4]&&BRD[4]==BRD[5])MSG=BRD[5]
		else if(BRD[6]!=" "&&BRD[6]==BRD[7]&&BRD[7]==BRD[8])MSG=BRD[8]
		else if(BRD[0]!=" "&&BRD[0]==BRD[3]&&BRD[3]==BRD[6])MSG=BRD[6]
		else if(BRD[1]!=" "&&BRD[1]==BRD[4]&&BRD[4]==BRD[7])MSG=BRD[7]
		else if(BRD[2]!=" "&&BRD[2]==BRD[5]&&BRD[5]==BRD[8])MSG=BRD[8]
		else if(BRD[0]!=" "&&BRD[0]==BRD[4]&&BRD[4]==BRD[8])MSG=BRD[8]
		else if(BRD[2]!=" "&&BRD[2]==BRD[4]&&BRD[4]==BRD[6])MSG=BRD[6]
		if(MSG){
			MSG=MSG" won!"
		}else if(M[2]~/ /){
			for(j=0;j<9;j++)B[j]=length(BRD[j])>1||BRD[j]==" "?"_":tolower(BRD[j])
			T0="now "B[0] B[1] B[2]
			T1=" is "B[3] B[4] B[5]
			T2="    "B[6] B[7] B[8]
			if(M[1]=="c/"){
				p="o"
				o="x"
			}else{
				p="x"
				o="o"
			}
			for(i=0;i<9;i++)if(BRD[i]==" "){
				S=""
				for(j=0;j<9;j++)if(j==i)S=S (B[j]=p)
				else S=S (B[j]=length(BRD[j])>1||BRD[j]==" "?"_":tolower(BRD[j]))
				if(S~/_/){
					B0=T0"  if  "B[0] B[1] B[2]"  my  "
					B1=T1" you  "B[3] B[4] B[5]" move "
					B2=T2" move "B[6] B[7] B[8]"  is  "
					if(B[0]=="_"&&((B[1]==o&&B[2]==o)||(B[4]==o&&B[8]==o)||(B[3]==o&&B[6]==o)))B[0]=o
					else if(B[1]=="_"&&((B[0]==o&&B[2]==o)||(B[4]==o&&B[7]==o)))B[1]=o
					else if(B[2]=="_"&&((B[0]==o&&B[1]==o)||(B[5]==o&&B[8]==o)||(B[4]==o&&B[6]==o)))B[2]=o
					else if(B[3]=="_"&&((B[4]==o&&B[5]==o)||(B[0]==o&&B[6]==o)))B[3]=o
					else if(B[4]=="_"&&((B[3]==o&&B[5]==o)||(B[1]==o&&B[7]==o)||(B[0]==o&&B[8]==o)||(B[2]==o&&B[6]==o)))B[4]=o
					else if(B[5]=="_"&&((B[3]==o&&B[4]==o)||(B[2]==o&&B[8]==o)))B[5]=o
					else if(B[6]=="_"&&((B[7]==o&&B[8]==o)||(B[0]==o&&B[3]==o)||(B[4]==o&&B[2]==o)))B[6]=o
					else if(B[7]=="_"&&((B[6]==o&&B[8]==o)||(B[1]==o&&B[4]==o)))B[7]=o
					else if(B[8]=="_"&&((B[6]==o&&B[7]==o)||(B[2]==o&&B[5]==o)||(B[0]==o&&B[4]==o)))B[8]=o
					else if(B[0]=="_"&&((B[1]==p&&B[2]==p)||(B[4]==p&&B[8]==p)||(B[3]==p&&B[6]==p)))B[0]=o
					else if(B[1]=="_"&&((B[0]==p&&B[2]==p)||(B[4]==p&&B[7]==p)))B[1]=o
					else if(B[2]=="_"&&((B[0]==p&&B[1]==p)||(B[5]==p&&B[8]==p)||(B[4]==p&&B[6]==p)))B[2]=o
					else if(B[3]=="_"&&((B[4]==p&&B[5]==p)||(B[0]==p&&B[6]==p)))B[3]=o
					else if(B[4]=="_"&&((B[3]==p&&B[5]==p)||(B[1]==p&&B[7]==p)||(B[0]==p&&B[8]==p)||(B[2]==p&&B[6]==p)))B[4]=o
					else if(B[5]=="_"&&((B[3]==p&&B[4]==p)||(B[2]==p&&B[8]==p)))B[5]=o
					else if(B[6]=="_"&&((B[7]==p&&B[8]==p)||(B[0]==p&&B[3]==p)||(B[4]==p&&B[2]==p)))B[6]=o
					else if(B[7]=="_"&&((B[6]==p&&B[8]==p)||(B[1]==p&&B[4]==p)))B[7]=o
					else if(B[8]=="_"&&((B[6]==p&&B[7]==p)||(B[2]==p&&B[5]==p)||(B[0]==p&&B[4]==p)))B[8]=o
					else{
						S=0
						for(j=0;j<9;j++)if(B[j]=="_"){
							S++
							k=j
						}
						if(S==1){
							B[k]=o
						}else{
							print
							print B0"  um,"
							print B1" what"
							print B2" now?"
							k=""
							while(k!~/^[0-8]$/||B[k]!="_"){
								for(j=0;j<9;j++)if(B[j]=="_"){
									print
									print "Move "j": "(j==0?o:B[0])(j==1?o:B[1])(j==2?o:B[2])
									print "        "(j==3?o:B[3])(j==4?o:B[4])(j==5?o:B[5])
									print "        "(j==6?o:B[6])(j==7?o:B[7])(j==8?o:B[8])
								}
								printf "Please enter choice: "
								getline k
							}
							B[k]=o
						}
					}
					print
					print B0 B[0] B[1] B[2]
					print B1 B[3] B[4] B[5]
					print B2 B[6] B[7] B[8]
					S=""
					for(j=0;j<9;j++)S=S B[j]
				}
				sub(/_+$/,"",S)
				BRD[i]="<a href=\""S".html\">"toupper(p)"</a>"
			}
		}else MSG="We tied."
	print "<!DOCTYPE html>">F
	print "<html><head>">F
	print "<title>Quasic's Static Tic-Tac-Toe</title>">F
	print "<link rel=\"stylesheet\" href=\""(M[1]=="c/"?"../":"")"board.css\" type=\"text/css\" />">F
	print "</head><body>">F
	print "<h1>Tic-Tac-Toe</h1>">F
	print "<p id=\"board\">">F
	row(BRD[0],BRD[1],BRD[2],"<br>")
	row(BRD[3],BRD[4],BRD[5],"<br>")
	row(BRD[6],BRD[7],BRD[8],"</p>")
	S=MSG
	print "Default msg: "S
	print "Please enter message from computer:"
	if(S)print "[Will add retry link]"
	getline MSG
	if(!MSG)MSG=S
	if(S)MSG=MSG" Try again? <a href=\""(M[1]=="c/"?"../":"")"t.html\">Ok</a>"
	print "<p id=\"msg\">"MSG"</p>">F
	print "<p id=\"foot\">"(M[1]=="c/"?"<a href=\"/\">Home</a> | <a href=\"https://github.com/Quasic/StaticTicTacToe/issues\">Report Bugs</a> | <a href=\"../../LICENSE\">CC-BY-NC 4.0</a>":"<a href=\"/\">Home</a> | <a href=\"https://github.com/Quasic/StaticTicTacToe/issues\">Report Bugs</a> | <a href=\"../LICENSE\">CC-BY-NC 4.0</a>")"</p>">F
	print "</body></html>">F
}
function row(a,b,c,e){
	print (a==" "&&b==" "&&c==" "?"":(a==" "?"&nbsp;":a) (c==" "&&b==" "?"":b) (c==" "?"":c))e>F
	print a b c
}