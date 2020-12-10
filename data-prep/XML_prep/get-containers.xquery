xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, no-inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN%20Working%20Copies/trunk/eads/mss/C0101.EAD.xml");:)

let $top-container :=
<top-containers>{
for $ead in $eads
let $dsc2-items := $ead//ead:dsc[2]//ead:c

for $item in $dsc2-items
		return
			functx:change-element-ns-deep(
			element c {
				for $attribute in $item/@*
				return
					$attribute,
				$item/ead:did/*[not(self::ead:physloc[@type = "text"])],
				if($item/ead:did/ead:physloc[@type = "text"][matches(., '^\p{Lu}{1,2}$')])
				then element physloc {
						attribute type {"profile"},
						$item/ead:did/ead:physloc[@type = "text"][matches(., '^\p{Lu}{1,2}$')]/text()
					}
				else(),
				if($item/ead:did/ead:physloc[@type="text"][matches(., "\p{Ll}")])
				then element physloc {
						attribute type {"note"},
						$item/ead:did/ead:physloc[@type="text"][matches(., "\p{Ll}")]/text()
					}
				else(),
				if ($item/ead:did/ead:container[matches(., '^\p{Lu}{1,2}-')])
				then
					element physloc {
						attribute type {"profile"},
						replace($item/ead:did/ead:container, '(^\p{Lu}{1,2})(-.+)', '$1')
					}
				else
					(),
				if($item/ead:did[not(ead:physloc[@type = "text"][matches(., '^\p{Lu}{1,2}$')] or ead:container[matches(., '^\p{Lu}{1,2}-')])])
				then element physloc {
						attribute type {"profile"},
						"B"
					}
				else()
			},
			"", "")
	}</top-containers>

return
	(
	put($top-container,
	"/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/top_containers.xml")
	)