
shared class Script(type = javascript) satisfies Node {

    shared ScriptType type;

}

shared abstract class ScriptType(type) {
    shared String type;
}

shared object javascript extends ScriptType("text/javascript") {}
