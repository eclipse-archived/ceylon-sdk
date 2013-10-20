
shared alias HeadElements => Title|Meta|Link|Script;

"Groups the metadata of the `Html` document, such as page description,
 links to resources, stylesheets and scripts."
shared class Head(title = "", metaContent = {},
            links = {}, stylesheets = {}, scripts = {},
            String? id = null)
        extends Element(id)
        satisfies ParentNode<HeadElements> {

    "Defines the title of the document, shown in a
     browser's title bar or tab."
    shared String title;

    shared {Meta?*} metaContent;

    shared {Link?*} links;

    shared {String*} stylesheets;

    shared {Script*} scripts;

    shared actual {<HeadElements|Null>*} children
            => concatenate({ Title(title) }, metaContent, scripts);

    tag = Tag("head");

}

"Represents the title node, present only on the head of the document."
shared class Title(
    "The page title text."
    String content
) satisfies TextNode {

    shared actual String text = content;

    tag = Tag("title");

}
