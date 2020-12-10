xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $eads as document-node()* := collection("../../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

for $ead in $eads
let $physloc-texts := $ead//ead:dsc[2]//ead:physloc[@type="text"][not(matches(., "^\p{Lu}{1,2}$"))] 

let $distinct-texts := $physloc-texts[matches(., 'glass plate storage', 'i')]
for $text in $distinct-texts
return
$text

(:1843 total:)
(:93 D-Zone:)
(:12 glass-plate storage:)