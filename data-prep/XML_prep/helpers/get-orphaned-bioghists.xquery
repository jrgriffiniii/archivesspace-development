xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $eads as document-node()* := collection("../../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

for $ead in $eads
let $bioghists := $ead//ead:bioghist[not(../ead:did/ead:origination) or not(count(../ead:did/ead:origination/*) = count(../ead:bioghist))]

return
for $bioghist in $bioghists
return
(
if($bioghist/../self::ead:c)
then $bioghist/../data(@id)
else $bioghist/ancestor::ead:ead//ead:eadid) || ' : ' ||
normalize-space($bioghist) || codepoints-to-string(10)