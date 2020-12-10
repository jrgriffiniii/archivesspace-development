xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace functx = "http://www.functx.com";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;

(:import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare function functx:change-element-ns
  ( $elements as element()* ,
    $newns as xs:string ,
    $prefix as xs:string )  as element()? {

   for $element in $elements
   return
   element {QName ($newns,
                      concat($prefix,
                                if ($prefix = '')
                                then ''
                                else ':',
                                local-name($element)))}
           {$element/@*, $element/node()}
 } ;

declare variable $eads as document-node()* := collection("../../eads/rarebooks?select=*.xml;recurse=yes")/doc(document-uri(.));


(:declare variable $eads as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/rarebooks/RBD1.1.EAD.xml")
);:)

for $ead in $eads

let $dao-dsc := $ead//ead:dsc[1]//ead:dao
let $dao := $ead//ead:archdesc/ead:did/ead:dao | $ead//ead:archdesc/ead:dao
let $name-pointer := ($ead//ead:persname | $ead//ead:corpname | $ead//ead:famname | $ead//ead:name)[ead:ptr]
let $emphs := $ead//ead:emph
let $titlepropers := $ead//ead:titleproper
let $langusage := $ead//ead:langusage
let $processinfo := $ead//ead:processinfo
let $odd := $ead//ead:odd
let $c-no-accessrestricts := $ead//ead:dsc[1]//ead:c[not(ead:accessrestrict)]
let $accessrestrict-no-altrender := $ead//ead:dsc[1]//ead:accessrestrict[not(@altrender)]

return
	(
	for $o in $odd
	return
	(
	insert node <note xmlns="urn:isbn:1-931666-22-9">{$odd/ead:p}</note> after $o,
	delete node $o
	),
	for $pointer in $name-pointer return
	delete node $name-pointer/ead:ptr,

	for $d in $dao-dsc[not(@xlink:title)]
	return
		insert node attribute xlink:title {"View digital content"}
			into $d,
	
	for $d in $dao-dsc[@xlink:title]
	return
		replace value of node $d/@xlink:title
			with "View digital content",

	for $d in $dao
	return
		delete node $d,

	for $emph in $emphs 
	return
		replace node $emph with $emph/string(),

	for $titleproper in $titlepropers
	return 
		replace value of node $titleproper with normalize-space($titleproper/string()),

	for $language in $langusage/ead:language
	return
		insert node attribute scriptcode {"Latn"} into $language,

	for $p in $processinfo/ead:p
	return 
		replace value of node $p with normalize-space($p/string()),

	for $accessrestrict in $c-no-accessrestricts
	return
	if($accessrestrict/ancestor::ead:c[ead:accessrestrict])
	then 
		if($accessrestrict/ancestor::ead:c[ead:accessrestrict/@type])
		then
		insert node 
			functx:change-element-ns(
			element accessrestrict {
			$accessrestrict/ancestor::ead:c[ead:accessrestrict][1]/ead:accessrestrict[1]/@type, 
			attribute altrender {if(matches($accessrestrict/ancestor::ead:c[ead:accessrestrict][1]/ead:accessrestrict[1]/@type, 'review', 'i')) 
								then 'Review'
								else if(matches($accessrestrict/ancestor::ead:c[ead:accessrestrict][1]/ead:accessrestrict[1]/@type, 'closed', 'i'))
								then 'Restricted'
								else $accessrestrict/ancestor::ead:c[ead:accessrestrict][1]/ead:accessrestrict[1]/@type
								},
			$accessrestrict/(ancestor::ead:c[ead:accessrestrict][1]/ead:accessrestrict)[1]/*
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
	else if($accessrestrict/ancestor::ead:archdesc/ead:descgrp/ead:accessrestrict/@type)
	then insert node 
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
	else insert node <accessrestrict xmlns="urn:isbn:1-931666-22-9" type="open"><p>{"Open for research."}</p></accessrestrict> after $accessrestrict/ead:did
)
