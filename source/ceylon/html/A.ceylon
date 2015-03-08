"Represents a hyperlink, which is used to link from one page to another
 through the [[A.href]] attribute.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-a-element)"
shared class A(text = "", href = "#", target = null, download = null,
            hrefLang = null, rel = null, type = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            children = empty)
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies TextNode & InlineElement & ParentNode<InlineElement> {

    shared actual String text;

    "Specifies the URL of the page the link goes to."
    shared String href;

    "If present, must be a valid browsing context name or keyword.
     It gives the name of the browsing context that will be used."
    shared String? target;

    "Indicates that the author intends the hyperlink to be
     used for downloading a resource. When present it specifies
     the default file name that the author recommends for use
     in labeling the resource in a local file system."
    shared String? download;

    "Specifies the relationship between the current document
     and the linked document." // TODO Enumerated type?
    shared String? rel;

    "If present, gives the language of the linked resource. It is purely advisory."
    shared String? hrefLang;

    "If present, gives the MIME type of the linked resource.
     It is purely advisory."
    shared String? type;

    shared actual {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children;

    tag = Tag("a");

    shared actual [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("href", href);
        attrs.addAttribute("target", target);
        attrs.addAll(super.attributes);
        attrs.addAttribute("download", download);
        attrs.addAttribute("rel", rel);
        attrs.addAttribute("hreflang", hrefLang);
        attrs.addAttribute("type", type);
        return attrs.sequence();
    }

}
