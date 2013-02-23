by "Matej Lazar"

shared abstract class Matcher() {
    shared formal Boolean matches(String string);
    shared formal String relativePath(String requestPath);
    shared Matcher and(Matcher other) => And(this, other);
    shared Matcher or(Matcher other) => Or(this, other);
}

class StartsWith(String substring) 
        extends Matcher() {
    matches(String string) => string.startsWith(substring);
    relativePath(String requestPath) => requestPath[substring.size...];
}

class EndsWith(String substring) 
        extends Matcher() {
    matches(String path) => string.endsWith(substring);
    relativePath(String requestPath) => requestPath;
}

class And(Matcher left, Matcher right) 
        extends Matcher() {
    matches(String path) => left.matches(path) && right.matches(path);
    relativePath(String requestPath) => nothing; //TODO
}

class Or(Matcher left, Matcher right) 
        extends Matcher() {
    matches(String path) => left.matches(path) || right.matches(path);
    relativePath(String requestPath) => nothing; //TODO
}

doc "Rule using [[String.startsWith]]."
shared Matcher startsWith(String s) => StartsWith(s);

doc "Rule using [[String.endsWith]]."
shared Matcher endsWith(String s) => EndsWith(s);
