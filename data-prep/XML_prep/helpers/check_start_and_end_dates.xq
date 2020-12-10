xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare copy-namespaces no-preserve, inherit;

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml");:)

let $suspect-date := 
for $date in $eads//ead:dsc[1]//ead:unitdate
let $start := 
	for $d in $date/tokenize(@normal, '/')[1] 
	return
	if(matches($d, '^-?\d{4}$'))
	then concat($d, '-01-01') cast as xs:date
	else if(matches($d, '^-?\d{4}-\d{2}$'))
	then concat($d, '-01') cast as xs:date
	else $d cast as xs:date
let $end := 
	for $d in $date/tokenize(@normal, '/')[2] 
	return
	if(matches($d, '^-?\d{4}$'))
	then concat($d, '-12-30') cast as xs:date
	else if(matches($d, '^-?\d{4}-\d{2}$'))
	then concat($d, '-12') cast as xs:date
	else $d cast as xs:date
return
	if($start > $end)
	then $date
	else()

for $s in $suspect-date
return $s/../../data(@id) || ' ' || $s || codepoints-to-string(10)