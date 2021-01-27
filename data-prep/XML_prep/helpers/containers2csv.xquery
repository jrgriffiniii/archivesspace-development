xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces no-preserve, inherit;
(:
import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $containers as document-node()* := doc("file:/Users/heberleinr/Documents/ASpace/submission_4_final/top_containers.xml")/doc(document-uri(.));

for $container in $containers//c
return

$container/data(@id) || '^' || $container/container/data(@type) || '^' || $container/container || '^' || $container/unitid[@type='barcode'] || '^' || $container/physloc[@type='code'] || '^' || $container/physloc[@type='profile'][1] || codepoints-to-string(10)
