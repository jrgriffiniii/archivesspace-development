xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/eng/PPL001.EAD.xml");
:)
let $ead-carriers := $eads//ead:extent[2][@altrender='carrier']

for $ead-carrier in $ead-carriers
return
(
insert node 
$ead-carrier as first into $ead-carrier/..,
delete node $ead-carrier
)