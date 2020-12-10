xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare copy-namespaces no-preserve, inherit;

import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";

declare variable $eads as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

(:declare variable $eads as document-node() := doc("file:/Users/heberleinr/Documents/SVN%20Working%20Copies/trunk/eads/mss/C0101.EAD.xml");:)

count($eads//ead:processinfo) || ' ' || count($eads//ead:processinfo[.//ead:name]) || ' ' || count($eads//ead:processinfo[.//ead:name[@role]]) || ' ' ||
count($eads//ead:processinfo//ead:name[@role])