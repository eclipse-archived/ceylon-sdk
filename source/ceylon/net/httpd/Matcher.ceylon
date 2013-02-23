import ceylon.collection { LinkedList }

by "Matej Lazar"

see(and, or)
shared abstract class Matcher(MatcherRule* matcherRules) {
    shared formal Boolean matches(String string);
    
    shared List<MatcherRule> findRulesMatching(String string) {
        value rulesMatching = LinkedList<MatcherRule>();
        for (matcherRule in matcherRules) {
            if (matcherRule.matches(string)) {
                rulesMatching.add(matcherRule);
            }
        }
        return rulesMatching;
    }
    
    shared {MatcherRule*} findStartRulesMatching(String string) {
        Boolean filterStartsOnly(MatcherRule elem) {
            if (is StartsWith elem ) {
                return true;
            }
            return false;
        }
        return findRulesMatching(string).filter(filterStartsOnly);
    }
    
    shared {MatcherRule*} findEndsRulesMatching(String string) {
        Boolean filterEndsOnly(MatcherRule elem) {
            if (is EndsWith elem ) {
                return true;
            }
            return false;
        }
        return findRulesMatching(string).filter(filterEndsOnly);
    }
}

class AndMatcher(MatcherRule* rules) 
        extends Matcher(*rules) {
    matches(String string) =>
            findRulesMatching(string).size == rules.size;
}

class OrMatcher(MatcherRule* rules) 
        extends Matcher(*rules) {
    matches(String string) =>
            findRulesMatching(string).size > 0;
}

doc "Method to define maping, rules apply using logical 'and'."
shared Matcher and(MatcherRule* matcherRules) => 
        AndMatcher(*matcherRules);

doc "Method to define maping, rules apply using logical 'or'."
shared Matcher or(MatcherRule* matcherRules) => 
        OrMatcher(*matcherRules);
