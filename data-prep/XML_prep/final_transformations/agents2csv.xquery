declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";


declare variable $agents as document-node()* := 
(
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_A-F.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_G-Z.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_M.xml")
);

for $record in $agents//record
return

normalize-space($record/name-new || '#' || $record/viaf || '#' || $record/eadid || '#' || $record/cid || '#' || $record/type[1] || '#' || $record/role[1] || '#' || $record/rules[1] || '#' || $record/source[1] || '#' || $record/bio) || codepoints-to-string(10)
