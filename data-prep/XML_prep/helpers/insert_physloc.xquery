xquery version "1.0";
declare copy-namespaces no-preserve, inherit;

import module namespace functx="http://www.functx.com" 
    at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare namespace ead="urn:isbn:1-931666-22-9";

declare variable $NOTE as document-node()* := doc("file:/Users/heberleinr/Documents/SVN%20Working%20Copies/trunk/rbscXSL/EAC/physlocs_to_insert.xml");
let $records := $NOTE//record

let $distinct-callnos := distinct-values($records//callno/text())
let $file := for $ead in $distinct-callnos
		return 
		if(starts-with($ead, 'A'))
		then "../../eads/mudd/univarchives/" || normalize-space($ead) || ".EAD.xml"
		else "../../eads/mudd/publicpolicy/" || normalize-space($ead) || ".EAD.xml"
	 
for $f in $file
let $ead-items := doc($f)//ead:dsc[2]//ead:did

for $i in $ead-items/ead:unitid[@type="barcode" and .=$records/barcode]
let $size := $records[barcode=$i]/physloc/text()
return 
insert node <physloc xmlns="urn:isbn:1-931666-22-9" type="text">{$size}</physloc> as last into $i/..

(:for $i in $holding/ead:unitid[@type="barcode" and .=$note/Barcode]
let $size := $note[Barcode=$i]/Size/text()
return 
insert node <physloc xmlns="urn:isbn:1-931666-22-9" type="text">{$size}</physloc> as last into $i/..:)