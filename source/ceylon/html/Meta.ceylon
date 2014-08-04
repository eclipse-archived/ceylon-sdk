
"The meta element represents various kinds of metadata
 expressed through pairs of [[ceylon.html::Meta.name]]
 and [[ceylon.html::Meta.content]].
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#meta)"
see(`class CharsetMeta`)
shared class Meta(name, content = "", String? id = null)
        extends Element(id) {

    "The name (key) of the metadata."
    shared String name;

    "The content (value) of the metadata."
    shared String content;

    tag = Tag("meta", emptyTag);
    
    shared actual default [<String->Object>*] attributes => concatenate(super.attributes, [
        "name"->name,
        "content"->content
    ]);

}

"Utility class to easily express a charset metadata for the [[Document]]."
shared class CharsetMeta(charset = "utf-8")
        extends Meta("Content-Type", "text/html; charset=``charset``;") {

    "Document content charset. Defaults to `utf-8`."
    shared String charset;

    shared actual default [<String->Object>*] attributes => concatenate(super.attributes, [
        "charset"->charset
    ]);

}
