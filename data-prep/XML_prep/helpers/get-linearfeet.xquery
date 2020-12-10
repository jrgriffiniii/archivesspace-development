declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mss/C1247.EAD.xml");
:)

let $linearfeet := $eads//ead:extent[@unit='linearfeet']

return

<results>
{
for $linearfoot in $linearfeet[not(ancestor::ead:c)]
return
<extent-result>
<eadid>{$linearfoot/ancestor::ead:ead//ead:eadid/text()}</eadid>
<extent unit="linearfeet" altrender="spaceoccupied">{$linearfoot/text()}</extent>
</extent-result>,
for $linearfoot in $linearfeet[ancestor::ead:c]
return
<extent-result>
<cid>{$linearfoot/ancestor::ead:c[1]/data(@id)}</cid>
<extent unit="linearfeet" altrender="spaceoccupied">{$linearfoot/text()}</extent>
</extent-result>
}
</results>