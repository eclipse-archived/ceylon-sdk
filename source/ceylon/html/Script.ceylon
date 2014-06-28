"Allows authors to include dynamic script and data blocks in
 their documents. The element does not represent content for the user.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-input-element)"
shared class Script(src = null, type = javascript, String? id = null,
            charset = null, async = null, defer = null)
        extends Element(id) {

    shared ScriptType type;

    "Specifies the URL of an external script file."
    shared String? src;

    "Specifies the character encoding used in
     an external script file."
    shared String? charset;

    "Specifies that the script is executed
     asynchronously (only for external scripts)."
    shared Boolean? async;

    "Specifies that the script is executed when
     the page has finished parsing (only for
     external scripts)."
    shared Boolean? defer;

    tag = Tag("script");

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("src", src);
        attrs.addAttribute("type", type);
        attrs.addAll(super.attributes);
        attrs.addAttribute("charset", charset);
        attrs.addNamedBooleanAttribute("async", async);
        attrs.addNamedBooleanAttribute("defer", defer);
        return attrs.sequence();
    }

}

shared abstract class ScriptType(String type) {
    string => type;
}

shared object javascript extends ScriptType("text/javascript") {}
