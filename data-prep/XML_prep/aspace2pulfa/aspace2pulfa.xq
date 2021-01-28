xquery version "3.1";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare variable $eads as document-node()* := collection("file:/Users/heberleinr/Documents/pulfalight/spec/fixtures/aspace/generated?select=*.xml;recurse=yes")/doc(document-uri(.));
:)
(:declare variable $eads as document-node()* := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/aspace2pulfa/aspace_export/MC085.aspace.xml");
:)
declare variable $eads as document-node()* := collection("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_tools/aspace2pulfa/aspace_export?select=*.xml;recurse=yes")/doc(document-uri(.));

(:delete langmaterial/language/text(); add address/@id:)

for $ead in $eads
let $aspace_ids := $ead//@id[starts-with(., 'aspace')]
let $child_containers := $ead//ead:c//ead:container[@parent]
let $top_containers := 
	for $container in $ead//ead:c//ead:container[@label]
	return
	<c xmlns="urn:isbn:1-931666-22-9" level="otherlevel" otherlevel="physicalitem" id="{'i_' || substring-after(substring-before($container/@label, ']'), '[')}">
			{
				<did>
					<container type="{$container/@type}">{$container/text()}</container>
					<unitid type="barcode">{substring-after(substring-before($container/@label, ']'), '[')}</unitid>
					<physloc type="code">{$container/data(@altrender)}</physloc>
					<physloc type="text">{$container/data(@encodinganalog)}</physloc>
				</did>
			}
			</c> 
let $dacs3 := $ead//ead:archdesc/(ead:scopecontent | ead:arrangement)
let $dacs4 := $ead//ead:archdesc/(ead:accessrestrict | ead:userestrict | ead:otherfindaid | ead:phystech)
let $dacs5 := $ead//ead:archdesc/(ead:acqinfo | ead:appraisal | ead:custodhist | ead:accruals)
let $dacs6 := $ead//ead:archdesc/(ead:originalsloc | ead:altformavail | ead:bibliography | ead:relatedmaterial)
let $dacs7 := $ead//ead:archdesc/(ead:prefercite | ead:processinfo)
let $daodescs := $ead//ead:daodesc
let $langmaterial := $ead//ead:langmaterial
let $coll-physlocs := $ead//ead:archdesc/ead:did/ead:physloc

return
(
for $aspace_id in $aspace_ids
return
delete node $aspace_id,

for $num in $ead//ead:titleproper/ead:num 
return
delete node $num,

for $eadid in $ead//ead:eadid
return
insert node attribute urn {substring-after($eadid/@url, '.edu/')}
into $eadid,

for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Manuscripts Division', 'i')]
return
insert node attribute id {'mss'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'University Archives', 'i')]
return insert node attribute id {'univarchives'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Public Policy Papers', 'i')]
return insert node attribute id {'publicpolicy'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Rare Book Collection', 'i')]
return insert node attribute id {'rarebooks'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), "Cotsen Children's Library", 'i')]
return insert node attribute id {'cotsen'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Latin American Ephemera', 'i')]
return insert node attribute id {'lae'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Engineering Library', 'i')]
return insert node attribute id {'eng'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Selectors', 'i')]
return insert node attribute id {'selectors'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'Graphic Art Collection', 'i')]
return insert node attribute id {'ga'} into $repository,
for $repository in $ead//ead:archdesc/ead:did/ead:repository[matches(normalize-space(string(.)), 'East Asian Collection', 'i')]
return insert node attribute id {'ea'} into $repository,

for $language in $langmaterial/ead:language/text()
return
delete node $language,

for $daodesc in $daodescs
return
delete node $daodesc,

for $physloc in $coll-physlocs
return
(
if(matches($physloc/text(), '^(anxb|ea|ex|flm|flmp|gax|hsvc|hsvm|mss|mudd|prnc|rarebooks|rcpph|rcppf|rcppl|rcpxc|rcpxg|rcpxm|rcpxr|st|thx|wa|review|oo|sc|sls)$', 'i'))
then
	insert node attribute type {"code"} into $physloc
else
	insert node attribute type {"text"} into $physloc
),

if($dacs3)
then
(
insert node
<descgrp xmlns="urn:isbn:1-931666-22-9" id="dacs3">
{
for $note in $dacs3
return element {$note/name()} {$note/ead:p} 
}
</descgrp>
after $ead//ead:archdesc/ead:did,
delete nodes $dacs3
)
else(),

if($dacs4)
then
(
insert node
<descgrp xmlns="urn:isbn:1-931666-22-9" id="dacs4">
{
for $note in $dacs4
return element {$note/name()} {$note/ead:p} 
}
</descgrp>
after $ead//ead:archdesc/ead:did,
delete nodes $dacs4
)
else(),

if($dacs5)
then
(
insert node
<descgrp xmlns="urn:isbn:1-931666-22-9" id="dacs5">
{
for $note in $dacs5
return element {$note/name()} {$note/ead:p} 
}
</descgrp>
after $ead//ead:archdesc/ead:did,
delete nodes $dacs5
)
else(),

if($dacs6)
then
(
insert node
<descgrp xmlns="urn:isbn:1-931666-22-9" id="dacs6">
{
for $note in $dacs6
return element {$note/name()} {$note/ead:p} 
}
</descgrp>
after $ead//ead:archdesc/ead:did,
delete nodes $dacs6
)
else(),

if($dacs7)
then
(
insert node
<descgrp xmlns="urn:isbn:1-931666-22-9" id="dacs7">
{
for $note in $dacs7
return element {$note/name()} {$note/ead:p} 
}
</descgrp>
after $ead//ead:archdesc/ead:did,
delete nodes $dacs7
)
else(),

for $dsc1 in $ead//ead:dsc[1]
return
insert node attribute type {'combined'} into $dsc1,

for $component at $pos in $ead//ead:dsc[1]//ead:c
return 
(
delete node $component/@id,
insert node attribute id {$ead//ead:eadid || '_c' || functx:pad-integer-to-length($pos, 4)} into $component
),

for $head in $ead//ead:head
return
delete node $head,

if($ead//ead:container)
then
	(
	insert node 
			<dsc xmlns="urn:isbn:1-931666-22-9" type="othertype" othertype="physicalholdings">
				{functx:distinct-deep($top_containers)}
			</dsc>
		as last into $ead//ead:archdesc,
	for $container in $ead//ead:c//ead:container[@label]
	return 
		if($container/../ead:container[@parent])
		then delete node $container
		else
		replace node $container with 
			<container xmlns="urn:isbn:1-931666-22-9">
				<ptr target="{"i_" || substring-after(substring-before($container/@label, ']'), '[')}"></ptr>
			</container>,
	for $container in $child_containers
	return
		replace node $container with
			<container xmlns="urn:isbn:1-931666-22-9" 
					parent="{"i_" || substring-after(substring-before($container/preceding-sibling::ead:container[@label][1]/@label, ']'), '[')}"
					type="{$container/@type}">
			{
				$container/text()
			}
			</container>
		)
else()
)
