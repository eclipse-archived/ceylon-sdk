import ceylon.html { ParentNode, CssClass, Aria, TextNode, ExtraAttributes, BlockElement, Element, InlineElement }


shared class P(text = "", String? accessKey = null,
        CssClass classNames = [], String? contextMenu = null,
        String? id = null, Boolean? hidden = null, String? lang = null,
        Boolean? spellcheck = null, String? style = null, String? title = null,
        Boolean? translate = null, Aria? aria = null,
        ExtraAttributes attributes = {}, children = {})
    extends Element(accessKey, classNames, contextMenu, id, hidden, lang,
        spellcheck, style, title, translate, aria, attributes)
    satisfies TextNode & BlockElement & ParentNode<InlineElement> {

    shared actual String text;

    shared actual {<InlineElement|{InlineElement*}|Null>*} children;

}