@load "inplace"
title&&/^<title>.*<\/title>$/{print "<title>"title"</title>">FILENAME;titled=1;next}
foot&&/^<p id="foot".*<\/p>$/{print "<p id=\"foot\">"foot"</p>">FILENAME;footed=1;next}
{print>FILENAME}
END{
	if(title&&!titled){
		print "!titled "FILENAME>"/dev/stderr"
	}
	if(foot&&!footed){
		print "!footed "FILENAME>"/dev/stderr"
	}
}
