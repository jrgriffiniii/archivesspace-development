xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $eads as document-node()* := collection("../../eads/mudd/univarchives?select=*.xml;recurse=yes")/doc(document-uri(.));

let $primary-run-containers := $eads//ead:dsc[1]//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][matches(., 'primary run', 'i')]

for $primary-run in $primary-run-containers
return 
(
insert node <physloc xmlns="urn:isbn:1-931666-22-9">{$primary-run/text()}</physloc> as last into $primary-run/..,
delete node $primary-run
)