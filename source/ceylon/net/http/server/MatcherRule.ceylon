by("Matej Lazar")
shared abstract class Matcher() {
    shared formal Boolean matches(String path);
    
    "Returns requestPath with truncated matched path.
     Note that relative path should be used only when using 
     [[startsWith]] matcher without [[and]] condition.
     [[endsWith]] and [[and]] are ignored while constructing 
     relative path. [[endsWith]] and [[and]] returns 
     unmodified requestPath."
    shared default String relativePath(String requestPath)
            => requestPath;
    shared Matcher and(Matcher other) 
            => And(this, other);
    shared Matcher or(Matcher other) 
            => Or(this, other);
}

class StartsWith(String substring) 
        extends Matcher() {
    matches(String path) 
            => path.startsWith(substring);
    relativePath(String requestPath) 
            => requestPath[substring.size...];
}

class EndsWith(String substring) 
        extends Matcher() {
    matches(String path) 
            => path.endsWith(substring);
}

class IsRoot()
        extends Matcher() {
    matches(String path) 
            => path.equals("/");
}

class Equals(String path)
        extends Matcher() {
    matches(String path) 
            => path in this.path;
}

class And(Matcher left, Matcher right) 
        extends Matcher() {
    matches(String path) 
            => left.matches(path) 
            && right.matches(path);
    relativePath(String requestPath) 
            => requestPath;
}

class Or(Matcher left, Matcher right) 
        extends Matcher() {
    matches(String path) 
            => left.matches(path) 
            || right.matches(path);
    relativePath(String requestPath) 
            => left.matches(requestPath) 
            then left.relativePath(requestPath) 
            else right.relativePath(requestPath); 
}

"Rule using [[String.equals]]."
shared Matcher equals(String path) => Equals(path);

"Rule using [[String.startsWith]]."
shared Matcher startsWith(String prefix) => StartsWith(prefix);

"Rule using [[String.endsWith]]."
shared Matcher endsWith(String suffix) => EndsWith(suffix);

"Rule matching / (root)."
shared Matcher isRoot() => IsRoot();
