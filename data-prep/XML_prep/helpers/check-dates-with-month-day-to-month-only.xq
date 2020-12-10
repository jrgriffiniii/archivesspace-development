xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml");:)

let $unitdates := $eads//ead:unitdate[@normal[matches(., '\d{4}-\d{2}-\d{2}/\d{4}-\d{2}$')]]
let $unitdates-to-address := for $unitdate in $unitdates
		let $range-token := tokenize($unitdate/data(@normal), '/')
		let $year1 := tokenize($range-token[1], '-')[1]
		let $month1 := tokenize($range-token[1], '-')[2]
		let $day1 := tokenize($range-token[1], '-')[3]
		let $year2 := tokenize($range-token[2], '-')[1]
		let $month2 := tokenize($range-token[2], '-')[2]
		return $unitdate[$year1=$year2 and $month1=$month2]

for $unitdate-to-address in $unitdates-to-address
		let $range-token := tokenize($unitdate-to-address/data(@normal), '/')
		let $year1 := tokenize($range-token[1], '-')[1]
		let $month1 := tokenize($range-token[1], '-')[2]
		let $day1 := tokenize($range-token[1], '-')[3]
		let $year2 := tokenize($range-token[2], '-')[1]
		let $month2 := tokenize($range-token[2], '-')[2]
return
(
replace value of node $unitdate-to-address/@normal with $year2 || '-' || $month2,
replace value of node $unitdate-to-address with tokenize(normalize-space($unitdate-to-address), '-\s?')[2]
)
