"Represents a multiline plain text edit control for
 the element's raw value.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-textarea-element)"
shared class TextArea(text = "", String? name = null,
            rows = null, cols = null, 
            maxLength = null, minLength = null,
            placeholder = null, wrap = null,
            Boolean? autoFocus = null,
            Boolean? disabled = null, String? form = null,
            Boolean? formNoValidate = null,
            Boolean? readOnly = null, Boolean? required = null,
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
        extends FormElement(name, autoFocus, disabled, form, formNoValidate,
            readOnly, required, null, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies InlineElement & TextNode {

    shared actual String text;

    "Specifies the visible number of lines in a text area."
    shared Integer? rows;

    "Specifies the visible width of a text area.
     **Must** be specified when [[TextArea.wrap]] is [[hard]]"
    shared Integer? cols;

    "Specifies the maximum number of characters allowed."
    shared Integer? maxLength;

    "Specifies the minimum number of characters allowed."
    shared Integer? minLength;

    "Specifies a short hint that describes
     the expected value of this field."
    shared String? placeholder;

    "Specifies how the text in a text area is
     to be wrapped when submitted in a form."
    shared TextAreaWrap? wrap;

    if (exists wrapMode = wrap, wrapMode == hard) {
        "The number of columns must be specified when wrap mode is `hard`"
        assert (exists cols);
    }

    tag = Tag("textarea");
    
    shared actual default [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("rows", rows);
        attrs.addAttribute("cols", cols);

        attrs.addAttribute("maxlength", maxLength);
        attrs.addAttribute("minlength", minLength);

        attrs.addAttribute("placeholder", placeholder);
        attrs.addAttribute("wrap", wrap);
        
        attrs.addAll(super.attributes);

        return attrs.sequence();
    }

}

"Specifies how the text in a text area is to be wrapped
 when submitted in a form.

 Technical details about this attribute can be found on the
 [Official W3C reference](http://www.w3.org/html/wg/drafts/html/master/forms.html#attr-textarea-wrap)"
shared abstract class TextAreaWrap(String mode)
        of hard | soft {
    string => mode;
}

"Indicates that the text in the textarea is to have
 newlines added by the user agent so that the text
 is wrapped when it is submitted."
shared object hard extends TextAreaWrap("hard") {}

"Indicates that the text in the textarea is not to be
 wrapped when it is submitted (though it can still be
 wrapped in the rendering)."
shared object soft extends TextAreaWrap("soft") {}
