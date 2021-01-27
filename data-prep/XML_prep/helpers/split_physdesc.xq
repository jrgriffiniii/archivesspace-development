xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

let $physdescs := $eads//ead:physdesc[@altrender='whole' and count(ead:extent)>1 and count(*)=count(ead:extent)]
return
for $physdesc in $physdescs
return
for $extent in $physdesc/ead:extent
return
(
insert node <physdesc altrender="whole" xmlns="urn:isbn:1-931666-22-9">{$extent}</physdesc> after $physdesc,
delete node $physdesc
)

(:declare variable $eads as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml");:)

(:process physdescs without extents:)
(:let $physdescs:= $eads//ead:physdesc
[
(
ead:physfacet
or
ead:dimensions)
and not(ead:extent)
]
for $physdesc in $physdesc
return insert node attribute altrender {'whole'} into $physdesc:)

(:process physdescs with one extent:)
(:let $physdescs:= $eads//ead:physdesc
:)(:[
count(ead:extent)=1
]
for $physdesc in $physdescs
return insert node attribute altrender {'whole'} into $physdesc:)

(:process physdescs with multiple carrier extents and notes:)
(:let $physdescs:= $eads//ead:physdesc[
not(@altrender) 
and (ead:dimensions or ead:physfacet) 
and ead:extent[@altrender='carrier' 
and not(ead:extent[@altrender='spaceoccupied'])]
]
for $physdesc in $physdescs
let $notes := $physdesc/ead:dimensions | $physdesc/ead:physfacet
return
( 
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='whole'>{$notes}</physdesc>
as last into $physdesc/..,
for $extent in $physdesc/ead:extent
return
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='whole'>{$extent}</physdesc>
as last into $physdesc/..,
delete node $physdesc
):)

(:process diverging @altrender:)
(:let $physdescs:= $eads//ead:physdesc[
not(@altrender)
and not(ead:dimensions or ead:physfacet)
and ead:extent[@altrender='carrier']
and ead:extent[@altrender='spaceoccupied']
and count(ead:extent)=2
]
for $physdesc in $physdescs
return
insert node attribute altrender {'whole'} into $physdesc:)

(:process divergent physdescs:)
(:let $physdescs:= $eads//ead:physdesc[
not(@altrender)
and not(ead:dimensions or ead:physfacet)
and count(ead:extent[@altrender='carrier'])>1
and count(ead:extent[@altrender='spaceoccupied'])=1
and count(ead:extent)>2
]
for $physdesc in $physdescs
return 
(
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='whole'>{$physdesc/ead:extent[@altrender='spaceoccupied']}</physdesc>
as last into $physdesc/..,
for $carrier in $physdesc/ead:extent[@altrender='carrier']
return
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='part'>{$carrier}</physdesc>
as last into $physdesc/..,
delete node $physdesc
):)

(:process known partial carriers:)
(:let $physdescs:= $eads//ead:physdesc
[
not(ead:extent[@altrender='spaceoccupied'])
and count(ead:extent[@altrender='carrier'])>1
and count(ead:extent)>1
and not(ead:dimensions)
and not(ead:physfacet)
and
(
(ead:extent[@unit='reel'] and ead:extent[@unit='box'])
or 
(ead:extent[@unit='item'] and ead:extent[@unit='leaf'])
or
(ead:extent[@unit='item'] and ead:extent[@unit='page'])
or
(ead:extent[@unit='item'] and ead:extent[@unit='box'])
or
(ead:extent[@unit='box'] and ead:extent[@unit='volume'])
or
(ead:extent[@unit='digitalfiles'] and ead:extent[@unit='folder'])
)
]
for $physdesc in $physdescs
return
(
for $carrier in $physdesc/ead:extent[@altrender='carrier']
return
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='part'>{$carrier}</physdesc>
as last into $physdesc/..,
delete node $physdesc
):)

(:change these to whole:)
(:let $physdescs:= $eads//ead:physdesc
[
not(ead:extent[@altrender='spaceoccupied'])
and count(../ead:physdesc)=2
and not(ead:dimensions)
and not(ead:physfacet)
and
(
(ead:extent[@unit='volume'] and ../ead:physdesc/ead:extent[@unit='leaf'])
or
(ead:extent[@unit='volume'] and ../ead:physdesc/ead:extent[@unit='page'])
or
(ead:extent[@unit='box'] and ../ead:physdesc/ead:extent[@unit='folder'])
)
]
for $physdesc in $physdescs
return
( 
replace value of node $physdesc/@altrender with 'whole',
if($physdesc/following-sibling::ead:physdesc/@altrender)
then
replace value of node $physdesc/following-sibling::ead:physdesc/@altrender with 'whole'
else if($physdesc/preceding-sibling::ead:physdesc/@altrender)
then replace value of node $physdesc/preceding-sibling::ead:physdesc/@altrender with 'whole'
else()
)
:)


(:process known whole carriers:)
(:let $physdescs:= $eads//ead:physdesc
[
not(ead:extent[@altrender='spaceoccupied'])
and count(ead:extent[@altrender='carrier'])>1
and count(ead:extent)=2
and not(ead:dimensions)
and not(ead:physfacet)
and
(
(ead:extent[@unit='page'] and ead:extent[@unit='box'])
or 
(ead:extent[@unit='folio'] and ead:extent[@unit='volume'])
)
]
for $physdesc in $physdescs
return
(
for $carrier in $physdesc/ead:extent[@altrender='carrier']
return
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='whole'>{$carrier}</physdesc>
as last into $physdesc/..,
delete node $physdesc
):)

(:process the remainder:)
(:let $physdescs:= $eads//ead:physdesc
[
not(ead:extent[@altrender='spaceoccupied'])
and 
(
ead:extent[@altrender='carrier']
or 
ead:extent[not(@altrender)]
)
and not(ead:dimensions)
and not(ead:physfacet)
]
for $physdesc in $physdescs
return
(
for $carrier in $physdesc/ead:extent
return
insert node
<physdesc xmlns='urn:isbn:1-931666-22-9' altrender='whole'>{$carrier}</physdesc>
as last into $physdesc/..,
delete node $physdesc
):)