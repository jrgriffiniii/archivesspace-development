xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC209.EAD.xml");:)

(:let $furniture_to_move := $eads//ead:dsc[1]//ead:did[ead:container[@type='cabinet'] and ead:container[@type='drawer'] and ead:container[@type='folder'] and count(ead:container)=3]:)
let $furniture_to_move := $eads//ead:dsc[1]//ead:did[ead:container[@type='cabinet'] and ead:container[@type='drawer'] and not(ead:container[@type='folder']) and count(ead:container)=2]

for $furniture-item in $furniture_to_move

return
(
insert node <physloc xmlns='urn:isbn:1-931666-22-9'>{for $container in $furniture-item/ead:container[@type='cabinet' or @type='drawer'] return $container/data(@type) || ' ' || $container/text()}</physloc> as last into $furniture-item,
delete node $furniture-item/ead:container[@type='cabinet' or @type='drawer'],
delete node $furniture-item/ead:physdesc/ead:extent[@type='computed'],
if($furniture-item/ead:physdesc)
then insert node <extent xmlns='urn:isbn:1-931666-22-9' type='computed'>1 oversize folder</extent> as last into $furniture-item//ead:physdesc
else insert node <physdesc xmlns='urn:isbn:1-931666-22-9'><extent xmlns='urn:isbn:1-931666-22-9' type='computed'>1 oversize folder</extent></physdesc> as last into $furniture-item
)