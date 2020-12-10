xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml");:)

(:let $unitdates := $eads//ead:unitdate[not(@certainty) and matches(., '^((circa)|(ca\.)|(c\.)|(approximately))', 'i')]
for $unitdate in $unitdates
return
insert node attribute certainty {'approximate'} into $unitdate:)

(:let $unitdates := $eads//ead:unitdate[not(@certainty) and matches(., '[?]')]
for $unitdate in $unitdates
return
insert node attribute certainty {'uncertain'} into $unitdate:)

let $unitdates := $eads//ead:unitdate[not(@certainty) and matches(., '(century)|(\d{4}s)', 'i')]
for $unitdate in $unitdates
return 
insert node attribute certainty {'approximate'} into $unitdate