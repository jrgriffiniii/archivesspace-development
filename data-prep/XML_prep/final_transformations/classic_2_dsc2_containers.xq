xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $eads as document-node()* := collection("../../rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

(:let $top-container :=
<top-containers>{:)

for $ead in $eads
let $classic-containers := $ead//ead:dsc[1]//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][1]

let $streamlined-classic-containers :=
	for $container in $classic-containers[not(matches(., 'primary run', 'i'))] 
	return
	<container 
		type="{lower-case(normalize-space($container/@type))}"
		eadid="{$container/ancestor::ead:ead//ead:eadid}"
		name="{lower-case(normalize-space($container/@type||$container))}">
		{
		if($container/../ead:physloc)
		then
		<physloc type="note">{$container/../ead:physloc/text()}</physloc>
		else(),
  	  if(count($container/ancestor::ead:archdesc/ead:did/ead:physloc[@type="code"]) = 1)
		then <physloc type="code">{$container/ancestor::ead:archdesc/ead:did/ead:physloc[@type="code"]/text()}</physloc>
		else <physloc type="code">review</physloc>
		}
		<text>{lower-case(normalize-space($container/text()))}</text>
	</container>

let $distinct-names := for $name at $pos in distinct-values($streamlined-classic-containers/@name) return
	<distinct-name position="{$pos}">{$name}</distinct-name>

for $distinct-name in $distinct-names
	let $cid := $streamlined-classic-containers[@name=$distinct-name][1]/@eadid || '_n' || $distinct-name/@position
	return 
	<c id="{$cid}" eadid="{$streamlined-classic-containers[@name=$distinct-name][1]/@eadid}" level="otherlevel" otherlevel="physicalitem">
		<container type="{$streamlined-classic-containers[@name=$distinct-name][1]/@type}">
			{$streamlined-classic-containers[@name=$distinct-name][1]/text/text()}
		</container>
		<unitid type="barcode">{$cid}</unitid>
		{
		for $physloc in functx:distinct-deep($streamlined-classic-containers[@name=$distinct-name][1]/physloc)
		return $physloc
		}
		<physloc type="profile">B</physloc>
	</c>
(:}</top-containers>

return
	(
	put($top-container,
	"/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/top_containers_classic.xml")
	):)