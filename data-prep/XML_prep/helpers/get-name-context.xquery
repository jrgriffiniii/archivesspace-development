xquery version "3.0";

declare namespace ead = "urn:isbn:1-931666-22-9";

(:declare default element namespace "urn:isbn:1-931666-33-4";:)

declare variable $EAD as document-node()* := collection("../../eads?select=*.xml;recurse=yes")/doc(document-uri(.));

distinct-values($EAD//(ead:persname|ead:corpname|ead:famname)/../name())