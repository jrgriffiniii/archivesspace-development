xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

let $physdescs := $eads//ead:did[
count(ead:physdesc/ead:extent[@altrender='spaceoccupied'])>1
or
ead:physdesc/ead:extent[@unit=../following-sibling::ead:physdesc/ead:extent/@unit]
]

for $physdesc in $physdescs
return $physdesc
