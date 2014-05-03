xquery version "3.0";

import module namespace teiDoc = "http://nullable.net/teiDoc" at "teiDocs.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xhtml media-type=application/xhtml+html";

let $docs := teiDoc:generate-docs("/db/shakespeare/Ado.xml")
return file:serialize($docs, "/teidocs.html", ())


