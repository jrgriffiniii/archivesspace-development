xquery version "3.0";
declare namespace functx = "http://www.functx.com";

declare copy-namespaces preserve, inherit;

(:import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $CONTAINERS as document-node()* := doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/rbscXSL/ASpace%20tools/top_containers.xml")/doc(document-uri(.));

let $containers := $CONTAINERS//c
return
(
(:container must have a profile:)
for $container in $containers//c[not(physloc[@type='profile'])]
return $container/@id || ' is missing profile' || codepoints-to-string(10),
(:container profile must not be empty:)
for $container in $containers//c[physloc[@type[.='profile']='']]
return $container/@id || ' profile needs value' || codepoints-to-string(10),
(:container must have a location:)
for $container in $containers//c[not(physloc[@type='code'])]
return $container/@id || ' is missing location' || codepoints-to-string(10),
(:container location must not be empty:)
for $container in $containers//c[physloc[@type[.='code']='']]
return $container/@id || ' location needs value' || codepoints-to-string(10),
(:does the container have to have a barcode?:)
(:container barcode must not be empty:)
for $container in $containers//c[unitid[@type[.='barcode']='']]
return $container/@id || ' barcode needs value' || codepoints-to-string(10)
)