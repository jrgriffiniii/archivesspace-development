xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $new-names as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/diff-names-per-link.xml")
);
(:declare variable $eads as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC007.EAD.xml")
);:)
declare variable $agents as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_A-F.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_G-Z.xml")
);

for $record in $new-names//record
let $target := ($agents//eadid, $agents//cid)
where not($record/link = $target)
order by $record/name-old
return 

$record/name-old||'#'||$record/viaf||'#'|| (if(contains($record/link, '_')) then ($record/link) else ()) ||'#'||(if(contains($record/link, '_')) then substring-before($record/link, '_') else ($record/link)) ||'#'||$record/type||'#'||$record/relationship||codepoints-to-string(10)

