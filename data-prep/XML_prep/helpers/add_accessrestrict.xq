xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

(:declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads?select=*.xml;recurse=yes")/doc(document-uri(.));
:)
declare variable $ead as document-node() := doc("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC152.EAD.xml");


let $c-no-accessrestricts := $ead//ead:dsc[1]//ead:c[not(ead:accessrestrict) and (ancestor::ead:c[ead:accessrestrict] or ancestor::ead:archdesc[ead:descgrp/ead:accessrestrict])]

for $accessrestrict in $c-no-accessrestricts
return
if($accessrestrict/ancestor::ead:c[ead:accessrestrict])
then 
	if($accessrestrict/ancestor::ead:c[ead:accessrestrict/@type])
	then
	insert node 
		functx:change-element-ns(
		element accessrestrict {
		$accessrestrict/ancestor::ead:c/ead:accessrestrict[1]/@type, 
		attribute altrender {if(matches($accessrestrict/ancestor::ead:c/ead:accessrestrict[1]/@type, 'review', 'i')) 
							then 'Review'
							else if(matches($accessrestrict/ancestor::ead:c/ead:accessrestrict[1]/@type, 'closed', 'i'))
							then 'Restricted'
							else $accessrestrict/ancestor::ead:c/ead:accessrestrict[1]/@type
							},
		$accessrestrict/(ancestor::ead:c/ead:accessrestrict)[1]/*
		}, 
		'urn:isbn:1-931666-22-9', '')
		after $accessrestrict/ead:did
	else insert node 
		functx:change-element-ns(
		element accessrestrict 
		{
		$accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type, 
		attribute altrender {if(matches($accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type, 'review', 'i')) 
							then 'Review'
							else if(matches($accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type, 'closed', 'i'))
							then 'Restricted'
							else $accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type
							},
		$accessrestrict/(ancestor::ead:c/ead:accessrestrict)[1]/*
		}, 
		'urn:isbn:1-931666-22-9', '')
		after $accessrestrict/ead:did
else insert node 
	functx:change-element-ns(
	element accessrestrict 
	{
	$accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type, 
	attribute altrender {if(matches($accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type, 'review', 'i')) 
						then 'Review'
						else if(matches($accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type, 'closed', 'i'))
						then 'Restricted'
						else $accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type
						},
	$accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/*
	}, 
	'urn:isbn:1-931666-22-9', '')
	after $accessrestrict/ead:did