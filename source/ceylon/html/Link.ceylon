
"Defines a relationship between the `Html` and an external resource."
shared class Link(rel, type, href, String? id)
        extends Element(id) {

    "The relationship type."
    shared String|LinkRel rel;

    "The content mime type."
    shared String|LinkType type;

    "The reference to the resource."
    shared String href; // TODO Uri

}

"The relationship kind between the current document and the linked document."
shared abstract class LinkRel(name)
        of external | search | stylesheet | tag {

    "The name of the relationship."
    shared String name;

    string => name;

}

shared object external extends LinkRel("external") {}

shared object search extends LinkRel("search") {}

shared object stylesheet extends LinkRel("stylesheet") {}

shared object tag extends LinkRel("tag") {}

// TODO generic reusable enumerated mime type?
shared class LinkType(type) {
    shared String type;
}

shared object css extends LinkType("text/css") {}

"Utility `Link` extension representing an CSS resource."
shared class CssLink(String href, String? id = null)
        extends Link(stylesheet, css, href, id) {
}
