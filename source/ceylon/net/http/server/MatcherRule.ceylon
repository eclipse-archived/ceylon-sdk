by "Matej Lazar"

shared abstract class Matcher() {
    shared formal Boolean matches(String path);
    
    doc "Returns requestPath with truncated matched path.
         Note that relative path should be used only when using [[startsWith]] matcher without [[and]] condition.\n
         [[endsWith]] and [[and]] are ignored while constructing relative path. [[endsWith]] and [[and]] returns unmodified requestPath.
         "
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

class IsRoot()
        extends Matcher() {
    matches(String path) => path.equals("/");
    relativePath(String requestPath) => requestPath;
}

class And(Matcher left, Matcher right) 
        extends Matcher() {
    matches(String path) => left.matches(path) && right.matches(path);
    relativePath(String requestPath) => requestPath;
}

class Or(Matcher left, Matcher right) 
        extends Matcher() {
    matches(String path) => left.matches(path) || right.matches(path);
    relativePath(String requestPath) => left.matches(requestPath) 
            then left.relativePath(requestPath) 
            else right.relativePath(requestPath); 
}

doc "Rule using [[String.startsWith]]."
shared Matcher startsWith(String s) => StartsWith(s);

doc "Rule using [[String.endsWith]]."
shared Matcher endsWith(String s) => EndsWith(s);

doc "Rule matching / (root)."
shared Matcher isRoot() => IsRoot();
