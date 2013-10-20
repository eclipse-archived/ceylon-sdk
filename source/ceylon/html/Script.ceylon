
shared class Script(String? id = null, type = javascript)
        extends Element(id) {

    shared ScriptType type;

    tag = Tag("script");

}

shared abstract class ScriptType(type) {
    shared String type;
}

shared object javascript extends ScriptType("text/javascript") {}
