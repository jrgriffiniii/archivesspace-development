declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

let $extents := $eads//ead:archdesc/ead:did/ead:physdesc/ead:extent
let $feet := $extents[@unit='linearfootage' or matches(., '(feet)|(foot)|(ft)', 'i')]

return count($extents) || ' ' || count($feet)