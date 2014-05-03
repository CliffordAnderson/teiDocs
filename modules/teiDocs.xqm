xquery version "3.0";

module namespace teiDoc = "http://nullable.net/teiDoc";

declare namespace functx = "http://www.functx.com";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

(: See https://en.wikibooks.org/wiki/XQuery/All_Paths :)

(: Adapted from Priscilla Walmsley's functx:path-to-node :)
declare function teiDoc:path-to-node($nodes as node()*) as xs:string* {
    functx:sort($nodes/*/name(.))
};
 
declare function functx:distinct-element-paths($nodes as node()*) as xs:string* {
    distinct-values(teiDoc:path-to-node($nodes/descendant-or-self::*))
};
 
declare function functx:sort($seq as item()*) as item()* {
  for $item in $seq
  order by $item
  return $item
};

declare function teiDoc:get-docs-url($element as xs:string) as xs:string? {
    "http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-" || $element || ".html"
};

declare function teiDoc:get-docs-desc($element as xs:string) as xs:string? {
    let $doc := fn:doc("/db/snippets/tei_all.xsd")
    return $doc//xs:element[@name = $element]/xs:annotation/xs:documentation/text()
};

declare function teiDoc:extract-paths($nodes as node()*) as element(a)* {
    let $elements := functx:distinct-element-paths($nodes)
    for $element in $elements
    let $docs-url := teiDoc:get-docs-url($element)
    let $docs-desc := teiDoc:get-docs-desc($element)
    return <div class="col-md-12 teidocs"><div class="col-md-2"><a href="{$docs-url}">{$element}</a></div><div class="col-md-10">{$docs-desc}</div></div>
};

declare function teiDoc:generate-docs($doc as xs:string) as element(html) {
    <html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>TEI Element Subset</title>
        <!-- Bootstrap -->
        <link href="css/bootstrap.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container"></div>
        <h1>Documentation for TEI Element Subset</h1> 
        {for $teiDoc in teiDoc:extract-paths(fn:doc($doc)) return <div class="row">{$teiDoc}<br /></div>} 
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
    </body>
</html>
};
