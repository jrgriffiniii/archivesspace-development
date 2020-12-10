declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));
:)
declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mss/C1247.EAD.xml");

for $ead in $eads
let $emphs := $ead//ead:emph

for $emph in $emphs 
return
replace node $emph with $emph/string()