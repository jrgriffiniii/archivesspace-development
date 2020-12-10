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

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mss/C0704.EAD.xml")
);:)

declare variable $top_containers := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/top_containers.xml");

for $ead in $eads

let $dsc1 := $ead//ead:dsc[1]
let $dsc2 := $ead//ead:dsc[2]
let $container-with-ptr := ($dsc1//ead:container[ead:ptr] | $dsc1//ead:unitid[ead:ptr])
let $container-with-parent := $dsc1//ead:container[@parent]
let $name-pointer := ($ead//ead:persname | $ead//ead:corpname | $ead//ead:famname | $ead//ead:name)[ead:ptr]
let $classic-top-containers := $ead//ead:dsc[1]//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][not(matches(., 'primary run', 'i'))][1]
let $classic-sub-containers := $ead//ead:dsc[1]//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][position()>1]
let $container-entities := $top_containers//c[not(matches(container, 'primary run', 'i'))][@eadid=$ead//ead:eadid/text()]


return
	(
	for $p in $container-with-ptr
	let $dsc2-item := $dsc2//ead:c[@id = $p/ead:ptr/@target]
	let $physloc-code := $dsc2-item//ead:physloc[@type="code"]
	let $physloc-text := $dsc2-item//ead:physloc[@type="text"][matches(., "\p{Ll}")]
	let $physloc-profile := $dsc2-item//ead:physloc[@type="text"][matches(., "^\p{Lu}{1,2}$")]

	return
		(:remove whitespace:)
		(
		for $t in $p/text()
		return
			replace node $t
				with (),
		(:if item is linked from unitid:)
		if ($p/self::ead:unitid)
		then
			replace node $p
				with
				(
				functx:change-element-ns(
				element unitid
				{
					attribute type {"itemnumber"},
					$dsc2-item//(ead:container[@type='unitid' or matches(@type, 'item')] | ead:unitid[matches(@type, 'item')])/text()
				},
				"urn:isbn:1-931666-22-9", ""),
				functx:change-element-ns(
				element container
				{
					if ($dsc2-item//ead:container)
					then
						if ($dsc2-item//ead:container/@type[.='unitid' or .='itemnumber'])
						then attribute type {"item"}
						else attribute type {$dsc2-item//ead:container/@type}
					else
						if ($dsc2-item//ead:unitid[not(@type = "barcode")])
						then attribute type {'item'}
						else(),
					if ($dsc2-item//ead:unitid[@type = "barcode"])
					then
						attribute label {"mixed materials [" || $dsc2-item//ead:unitid[@type = "barcode"] || "]"}
					else
						(),
					attribute encodinganalog {$dsc2-item/@id},
					
					if ($dsc2-item//ead:unitid[@type = "itemnumber" or @type="item"])
					then $dsc2-item//ead:unitid[@type = "itemnumber" or @type="item"]/text()
					else $dsc2-item//ead:container/text()
				},
				"urn:isbn:1-931666-22-9", "")
				)
		(:if item is linked from container element:)
		else
			replace node $p
				with
				functx:change-element-ns(
				element container
				{
					if ($dsc2-item//ead:container)
					then
						attribute type {$dsc2-item//ead:container/@type}
					else
						(),
					if ($dsc2-item//ead:unitid[@type = "barcode"])
					then
						attribute label {"mixed materials [" || $dsc2-item//ead:unitid[@type = "barcode"] || "]"}
					else
						attribute label {"mixed materials [" || $dsc2-item//data(@id) || "]"},
					attribute encodinganalog {$dsc2-item/@id},
					
					$dsc2-item//ead:container/text()
				},
				"urn:isbn:1-931666-22-9", "")
		(:if ($physloc-text)
		then insert node 
			functx:change-element-ns(
			element physloc {$physloc-text/text()},
			"urn:isbn:1-931666-22-9", "")
		as last into $p/..
		else():)
		),
	(:if subordinate container:)
	for $p in $container-with-parent
	let $dsc2-item := $dsc2//ead:c[@id = $p/@parent]
	let $physloc-code := $dsc2-item//ead:physloc[@type="code"]
	let $physloc-text := $dsc2-item//ead:physloc[@type="text"][matches(., "\p{Ll}")]
	let $physloc-profile := $dsc2-item//ead:physloc[@type="text"][matches(., "^\p{Lu}{1,2}$")]

	return
		(
		insert node
		functx:change-element-ns(
		element container
		{
			if ($dsc2-item//ead:container)
			then
				attribute type {$dsc2-item//ead:container/@type}
			else
				(),			
			if ($dsc2-item//ead:unitid[@type = "barcode"])
			then
				attribute label {"mixed materials [" || $dsc2-item//ead:unitid[@type = "barcode"] || "]"}
			else
				attribute label {"mixed materials [" || $dsc2-item//data(@id) || "]"},
			attribute encodinganalog {$dsc2-item/@id},

			$dsc2-item//ead:container/text()
		},
		"urn:isbn:1-931666-22-9", "")
			before $p,
		replace node $p
			with
			functx:change-element-ns(
			element container
			{
				attribute type {$p/data(@type)},
				attribute encodinganalog {$dsc2-item/@id},

(:				attribute encodinganalog {$p/@parent},
:)				$p/text()
			},
			"urn:isbn:1-931666-22-9", "")

		(:if ($physloc-text)
		then insert node 
			functx:change-element-ns(
			element physloc {$physloc-text/text()},
			"urn:isbn:1-931666-22-9", "")
		as last into $p/..
		else():)
	   ),
	delete node $dsc2,

	(
	for $classic-top-container in $classic-top-containers
	let $matching-entity := $container-entities
							[lower-case(normalize-space(container/@type))=lower-case(normalize-space($classic-top-container/@type)) and 
							lower-case(normalize-space(container/text()))=lower-case(normalize-space($classic-top-container/text()))]
	return 
	(
	insert nodes (
	attribute encodinganalog {$matching-entity/data(@id)},
	attribute label {"mixed materials [" || $matching-entity/data(@id) || "]"}
	)
	into $classic-top-container,
	delete node $classic-top-container/../ead:physloc
	),
	
	for $classic-sub-container in $classic-sub-containers
	let $matching-entity := $container-entities
							[lower-case(normalize-space(container/@type))=lower-case(normalize-space($classic-sub-container/../ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][1]/@type)) and 
							lower-case(normalize-space(container/text()))=lower-case(normalize-space($classic-sub-container/../ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])][1]/text()))]
	return 
	insert node 
	attribute encodinganalog {$matching-entity/data(@id)}
	into $classic-sub-container
	)
	
	)
