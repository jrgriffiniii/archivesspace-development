xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace functx = "http://www.functx.com";
declare copy-namespaces no-preserve, inherit;

(:import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $COLL as document-node()* := collection("../../eads?recurse=yes;select=*.xml")/doc(document-uri(.));
let $ead := $COLL//ead:ead

for $d in
distinct-values($ead//ead:dsc[2]//ead:physloc[@type = 'text'])
return
	$d || codepoints-to-string(10)