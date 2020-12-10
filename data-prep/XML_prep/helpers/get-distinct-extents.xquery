xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC209.EAD.xml");:)

let $extents := $eads//ead:extent

return
distinct-values(
for $extent in $extents
return
normalize-space(
$extent || '*' || $extent/@type || '*' || $extent/@unit
)
||codepoints-to-string(10)
)

(:replace($extent, '^\d+(\.\d+)?\s', ''):)