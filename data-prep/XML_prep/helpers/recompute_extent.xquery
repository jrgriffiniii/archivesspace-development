xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC209.EAD.xml");:)

let $extents_to_recompute := $eads//ead:dsc[1]//ead:did[((ead:container[@type='folder'] and count(ead:container)=1) or not(ead:container)) and ead:physloc[matches(., 'cabinet')]]/ead:physdesc/ead:extent[@type='computed']
for $physloc in $extents_to_recompute/..
return
(
delete node $physloc/ead:extent[@type='computed'],
insert node <extent xmlns="urn:isbn:1-931666-22-9" type='computed'>1 oversize folder</extent> into $physloc
)