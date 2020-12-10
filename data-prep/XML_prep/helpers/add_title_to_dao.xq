xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare copy-namespaces no-preserve, inherit;

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:////Users/heberleinr/Documents/SVN Working Copies/trunk/rbscXSL/ASpace_files_barcode_model/C0794.xml");:)

for $ead in $eads
let $dao := $ead//ead:dsc[1]//ead:dao
return
	(
	for $d in $dao[not(@xlink:title)]
	return
		insert node attribute xlink:title {"View ditigal content"}
			into $d,
	
	for $d in $dao[@xlink:title]
	return
		replace value of node $d/@xlink:title
			with "View digital content"
	)