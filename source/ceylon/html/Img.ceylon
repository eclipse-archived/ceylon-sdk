"Represents an image. The image given by the [[Img.src]] attribute,
 and the value of the [[Img.alt]] attribute is the img element's fallback
 text content in case the source is not found.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-img-element)"
shared class Img(src, alt = "", useMap = null,
            isMap = null, width = null, height = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty)
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies InlineElement {

    "A valid Uri to the image resource."
    shared String src;

    "Provides equivalent content for those who cannot process
     images or who have image loading disabled"
    shared String alt;
    
    //crossorigin TODO understand this attribute better (enumerable?)

    "If present, can indicate that the image has an associated image map.
     It must reference a valid [[Map]] element's id."
    shared String? useMap;

    shared Boolean? isMap;

    shared Integer? height;

    shared Integer? width;

    tag = Tag("img", emptyTag);

    shared actual [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("src", src);
        attrs.addAttribute("alt", alt);
        attrs.addAll(super.attributes);
        attrs.addAttribute("usemap", useMap);
        attrs.addAttribute("ismap", isMap);
        attrs.addAttribute("height", height);
        attrs.addAttribute("width", width);
        return attrs.sequence();
    }

}
