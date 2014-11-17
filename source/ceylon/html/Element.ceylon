
"Implementations of this class represents a concrete element used
 to display formatted content, to define metadata or to import external
 resources of a [[Document]]. This base class defines the `id`,
 common to all elements."
shared abstract class Element(id = null)
        satisfies Node {

    "Document wide identifier. The value should be the name of the id
     you wish to use and must be unique for the whole document."
    shared String? id;

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("id", id);
        return attrs.sequence();
    }

}

"Implementations of this class represents an element that can be styled
 using CSS."
shared abstract class StyledElement(String? id, classNames = [], style = null)
        extends Element(id) {

    "CSS class names."
    shared CssClass classNames;

    "CSS style properties."
    shared String? style;

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAll(super.attributes);
        if (is String[] classNames) {
            attrs.addAttribute("class", " ".join(classNames));
        } else {
            attrs.addAttribute("class", classNames);
        }
        attrs.addAttribute("style", style);
        return attrs.sequence();
    }

}

"A default [[Element]] implementation that represents a full featured
 HTML element. It defines all common HTML attributes and event handling."
shared abstract class BaseElement(String? id = null, CssClass classNames = [],
            String? style = null, accessKey = null, contextMenu = null,
            dir = null, draggable = null, dropZone = null,
            inert = null, hidden = null, lang = null, spellcheck = null,
            tabIndex = null, title = null, translate = null, aria = null,
            nonstandardAttributes = empty, data = empty)
        extends StyledElement(id, classNames, style) {

    "Specifies a shortcut key that can be used to access the element."
    shared String? accessKey; // TODO static typed KeyStroke?

    "A reference to a menu element id with the contents of this
     element context menu.
     **Note** that this property is poorly supported by browsers." // TODO more info here
    shared String? contextMenu;

    "Specifies the element's text directionality."
    shared TextDirection? dir;

    "Controls whether or not the element is draggable."
    shared Boolean? draggable;

    "Defines the behavior when other element is dropped on this element.
     Note: everytime you define a element as a drop zone, you should also
     define it's [[BaseElement.title]] attribute for the purpose
     of non-visual interactions"
    shared DropZone? dropZone;

    "Indicates that the element is not yet, or is no longer, relevant.
     The browser/user agent does not display elements that have the
     hidden attribute present."
    shared Boolean? hidden;

    "Indicates, when `true`, that the element is to be made inert." // TODO more info
    shared Boolean? inert;

    "Specifies the primary language for the element's contents and
     for any of the element's attributes that contain text."
    shared String? lang; // TODO Locale type?

    "User agents can support the checking of spelling and
     grammar of editable text."
    shared Boolean? spellcheck;

    "Controls whether an element is supposed to be focusable, whether
     it is supposed to be reachable using sequential focus navigation,
     and what is to be the relative order of the element for the purposes
     of sequential focus navigation. "
    shared Integer? tabIndex;

    "Specifies a title. Most browsers will display a tooltip when the
     cursor hovers over the element."
    shared String? title;

    "Used to specify whether this element's attribute values its
     text content are to be translated when the page is localized,
     or whether to leave them unchanged."
    shared Boolean? translate;

    shared Aria? aria;

    "Defines any other nonstandard (defined by W3C) attributes."
    shared NonstandardAttributes nonstandardAttributes;

    "Can be used to hold data-* attributes."
    shared DataContainer data;

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAll(super.attributes);
        attrs.addAttribute("accesskey", accessKey);
        attrs.addAttribute("contextmenu", contextMenu);
        attrs.addAttribute("draggable", draggable);
        attrs.addAttribute("addne", dropZone);
        attrs.addAttribute("hidden", hidden);
        attrs.addAttribute("inert", inert);
        attrs.addAttribute("lang", lang);
        attrs.addAttribute("spellcheck", spellcheck);
        attrs.addAttribute("tabindex", tabIndex);
        attrs.addAttribute("title", title);
        attrs.addYesNoBooleanAttribute("translate", translate);

        attrs.addAll(nonstandardAttributes);

        attrs.addAll(data.map((elem) => "data-``elem.key``"->elem.item));

        // TODO append events attributes
        return attrs.sequence();
    }

}
