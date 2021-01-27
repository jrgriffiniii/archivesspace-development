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
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files/AC208.xml")

);
declare variable $agents as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_A-F.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_G-Z.xml")
);

let $file := distinct-values($agents//eadid)

for $ead in $eads[//ead:eadid = $file]
let $cid := $ead//ead:dsc[1]//ead:c/@id
let $eadid := $ead//ead:eadid/text()
let $agents := $agents//cid[not(.='') and . = $cid]
let $fields := 
	for $agent-link in $agents
	let $component := $ead//ead:dsc[1]//ead:c[@id = $agent-link]
	let $field-name := functx:change-element-ns($agent-link/../field, 'urn:isbn:1-931666-22-9"', '')
	return ($component/ead:did/*[name()=$field-name], $component/*[name()=$field-name])

for $field in $fields
let $agent-link := $agents/*[cid = $field/*[ancestor::ead:c[1]/@id]]
let $delete-field := every $name in $field/* satisfies contains(normalize-space($name), normalize-space($agent-link/name-old))
return
if ($delete-field = true())
then "delete " || $field/ancestor::ead:c[1]/@id || codepoints-to-string(10)
else "dont delete " || $field/ancestor::ead:c[1]/@id || codepoints-to-string(10)
