
shared alias HeadElements => Title|Meta|Link|Script;

"Groups the metadata of the `Html` document, such as page description,
 links to resources, stylesheets and scripts."
shared class Head(title = "", String? id = null,
            {<HeadElements|Null|Snippet<HeadElements>>*} headChildren = empty)
        extends Element(id)
        satisfies ParentNode<HeadElements> {

    "Defines the title of the document, shown in a
     browser's title bar or tab."
    shared String title;

    shared actual {<HeadElements|Null|Snippet<HeadElements>>*} children
            => concatenate({ Title(title) }, headChildren);

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
