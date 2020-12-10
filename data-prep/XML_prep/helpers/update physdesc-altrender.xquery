xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

let $physdescs := $eads//ead:did[
count(ead:physdesc[@altrender='whole'])>1
and count(ead:physdesc/ead:extent[@altrender='carrier'])>1
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='volume'] and ead:physdesc/ead:extent[@altrender='carrier' and (@unit='page' or @unit='folio')])
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='box'] and ead:physdesc/ead:extent[@altrender='carrier' and @unit='item'])
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='box'] and ead:physdesc/ead:extent[@altrender='carrier' and @unit='reel'])
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='box'] and ead:physdesc/ead:extent[@altrender='carrier' and @unit='volume'])
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='box'] and ead:physdesc/ead:extent[@altrender='carrier' and @unit='page'])
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='item'] and ead:physdesc/ead:extent[@altrender='carrier' and @unit='page'])
and not(ead:physdesc/ead:extent[@altrender='carrier' and @unit='item'] and ead:physdesc/ead:extent[@altrender='carrier' and @unit='leaf'])

and not(ead:physdesc/ead:extent[@altrender='carrier' and (@unit='digitalfiles' or @unit='website')])
]

for $physdesc in $physdescs[count(ead:physdesc)>1]/ead:physdesc[@altrender='whole' and ead:extent[@altrender='carrier']]
return replace value of node $physdesc/@altrender with 'part'