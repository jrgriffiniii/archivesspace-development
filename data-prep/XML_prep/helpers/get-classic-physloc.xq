xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $eads as document-node()* := collection("../../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

for $ead in $eads
let $physloc-texts := $ead//ead:dsc[1]//ead:physloc
for $text in $physloc-texts
return
$text/../../@id || '*' || $text || codepoints-to-string(10)