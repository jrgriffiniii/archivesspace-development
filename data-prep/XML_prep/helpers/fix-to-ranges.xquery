xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace functx = "http://www.functx.com";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare copy-namespaces preserve, inherit;

(:import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare variable $eads as document-node()* := 
(
(:doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml")
:)
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC129.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC128.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC111.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC127.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC130.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC248.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC132.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC041.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC131.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC164.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC194.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC116.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC206.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC166.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC136.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC151.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC168.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC213.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC347.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC154.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC001.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC306.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC190.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC123.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC053.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC220.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC160.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC098.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC222.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC081.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC104.3.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC004.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC171.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC141.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC231.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC203.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC070.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC021.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC096.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC049.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC051.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC173.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC168.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC121.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mss/C0975.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC197.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC032.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mss/C1163.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC199.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC077.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC164.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC058.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC219.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC042.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC104.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC025.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC092.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC178.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC195.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC089.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC116.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC207.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC022.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC069.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC206.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC144.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC146.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC208.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC234.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC208.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC193.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC140.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC202.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC104.4.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC035.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC155.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC050.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC172.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC125.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC076.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC060.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC138.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC213.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/univarchives/AC334.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC229.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC198.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC120.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC184.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC078.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC014.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC230.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC105.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC170.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC103.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC088.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC256.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC240.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC163.EAD.xml"),
doc("file:/Users/heberleinr/Documents/SVN_Working_Copies/trunk/eads/mudd/publicpolicy/MC196.EAD.xml")
);

for $ead in $eads

for $container in $ead//ead:container[matches(., '-') and not(../ead:physdesc/ead:extent[@altrender='carrier'][matches(., 's\s?$')])]
let $extent := $container/../ead:physdesc/ead:extent[@altrender='carrier' and not(matches(., 's\s?$'))]
let $extent-token := tokenize($container, '-')
let $extent-value := xs:integer($extent-token[2]) - xs:integer($extent-token[1]) + 1

return replace value of node $extent with $extent-value || ' ' || $container/@type || 's'