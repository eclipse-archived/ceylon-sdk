import ceylon.html { Doctype, html5 }

"Defines configuration options that changes serialization behavior."
see(`class NodeSerializer`)
shared class SerializerConfig(
            prettyPrint = true,
            defaultDoctype = html5,
            escapeNonAscii = false) {

    "Should the result be minified or formatted? Defaults to `true`"
    shared Boolean prettyPrint;

    "The default [[Doctype]] when the Node is not
     an Html document, only a fragment.
     Defaults to [[html5]]"
    shared Doctype defaultDoctype;

    "Should non-ASCII characters be escaped? Defaults to `false`. If `false`,
     the document's characterset should be UTF-8."
    shared Boolean escapeNonAscii;
}
