xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

let $unitids-to-move := $eads//ead:archdesc/ead:did/ead:unitid[not(.=./ancestor::ead:ead//ead:eadid)]
for $unitid in $unitids-to-move
return
(
insert node 
	<unitid xmlns="urn:isbn:1-931666-22-9" countrycode="US" repositorycode="US-NjP" type="collection">{$unitid/ancestor::ead:ead//ead:eadid/text()}</unitid>
after $unitid,
insert node <note xmlns="urn:isbn:1-931666-22-9"><p>{$unitid/text()}</p></note> as last into $unitid/..,
delete node $unitid
)