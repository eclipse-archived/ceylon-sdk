by "Matej Lazar"

shared abstract class MatcherRule(String substring) {
    shared formal Boolean matches(String string);

    shared actual String string {return substring;}
}

class StartsWith(String substring) extends MatcherRule(substring) {
    shared actual Boolean matches(String string) {
        return string.startsWith(substring);
    }
}

class EndsWith(String substring) extends MatcherRule(substring) {
    shared actual Boolean matches(String path) {
        return string.endsWith(substring);
    }
}

doc "Rule using [[String.startsWith]]."
shared MatcherRule startsWith(String s) => StartsWith(s);

doc "Rule using [[String.endsWith]]."
shared MatcherRule endsWith(String s) => EndsWith(s);
