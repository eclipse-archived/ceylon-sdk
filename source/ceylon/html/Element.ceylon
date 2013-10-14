

shared alias ExtraAttributes => {<String->Object>*};

shared alias CssClass => String|[String*]; // TODO ceylon-style integration

"A default `Node` implementation. Represents a HTML element.
 An `Element` consists of a tag name, some atributes and
 sometimes children nodes."
shared abstract class Element(accessKey = null, classNames = [],
        contextMenu = null, id = null, hidden = null, lang = null,
        spellcheck = null, style = null, title = null, translate = null,
        aria = null, attributes = {}) satisfies Node {

    "Specifies a shortcut key that can be used to access the element."
    shared String? accessKey; // TODO static typed KeyStroke?

    shared CssClass classNames;

    shared String? contextMenu;

    "Document wide identifier. The value should be the name of the id
     you wish to use and must be unique for the whole document."
    shared String? id;

    "Indicates that the element is not yet, or is no longer, relevant.
     The browser/user agent does not display elements that have the
     hidden attribute present."
    shared Boolean? hidden;

    shared String? lang; // TODO Locale type?

    shared Boolean? spellcheck;

    shared String? style;
    //shared Style|String? style;

    "Specifies a title. Most browsers will display a tooltip when the
     cursor hovers over the element"
    shared String? title;

    shared Boolean? translate;
    
    shared Aria? aria;

    shared ExtraAttributes attributes;

}

shared interface ElementType
        of BlockElement | InlineElement | TableElement | FormElement
        satisfies Node {
}

shared interface BlockElement satisfies ElementType {}

shared interface InlineElement satisfies ElementType {}

shared interface FormElement satisfies ElementType {}

shared interface TableElement satisfies ElementType {}
