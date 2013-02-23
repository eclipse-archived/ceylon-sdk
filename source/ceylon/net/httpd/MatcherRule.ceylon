by "Matej Lazar"

shared abstract class MatcherRule(String substring) {
    shared formal Boolean matches(String string);
    string => substring;
}

class StartsWith(String substring) 
        extends MatcherRule(substring) {
    matches(String string) => string.startsWith(substring);
}

class EndsWith(String substring) 
        extends MatcherRule(substring) {
    matches(String path) => string.endsWith(substring);
}

doc "Rule using [[String.startsWith]]."
shared MatcherRule startsWith(String s) => StartsWith(s);

doc "Rule using [[String.endsWith]]."
shared MatcherRule endsWith(String s) => EndsWith(s);
