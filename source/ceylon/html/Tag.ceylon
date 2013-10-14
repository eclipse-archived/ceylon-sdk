
shared object blockTag extends TagType() {}

shared object inlineTag extends TagType() {}

shared abstract class TagType() of blockTag | inlineTag {}

shared class Tag(name, type = blockTag) {

    shared String name;

    shared TagType type;

}