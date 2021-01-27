xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));
:)
declare variable $eads as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files/RBD1.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files/RBD1.1.xml")

);
declare variable $skips as document-node()* := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/RBD1_skips.xml");

let $file := distinct-values($skips//eadid)

for $ead in $eads[//ead:eadid = $file]
let $cid := $ead//ead:dsc[1]//ead:c/@id
let $eadid := $ead//ead:eadid/text()

return

(:controlaccess:)
let $move_to_notes :=  $skips//record
let $components := $ead//ead:c[@id = $move_to_notes/cid]

for $component in $components
let $names := $move_to_notes[cid = $component/@id]/name-old/text() 
return 
(
	insert node
	<note xmlns='urn:isbn:1-931666-22-9'>{
	<p>Other associated terms from legacy data: </p>,
	for $name in $names return <p>{$name}</p>}</note>
	as last into $component,
			
	for $move_to_note in $move_to_notes[cid = $component/@id]
	return
	(
	if(count($component/ead:controlaccess[*[normalize-space(text()) = $move_to_note[cid = $component/@id]/name-old/normalize-space(text())]]/*) = 1)
	then delete node $component/ead:controlaccess[*/normalize-space(text()) = $move_to_note[cid = $component/@id]/name-old/normalize-space(text())]
	else delete node $component/ead:controlaccess/*[normalize-space(text()) = $move_to_note[cid = $component/@id]/name-old/normalize-space(text())],
	
	if(count($component/ead:did/ead:origination[*[normalize-space(text()) = $move_to_note[cid = $component/@id]/name-old/normalize-space(text())]]/*) = 1)
	then delete node $component/ead:did/ead:origination[*/normalize-space(text()) = $move_to_note[cid = $component/@id]/name-old/normalize-space(text())]
	else delete node $component/ead:did/ead:origination/*[normalize-space(text()) = $move_to_note[cid = $component/@id]/name-old/normalize-space(text())]
	)
)	