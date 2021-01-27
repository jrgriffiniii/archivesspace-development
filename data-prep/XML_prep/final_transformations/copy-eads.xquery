xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));


for $ead in $eads
let $eadid := $ead//ead:eadid/text()

return
	(
	put($ead,
	concat("/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files/", $eadid, ".xml")
	)
	)