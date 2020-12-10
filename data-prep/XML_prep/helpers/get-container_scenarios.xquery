xquery version "3.0";
declare namespace ead = "urn:isbn:1-931666-22-9";
declare namespace functx = "http://www.functx.com";
declare copy-namespaces no-preserve, inherit;

(:import module namespace functx = "http://www.functx.com"
at "http://www.xqueryfunctions.com/xq/functx-1.0-doc-2007-01.xq";:)

declare function functx:distinct-deep
($nodes as node()*) as node()* {
	
	for $seq in (1 to count($nodes))
	return
		$nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
		., $nodes[position() < $seq]))]
};
declare function functx:is-node-in-sequence-deep-equal
($node as node()?,
$seq as node()*) as xs:boolean {
	
	some $nodeInSeq in $seq
		satisfies deep-equal($nodeInSeq, $node)
};

declare variable $COLL as document-node()* := collection("../../eads?recurse=yes;select=*.xml")/doc(document-uri(.));
let $ead := $COLL//ead:ead

let $did := $COLL//ead:dsc[1]//ead:did[ead:container[not(ead:ptr or @parent)]
and not(count(ead:container) = 2 and ead:container/@type = 'box' and ead:container/@type = 'folder')
and count(distinct-values(ead:container/@type)) > 1]

let $combo :=
for $d in $did
return
	<did>{
			for $c in $d//ead:container[not(ead:ptr or @parent) and not(../ead:container[ead:ptr or @parent])]
			return
				<type>{
						if ($c/@type)
						then
							$c/data(@type)
						else ()
					}</type>
		}</did>
	(:return $combo:)

for $value in functx:distinct-deep($combo)
let $count := count($combo[. eq $value])
	order by $count descending
return
	<did>
		{
			attribute count {$count},
			$value/*
		}</did>
	
	
	(:container types and instance counts:)
	(:  for $value in distinct-values($type)
  let $count := count($type[. eq $value])
  order by $count descending
  return $value || " (" || $count || ")" || codepoints-to-string(10):)