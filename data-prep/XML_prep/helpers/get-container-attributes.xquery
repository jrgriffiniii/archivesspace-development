xquery version "3.0";
declare copy-namespaces no-preserve, inherit;

declare variable $eads as document-node()* := collection("file:///Users/heberleinr/Documents/SVN Working Copies/trunk/rbscXSL/ASpace_files?select=*.xml;recurse=yes")/doc(document-uri(.));

<classic-containers>
	{
		for $value in
		distinct-values($eads//dsc//(container[@container-type and count(@*) = 1])/@*/name())
		return
			<attribute>{$value}</attribute>
	}
</classic-containers>,

<retrieval-containers>
	{
		for $value in
		distinct-values($eads//dsc//(container[count(@*) > 1 and not(@parent-item-id)])/@*/name())
		return
			<attribute>{$value}</attribute>
	}
</retrieval-containers>,

<subordinate-containers>
	{
		for $value in
		distinct-values($eads//dsc//(container[@parent-item-id])/@*/name())
		return
			<attribute>{$value}</attribute>
	}
</subordinate-containers>,

<classic-unitids>
	{
		for $value in
		distinct-values($eads//dsc//(unitid[not(@item-id or @parent-item-id)])/@*/name())
		return
			<attribute>{$value}</attribute>
	}
</classic-unitids>,

<retrieval-unitids>
	{
		for $value in
		distinct-values($eads//dsc//(unitid[@item-id or @parent-item-id])/@*/name())
		return
			<attribute>{$value}</attribute>
	}
</retrieval-unitids>