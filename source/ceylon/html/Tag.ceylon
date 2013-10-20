
"The [[Tag]] type, which can be [[blockTag]] or [[emptyTag]]."
shared abstract class TagType() of blockTag | emptyTag {}

"Block tags are often represented by an opening and a closing tag,
 with content/children between."
see(`class Div`)
shared object blockTag extends TagType() {}

"Empty tags are self-contained. They open and close with
 no text content nor children."
see(`class Meta`)
shared object emptyTag extends TagType() {}


"Represents a tag, which is the actual text representation of
 a [[Node]]. For example: `<div></div>` is the tag for the
 [[Div]] element."
shared class Tag(name, type = blockTag, namespacePrefix = null) {

    "The tag name. For `<div></div>` the tag name is `div`."
    shared String name;

    "The type of the tag. For example, `<div></div>` is a [[blockTag]]
     while `<img />` is an [[emptyTag]]."
    shared TagType type;

    shared String? namespacePrefix;

    shared actual String string =>
            namespacePrefix exists
                then "``namespacePrefix else ""``:``name``"
                else name;

}