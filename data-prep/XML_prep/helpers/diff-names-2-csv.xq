xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $diff-names as document-node()* := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/names_differential.xml")/doc(document-uri(.));

for $link in $diff-names//link
return
(:$link/../@type ||'#'|| $link/../displayname[1] ||'#'|| $link/../authfilenumber[1] ||'#'|| $link/id ||'#'|| $link/relationship ||'#'|| codepoints-to-string(10):)
<record>
<name-old>{$link/../displayname[1]/text()}</name-old>
<type>{$link/../data(@type)}</type>
<viaf>{$link/../authfilenumber[1]/text()}</viaf>
<link>{$link/id/text()}</link>
<relationship>{$link/relationship/text()}</relationship>
</record>
