xquery version "3.0";

module namespace teiDocs = "http://nullable.net/teiDocs";

declare namespace functx = "http://www.functx.com";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

(: See https://en.wikibooks.org/wiki/XQuery/All_Paths :)

(: Adapted from Priscilla Walmsley's functx:path-to-node :)
declare function teiDocs:path-to-node($nodes as node()*) as xs:string* {
    functx:sort($nodes/*/name(.))
};
 
declare function functx:distinct-element-paths($nodes as node()*) as xs:string* {
    distinct-values(teiDocs:path-to-node($nodes/descendant-or-self::*))
};
 
declare function functx:sort($seq as item()*) as item()* {
  for $item in $seq
  order by $item
  return $item
};

declare function teiDocs:get-docs-url($element as xs:string) as xs:string? {
    "http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-" || $element || ".html"
};

declare function teiDocs:get-docs-desc($element as xs:string) as xs:string? {
    let $doc := fn:doc("/db/apps/teiDocs/tei_all.xsd")
    return $doc//xs:element[@name = $element]/xs:annotation/xs:documentation/text()
};

declare function teiDocs:extract-paths($nodes as node()*) as element(div)* {
    let $elements := functx:distinct-element-paths($nodes)
    for $element in $elements
    let $docs-url := teiDocs:get-docs-url($element)
    let $docs-desc := teiDocs:get-docs-desc($element)
    return <div class="col-md-12 teiDocs"><div class="col-md-2"><a href="{$docs-url}">{$element}</a></div><div class="col-md-10">{$docs-desc}</div></div>
};


declare function teiDocs:extract-attributes($nodes as node()*) as element(div)* {
    let $attributes := distinct-values($nodes//@*/name(.))
    for $attribute in $attributes
    let $docs-url := teiDocs:get-docs-url($attribute)
    let $docs-desc := teiDocs:get-docs-desc($attribute)
    order by $attribute
    return 
    <div class="col-md-12 teiDocs"><div class="col-md-3"><a href="#">{$attribute}</a></div><div class="col-md-9">{$docs-desc}</div></div>
};

declare function teiDocs:generate-docs($doc as xs:string) as element(html) {
    <html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>TEI Element Subset</title>
        <!-- Bootstrap -->
        <link href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" />
        <style> 
            <![CDATA[
            /* See http://stackoverflow.com/a/18783266 */
            .row:nth-of-type(even) {
              background: #F0F0F0  !important;
            }
            .teiDocs {
                min-height:3em;
            }
            ]]>
       </style>
    </head>
    <body>
        <div class="container"></div>
        <h1>Documentation for TEI Element Subset</h1> 
        <div>
            <h4>Elements</h4>
            <div>
                {for $teiDoc in teiDocs:extract-paths(fn:doc($doc)) return <div class="row">{$teiDoc}<br /></div>}
            </div>
            <h4>Attributes</h4>
            <div>
                {for $teiDoc in teiDocs:extract-attributes(fn:doc($doc)) return <div class="row">{$teiDoc}<br /></div>}
            </div>
        </div>    
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
    </body>
</html>
};