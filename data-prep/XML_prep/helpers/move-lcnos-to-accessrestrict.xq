xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml");:)

for $ead in $eads
let $unitids :=
$ead//ead:archdesc/ead:did[count(ead:unitid)>1]/ead:unitid[not(.=$ead//ead:eadid)]
for $unitid in $unitids
return
(
(
if ($unitid/../../ead:descgrp/ead:accessrestrict)
then insert node <p xmlns='urn:isbn:1-931666-22-9'>{$unitid/text()}</p> as first into ($unitid/../../ead:descgrp/ead:accessrestrict)
else if ($unitid/../../ead:descgrp[@id="dacs4"])
then insert node <accessrestrict type='open' xmlns='urn:isbn:1-931666-22-9'><p xmlns='urn:isbn:1-931666-22-9'>{$unitid/text()}</p></accessrestrict> as first into $unitid/../../ead:descgrp[@id="dacs4"]	
else if ($unitid/../../ead:accessrestrict)
then insert node <p xmlns='urn:isbn:1-931666-22-9'>{$unitid/text()}</p> as first into $unitid/../../ead:accessrestrict
else insert node <accessrestrict type='open' xmlns='urn:isbn:1-931666-22-9'><p xmlns='urn:isbn:1-931666-22-9'>{$unitid/text()}</p></accessrestrict> after $unitid/..	
),
delete node $unitid
)