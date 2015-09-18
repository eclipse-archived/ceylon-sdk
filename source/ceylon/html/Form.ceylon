
"Represents a collection of form-associated elements, some of
 which can represent editable values that can be submitted to
 a server for processing.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-form-element)"
shared class Form(action, method = "", acceptCharset = null,
            autoComplete = null, encType = null, name = null,
            noValidate = null, target = null,
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
            children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies BlockElement & ParentNode<BlockOrInline> {

    "Specifies where to send the form-data
     when a form is submitted."
    shared String action;

    "Specifies the HTTP method to use when
     sending form-data"
    shared String method; // TODO enumerated type

    "Specifies the character encodings that are
     to be used for the form submission."
    shared String? acceptCharset;

    "Specifies whether a form should have
     autocomplete on or off."
    shared Boolean? autoComplete;

    "Specifies how the form-data should be
     encoded when submitting it to the server
     (only when [[Form.method]] is post)"
    shared String? encType;

    "Specifies the name of a form."
    shared String? name;

    "Specifies that the form should not be
     validated when submitted."
    shared Boolean? noValidate;

    "Specifies where to display the response
     that is received after submitting the form."
    shared String? target; // TODO enumerated type? look at A.target

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("form");

    shared actual [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("action", action);
        attrs.addAttribute("method", method);
        attrs.addAttribute("name", name);
        attrs.addAll(super.attributes);
        attrs.addAttribute("accept-charset", acceptCharset);
        attrs.addOnOffBooleanAttribute("autocomplete", autoComplete);
        attrs.addAttribute("enctype", encType);
        attrs.addNamedBooleanAttribute("novalidate", noValidate);
        attrs.addAttribute("target", target);
        return attrs.sequence();
    }

}

"Base class for form control elements."
shared abstract class FormElement(
            name = null, autoFocus = null, disabled = null,
            form = null, formNoValidate = null,
            readOnly = null, required = null, valueOf = null,
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


    "Gives the name of the form control,
     as used in form submission."
    shared String? name;

    "Indicate that a control is to be focused as soon
     as the page is loaded"
    shared Boolean? autoFocus;

    "Specifies that this input should be disabled."
    shared Boolean? disabled;

    "Specifies one or more forms (id) that this
     input belongs to."
    shared String? form;

    "Defines that form elements should not be
     validated when submitted."
    shared Boolean? formNoValidate;

    "Specifies that this field is read-only."
    shared Boolean? readOnly;

    "Specifies that this field must be filled out
     before submitting the form."
    shared Boolean? required;

    "Specifies the value of this input."
    shared String? valueOf;

    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("name", name);
        attrs.addAttribute("value", valueOf);
        attrs.addNamedBooleanAttribute("autofocus", autoFocus);
        attrs.addNamedBooleanAttribute("disabled", disabled);
        attrs.addNamedBooleanAttribute("formnovalidate", formNoValidate);
        attrs.addAttribute("form", form);
        attrs.addNamedBooleanAttribute("readonly", readOnly);
        attrs.addNamedBooleanAttribute("required", required);
        attrs.addAll(super.attributes);
        return attrs.sequence();
    }

}
