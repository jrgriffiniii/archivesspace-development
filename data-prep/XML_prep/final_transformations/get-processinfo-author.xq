xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN%20Working%20Copies/trunk/eads/mss/C0101.EAD.xml");:)

for $ead in $eads
let
$fa-authors := $ead//ead:archdesc/ead:descgrp/ead:processinfo//ead:name[matches(@role, 'author', 'i')] | 
$ead//ead:archdesc/ead:descgrp/ead:processinfo[count(ead:name)=1]//ead:name[@role='processor' or not(@role)]

for $author in $fa-authors
order by $author/ancestor::ead:ead//ead:eadid
return normalize-space($author) || '# ' || $author/ancestor::ead:ead//ead:eadid || codepoints-to-string(10)