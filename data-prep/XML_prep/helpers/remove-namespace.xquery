xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN Working Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN%20Working%20Copies/trunk/rbscXSL/ASpace_files/C0108.xml");:)

for $ead in subsequence($eads, 1, 300)
let $root := $ead//ead:ead

return
	replace node $root
		with
		functx:change-element-ns(
		$root, "", ""
		)