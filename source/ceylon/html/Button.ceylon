
"Represents a button.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-button-element)"
shared class Button(text = "", type = button,
            String? name = null, Boolean? autoFocus = null,
            Boolean? disabled = null, String? form = null,
            String? valueOf = null,
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
        extends FormElement(name, autoFocus, disabled, form, null,
            null, null, valueOf, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies TextNode & InlineElement & ParentNode<InlineElement> {

    shared actual String text;

    "Specifies the type of button."
    shared ButtonType type;

    shared actual {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children;

    tag = Tag("button");

    shared actual [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("type", type);
        attrs.addAll(super.attributes);
        return attrs.sequence();
    }

}

"Controls the behavior of the button when it is activated.
 
 Technical details about this attribute can be found on the
 [Official W3C reference](http://www.w3.org/html/wg/drafts/html/master/forms.html#attr-button-type)"
shared abstract class ButtonType(String type)
        of button | reset | submit {
    string => type;
}

"Do nothing. The action must be specified by the user."
shared object button extends ButtonType("button") {}

"If the element has a form owner, the element
 must reset the form owner."
shared object reset extends ButtonType("reset") {}

"If the element has a form owner, the element
 must submit the form owner"
shared object submit extends ButtonType("submit") {}
