xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));
(:declare variable $eads as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files/MC104.4.xml")
);:)
(:declare variable $eads as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC007.EAD.xml")
);:)
declare variable $agents as document-node()* := 
(
(:doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_A-F.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_G-Z.xml"),:)
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_M.xml")
);

let $file := distinct-values($agents//eadid)

for $ead in $eads[//ead:eadid = $file]
let $cid := $ead//ead:dsc[1]//ead:c/@id
let $eadid := $ead//ead:eadid/text()

return
(
	for $agent-link in $agents//cid[not(.='') and . = $cid]
		let $component := $ead//ead:dsc[1]//ead:c[@id = $agent-link]
		let $field-name := functx:change-element-ns($agent-link/../field, 'urn:isbn:1-931666-22-9"', '')
		let $fields := ($component/ead:did/*[name()=$field-name]/*, $component/*[name()=$field-name]/*)
		for $field in $fields
		where contains(normalize-space($field), normalize-space($agent-link/../name-old))
		return 
			(
			insert nodes 
				(
				<type>{
					if ($field/name()='persname')
					then 'agent_person'
					else if ($field/name()='corpname')
					then 'agent_corporate_entity'
					else if ($field-name/name()='famname')
					then 'agent_family'
					else if ($field/name()='name')
					then 'name'
					else ()
					}
				</type>,
				<role>{
					if ($field[not(@role)])
					then
						if ($field/../name()='origination')
						then 'creator'
						else if ($field/../name()='controlaccess')
						then 'subject'
						else()
					else if(matches($field/@role, '^cre', 'i'))
					then 'cre'
					else if(matches($field/@role, '(^coll?)|(repository)', 'i'))
					then 'col'
					else if(matches($field/@role, '^auth', 'i'))
					then 'aut'
					else if(matches($field/@role, '^phot', 'i'))
					then 'pht'
					else if(matches($field/@role, '^prin', 'i'))
					then 'prt'
					else if(matches($field/@role, '^edit', 'i'))
					then 'edt'
					else if(matches($field/@role, '^speak', 'i'))
					then 'spk'
					else if(matches($field/@role, '^mode', 'i'))
					then 'mod'
					else if(matches($field/@role, '^copy', 'i'))
					then 'cph'
					else if(matches($field/@role, '^corr', 'i'))
					then 'crp'
					else if(matches($field/@role, '^art', 'i'))
					then 'art'
					else if(matches($field/@role, '^engr', 'i'))
					then 'egr'
					else if(matches($field/@role, '^trans', 'i'))
					then 'trl'
					else if(matches($field/@role, '^ill', 'i'))
					then 'ill'
					else if(matches($field/@role, '^dono', 'i'))
					then 'dnr'
					else if(matches($field/@role, '^comp', 'i'))
					then 'cmp'
					else if(matches($field/@role, '^lith', 'i'))
					then 'ltg'
					else 'asn'
				}</role>,
				<rules>
					{
					if($agent-link/../viaf[not(.='')])
					then ()
					else if($field/data(@rules)) 
					then $field/data(@rules) 
					else 'uncontrolled'
					}
				</rules>,
				<source>
					{
					if($agent-link/../viaf[not(.='')])
					then 'viaf'
					else if($field/@source[matches(., 'local', 'i')])
					then 'local'
					else $field/data(@source)
					}
				</source>
				)
			as last into $agent-link/..,
			delete node $field[contains(normalize-space(.), normalize-space($agent-link/../name-old))],
			
			if ($field/parent::ead:origination[../../ead:bioghist 
				and (count(../../ead:bioghist) = count(../ead:origination/*))]
				)
			then 
				delete node $field[contains(normalize-space(.), normalize-space($agent-link/../name-old))]/parent::ead:origination/../../ead:bioghist
			else ()
			),
	for $agent-link in $agents//cid[.='' and ../eadid = $eadid]
		let $archdesc := $ead[//ead:eadid=$agent-link/../eadid]//ead:archdesc
		let $field-name := functx:change-element-ns($agent-link/../field, 'urn:isbn:1-931666-22-9"', '')
		let $fields := ($archdesc/ead:did/*[name()=$field-name]/*, $archdesc/*[name()=$field-name]/*)
		for $field in $fields
		where contains(normalize-space($field), normalize-space($agent-link/../name-old))
		return
			(
			insert nodes 
				(
				<type>{
					if ($field/name()='persname')
					then 'agent_person'
					else if ($field/name()='corpname')
					then 'agent_corporate_entity'
					else if ($field-name/name()='famname')
					then 'agent_family'
					else if ($field/name()='name')
					then 'name'
					else ()
					}
				</type>,
				<role>{
					if ($field[not(@role)])
					then
						if ($field/../name()='origination')
						then 'creator'
						else if ($field/../name()='controlaccess')
						then 'subject'
						else()
					else if(matches($field/@role, '^cre', 'i'))
					then 'cre'
					else if(matches($field/@role, '(^coll?)|(repository)', 'i'))
					then 'col'
					else if(matches($field/@role, '^auth', 'i'))
					then 'aut'
					else if(matches($field/@role, '^phot', 'i'))
					then 'pht'
					else if(matches($field/@role, '^prin', 'i'))
					then 'prt'
					else if(matches($field/@role, '^edit', 'i'))
					then 'edt'
					else if(matches($field/@role, '^speak', 'i'))
					then 'spk'
					else if(matches($field/@role, '^mode', 'i'))
					then 'mod'
					else if(matches($field/@role, '^copy', 'i'))
					then 'cph'
					else if(matches($field/@role, '^corr', 'i'))
					then 'crp'
					else if(matches($field/@role, '^art', 'i'))
					then 'art'
					else if(matches($field/@role, '^engr', 'i'))
					then 'egr'
					else if(matches($field/@role, '^trans', 'i'))
					then 'trl'
					else if(matches($field/@role, '^ill', 'i'))
					then 'ill'
					else if(matches($field/@role, '^dono', 'i'))
					then 'dnr'
					else if(matches($field/@role, '^comp', 'i'))
					then 'cmp'
					else if(matches($field/@role, '^lith', 'i'))
					then 'ltg'
					else 'asn'
				}</role>,
				<rules>
					{
					if($agent-link/../viaf[not(.='')])
					then ()
					else if($field/data(@rules)) 
					then $field/data(@rules) 
					else 'uncontrolled'
					}
				</rules>,
				<source>
					{
					if($agent-link/../viaf[not(.='')])
					then 'viaf'
					else if($field/@source[matches(., 'local', 'i')])
					then 'local'
					else $field/data(@source)
					}
				</source>
				)
			as last into $agent-link/..,
			delete node $field[contains(normalize-space(.), normalize-space($agent-link/../name-old))],
			
			if ($field/parent::ead:origination[../../ead:bioghist 
				and (count(../../ead:bioghist) = count(../ead:origination/*))]
				)
			then 
				delete node $field[contains(normalize-space(.), normalize-space($agent-link/../name-old))]/parent::ead:origination/../../ead:bioghist
			else ()
			)
)