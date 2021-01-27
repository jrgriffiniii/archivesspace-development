xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

declare variable $agents as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_A-F.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_G-Z.xml")
);

(:let $possible-bioghist := $eads//ead:origination[../../ead:bioghist 
				and (not(count(../../ead:bioghist) = count(../ead:origination/*)))]

return 
if($possible-bioghist/ancestor::ead:c[1]/@id)
then $possible-bioghist/ancestor::ead:c[1]/data(@id)
else $possible-bioghist/ancestor::ead:ead//ead:eadid/text():)

let $bios := $agents//bio
let $possible-bioghist := $eads//ead:bioghist

for $bio in $bios
where $bio/../eadid = $possible-bioghist/ancestor::ead:ead//ead:eadid
and (
	$bio/../cid = $possible-bioghist/ancestor::ead:c[1]/data(@id)
	or
	$bio/../cid =' '
	)
and normalize-space(string($bio)) = $possible-bioghist/normalize-space(string(.))
return normalize-space($bio) || ' ' || $bio/../eadid || codepoints-to-string(10)