"Represents a control for selecting amongst a set of options.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-select-element)"
see(`class Option`, `class OptionGroup`)
shared class Select(String? name = null, Boolean? autoFocus = null,
            Boolean? disabled = null, String? form = null,
            Boolean? formNoValidate = null, multiple = null,
            Boolean? readOnly = null, Boolean? required = null,
            size = null, String? valueOf = null,
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
        extends FormElement(name, autoFocus, disabled, form, formNoValidate,
            readOnly, required, valueOf, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies InlineElement & ParentNode<Option|OptionGroup> {

    "Specifies that multiple options can
     be selected at once."
    shared Boolean? multiple;

    "Defines the number of visible options
     in a drop-down list."
    shared Integer? size;

    shared actual {<Option|OptionGroup|{<Option|OptionGroup>*}|Snippet<Option|OptionGroup>|Null>*} children;

    tag = Tag("select");

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAll(super.attributes);
        attrs.addAttribute("size", size);
        attrs.addNamedBooleanAttribute("multiple", multiple);
        return attrs.sequence();
    }

}

"Represents an option in a [[Select]] or as part of a list
 of suggestions in a [[DataList]] element.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-option-element)"
shared class Option(text = "", String? id = null,
            disabled = null, selected = null, valueOf = null,
            CssClass classNames = empty, String? style = null)
        extends StyledElement(id, classNames, style)
        satisfies TextNode {

    shared actual String text;

    shared Boolean? disabled;

    shared Boolean? selected;

    shared String? valueOf;

    tag = Tag("option");

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAll(super.attributes);
        attrs.addNamedBooleanAttribute("disabled", disabled);
        attrs.addNamedBooleanAttribute("selected", selected);
        attrs.addAttribute("value", valueOf);
        return attrs.sequence();
    }

}

"Represents a group of [[Option]] elements with a common label.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-optgroup-element)"
shared class OptionGroup(text = "",
            String? id = null, disabled = null,
            CssClass classNames = empty, String? style = null,
            children = empty)
        extends StyledElement(id, classNames, style)
        satisfies TextNode & ParentNode<Option> {

    shared actual String text;

    shared Boolean? disabled;

    tag = Tag("optgroup");

    shared actual {<String|Option|{String|Option*}|Snippet<Option>|Null>*} children;

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAll(super.attributes);
        attrs.addNamedBooleanAttribute("disabled", disabled);
        return attrs.sequence();
    }

}
