xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $eads as document-node()* := collection("../../eads/mudd/univarchives?select=*.xml;recurse=yes")/doc(document-uri(.));
(:declare variable $eads as document-node()* := doc("../../eads/mudd/univarchives/AC120.EAD.xml");
:)declare variable $top_containers := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/top_containers_classic.xml");

for $ead in $eads
let $classic-top-containers := $ead//ead:dsc[1]//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][not(matches(., 'primary run', 'i'))][1]
let $classic-sub-containers := $ead//ead:dsc[1]//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][position()>1]
let $container-entities := $top_containers//c[not(matches(container, 'primary run', 'i'))][@eadid=$ead//ead:eadid/text()]
return
(
for $classic-top-container in $classic-top-containers
let $matching-entity := $container-entities
						[lower-case(normalize-space(container/@type))=lower-case(normalize-space($classic-top-container/@type)) and 
						lower-case(normalize-space(container/text()))=lower-case(normalize-space($classic-top-container/text()))]
return 
insert nodes (
attribute encodinganalog {$matching-entity/data(@id)},
attribute label {"mixed materials [" || $matching-entity/data(@id) || "]"}
)
into $classic-top-container,

for $classic-sub-container in $classic-sub-containers
let $matching-entity := $container-entities
						[lower-case(normalize-space(container/@type))=lower-case(normalize-space($classic-sub-container/../ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][1]/@type)) and 
						lower-case(normalize-space(container/text()))=lower-case(normalize-space($classic-sub-container/../ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][1]/text()))]
return 
insert node 
attribute encodinganalog {$matching-entity/data(@id)}
into $classic-sub-container
)