xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := 
(:doc('file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC454.EAD.xml');
:)
(:subsequence(
collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.))
, 1, 10
);:)
collection("file:///Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

(:
TODO

:)


(:
**********************
EXTENT
**********************
:)

(:extent on the collection level is required:)
let $missing-extents := $eads//ead:archdesc/ead:did[not(ead:physdesc/ead:extent)]
for $missing-extent in $missing-extents
return $missing-extent/ancestor::ead:ead//ead:eadid || ' is missing top-level extent' || codepoints-to-string(10),

(:extent should not contain commas:)
let $comma-extents := $eads//ead:archdesc/ead:did/ead:physdesc/ead:extent[contains(., ',')]
for $comma-extent in $comma-extents
return $comma-extent/ancestor::ead:ead//ead:eadid || ' should not have a comma in a top-level extent' || codepoints-to-string(10),

(:physdesc should have @altrender:)
let $physdescs-missing-altrender := $eads//ead:archdesc/ead:did/ead:physdesc[not(@altrender)]
for $physdesc-missing-altrender in $physdescs-missing-altrender
return $physdesc-missing-altrender/ancestor::ead:ead//ead:eadid || ' top-level physdesc is missing @altrender' || codepoints-to-string(10),

(:extent should have @altrender:)
let $extents-missing-altrender := $eads//ead:archdesc/ead:did//ead:extent[not(@altrender)]
for $extent-missing-altrender in $extents-missing-altrender
return $extent-missing-altrender/ancestor::ead:ead//ead:eadid || ' top-level extent is missing @altrender' || codepoints-to-string(10),

(:extent should have @unit:)
let $extents-missing-unit := $eads//ead:archdesc/ead:did//ead:extent[not(@unit)]
for $extent-missing-unit in $extents-missing-unit
return $extent-missing-unit/ancestor::ead:ead//ead:eadid || ' top-level extent is missing @unit' || codepoints-to-string(10),

(:extent must start with a number:)
let $extent-starts := $eads//ead:archdesc/ead:did//ead:extent[matches(., '^\p{L}')]
for $extent-start in $extent-starts
return $extent-starts/ancestor::ead:ead//ead:eadid || ' extent must start with a number' || codepoints-to-string(10),

(:extent should not start with 0:)
let $extent-zeroes := $eads//ead:archdesc/ead:did//ead:extent[matches(., '^0[\d\s\p{L}]')]
for $extent-zero in $extent-zeroes 
return $extent-zero/ancestor::ead:ead//ead:eadid || ' extent should not start with 0' || codepoints-to-string(10),

(:extent should not contain parentheses:)
let $extent-parens := $eads//ead:archdesc/ead:did//ead:extent[matches(., '[()]')]
for $extent-paren in $extent-parens
return $extent-paren/ancestor::ead:ead//ead:eadid || ' extent should not contain parentheses' || codepoints-to-string(10),

(:extent should not be NaN:)
let $nan-extents := $eads//ead:archdesc/ead:did//ead:extent[matches(., 'NaN', 'i')]
for $nan-extent in $nan-extents
return $nan-extent/ancestor::ead:ead//ead:eadid || ' extent shows "NaN" ' || codepoints-to-string(10),

(:extent must have a unit in text:)
let $extent-ends := $eads//ead:archdesc/ead:did//ead:extent[matches(., '\P{L}$')]
for $extent-end in $extent-ends
return $extent-end/ancestor::ead:ead//ead:eadid || " extent must have a unit but doesn't end with a letter" || codepoints-to-string(10),

(:extent carrier should come first in document order:)
let $extent-carriers := $eads//extent[2][@altrender='carrier']
for $extent-carrier in $extent-carriers
return $extent-carrier/ancestor::ead:ead//ead:eadid || " extent carrier should come before space occupied" || codepoints-to-string(10),

(:dimensions must not be longer than 255 characters:)
let $dimensions-too-long := $eads//ead:dimensions[string-length(.)>255]
for $dimension in $dimensions-too-long
return
(if($dimension/ancestor::ead:c) 
then $dimension/ancestor::ead:c[1]/data(@id) 
else $dimension/ancestor::ead:ead//ead:eadid)
|| " dimensions exceeds character limit (255)" || codepoints-to-string(10),

(:
**********************
CONTAINER
**********************
:)
(:container must not be empty:)
let $containers := $eads//ead:container[.='' or matches(., '^\p{Z}+$')]
for $container in $containers
return 
(if($container/ancestor::ead:c) 
then $container/ancestor::ead:c[1]/data(@id) 
else $container/ancestor::ead:ead//ead:eadid)
|| ' container must not be empty' || codepoints-to-string(10),

(:container should have @type:)
let $containers-attribute := $eads//ead:container[not(@type)]
for $container-attribute in $containers-attribute
return 
(if($container-attribute/ancestor::ead:c) 
then $container-attribute/ancestor::ead:c[1]/data(@id) 
else $container-attribute/ancestor::ead:ead//ead:eadid)
|| ' container is missing @type' || codepoints-to-string(10),

(:container label should not be empty:)
let $containers-attribute := $eads//ead:container[@label[contains(., '[]')]]
for $container-attribute in $containers-attribute
return 
(if($container-attribute/ancestor::ead:c) 
then $container-attribute/ancestor::ead:c[1]/data(@id) 
else $container-attribute/ancestor::ead:ead//ead:eadid)
|| ' container label is missing barcode' || codepoints-to-string(10),

(:container encodinganalog should not be empty:)
let $containers-attribute := $eads//ead:container[@encodinganalog[.=""]]
for $container-attribute in $containers-attribute
return 
(if($container-attribute/ancestor::ead:c) 
then $container-attribute/ancestor::ead:c[1]/data(@id) 
else $container-attribute/ancestor::ead:ead//ead:eadid)
|| ' container encodinganalog is empty' || codepoints-to-string(10),

(:
**********************
UNITID
**********************
:)
(:there shouldn't be a unitid set to accessionnumber:)

let $accessionnos := $eads//ead:unitid[@type='accessionnumber']
for $accessionno in $accessionnos 
return
(if($accessionno/ancestor::ead:c) 
then $accessionno/ancestor::ead:c[1]/data(@id) 
else $accessionno/ancestor::ead:ead//ead:eadid)
|| " move accessionnumber to acqinfo" || codepoints-to-string(10),

(:there should only be one unitid per component:)
let $multiple-unitids := $eads//ead:did[count(ead:unitid)>1]
for $did in $multiple-unitids
return
(if($did/ancestor::ead:c) 
then $did/ancestor::ead:c[1]/data(@id) 
else $did/ancestor::ead:ead//ead:eadid)
|| " only one unitid per unit allowed" || codepoints-to-string(10),

(:
**********************
UNITTITLE, XLINK:TITLE
**********************
:)
(:unittitle should not be longer than 1277:)
let $unittitles := $eads//ead:unittitle
for $unittitle in $unittitles
return
if(max($unittitles/string-length(normalize-space(.)))>1277)
then (if($unittitle/ancestor::ead:c) 
then $unittitle/ancestor::ead:c[1]/data(@id) 
else $unittitle/ancestor::ead:ead//ead:eadid) || " field size of 1277 in unittitle exceeded"  || codepoints-to-string(10)
else(),

(:xlink:title should be boilerplate "view digital content":)
let $xlinks := $eads//ead:dao/@xlink:title[not(.='View digital content')]
for $xlink in $xlinks
return 
(if($xlink/ancestor::ead:c) 
then $xlink/ancestor::ead:c[1]/data(@id) 
else $xlink/ancestor::ead:ead//ead:eadid) || ' check @xlink (should say "View digital content" but now says ' || data($xlink) || ')' || codepoints-to-string(10),

(:unittitle should not contain emph:) 
let $unittitles := $eads//ead:unittitle[ead:emph]
for $unittitle in $unittitles
let $emph := <emph>{normalize-space(for $emph in $unittitle/ead:emph return $emph || ', ')}</emph>
return
(if($unittitle/ancestor::ead:c) 
then $unittitle/ancestor::ead:c[1]/data(@id)
else $unittitle/ancestor::ead:ead//ead:eadid) || ' unittitle should not contain emph: ' || $emph || codepoints-to-string(10),

(:
**********************
UNITDATE
**********************
:)

(:end date cannot occur before start date:)
let $suspect-date := 
for $date in $eads//ead:unitdate
let $start := 
	for $d in $date/tokenize(@normal, '/')[1] 
	return
	if(matches($d, '^-?\d{4}$'))
	then concat($d, '-01-01') cast as xs:date
	else if(matches($d, '^-?\d{4}-\d{2}$'))
	then concat($d, '-01') cast as xs:date
	else $d cast as xs:date
let $end := 
	for $d in $date/tokenize(@normal, '/')[2] 
	return
	if(matches($d, '^-?\d{4}$'))
	then concat($d, '-12-30') cast as xs:date
	else if(matches($d, '^-?\d{4}-\d{2}$'))
	then concat($d, '-12') cast as xs:date
	else $d cast as xs:date
return
	if($start > $end)
	then $date
	else()

for $s in $suspect-date
return 
(if($s/ancestor::ead:c) 
then $s/ancestor::ead:c[1]/data(@id) 
else $s/ancestor::ead:ead//ead:eadid)
 || ' ' || $s || ' is not a valid date' || codepoints-to-string(10),

(:
**********************
OTHER
**********************
:)
(:
accessrestrict must have @type set to open, closed, or review 
:)
let $restrictions := $eads//ead:accessrestrict[not(@type[.='closed' or .='open' or .='review'])]
for $restriction in $restrictions 
return 
(if($restriction/ancestor::ead:c) 
then $restriction/ancestor::ead:c[1]/@id 
else $restriction/ancestor::ead:ead//ead:eadid)
 || ' accessrestrict is not set to closed, open, or review' || codepoints-to-string(10),

(:
accessrestrict set to closed or review must have altrender
:)
let $restrictions := $eads//ead:accessrestrict[@type[.='closed' or .='review'] and not(@altrender)]
for $restriction in $restrictions 
return 
(if($restriction/ancestor::ead:c) 
then $restriction/ancestor::ead:c[1]/@id 
else $restriction/ancestor::ead:ead//ead:eadid)
 || ' accessrestrict is missing altrender' || codepoints-to-string(10),

(:c must have accessrestrict:)
let $components := $eads//ead:dsc[1]//ead:c[not(ead:accessrestrict)]
for $component in $components
return $component/data(@id) || ' is missing accessrestrict' || codepoints-to-string(10),

(:c must have @level:)
let $components := $eads//ead:dsc[1]//ead:c[not(@level)]
for $component in $components
return $component/data(@id) || ' is missing @level' || codepoints-to-string(10),

(:names, bioghist should not contain pointers:)
let $pointers := ($eads//ead:bioghist | $eads//ead:famname | $eads//ead:persname | $eads//ead:corpname)[ead:ptr]
for $pointer in $pointers 
return 
(if($pointer/ancestor::ead:c) 
then $pointer/ancestor::ead:c[1]/@id 
else $pointer/ancestor::ead:ead//ead:eadid)
 || codepoints-to-string(10),

(:empty elements are fatal:)
let $empties := $eads//*[not(name(.)="language") and (.='' or matches(., '^\p{Z}+$')) and not(@*) and (not(child::*) or child::*[(.='' or matches(., '^\p{Z}+$')) and not(@*)])]
for $empty in $empties 
return $empty/ancestor::ead:ead//ead:eadid || ' has empty ' || $empty/name() || ' element' || codepoints-to-string(10),

(:dsc2 should be gone:)
let $dsc2s := $eads//ead:dsc[2]
for $dsc2 in $dsc2s
return $dsc2/ancestor::ead:ead//ead:eadid || ' dsc2 should be deleted' || codepoints-to-string(10)