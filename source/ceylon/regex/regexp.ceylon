/*
 * Copyright Red Hat Inc. and/or its affiliates and other contributors
 * as indicated by the authors tag. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

"Factory method that returns an initialized [[Regex]] object
 for the current backend. See the documentation for the `Regex`
 object itself for more information.
 "
throws(`class RegexException`)
shared native Regex regex(
        "The regular expression to be used for all operations"
        String expression,
        "For returning all matches instead of only the first"
        Boolean global = false,
        "For case-insensitive matching"
        Boolean ignoreCase = false,
        "For multi-line matching where `^` and `$` also match line delimiters and not
         just the beginning or end of the entire input string"
        Boolean multiLine = false);

"""A class for cross-platform regular expressions modeled on Javascript's
   `RegExp`, plus some extra methods like Java's and Javascript `String`'s
   `replace` and `split` methods (taking a `RegExp` parameter) that are missing
   from Ceylon's version of [[String]]. To create an instance of this class
   use the toplevel function [[regex]].
   
   Example usage:
   
       Regex re = regex("[0-9]+ years");
       assert(re.test("90 years old"));
       print(re.replace("90 years old", "very"));

   A regular expression can also be seen as a (potentially unlimited) set of
   `String`s (that match the regex). Hence `Regex` implements the `Category`
   interface, and you can use e.g. the `in` operator to check whether a string
   is *in* the set of strings matched by the regular expression like so:

       Regex re = regex("[0-9]+ years");
       assert("90 years old" in re);

   There are a few small incompatibilities between the two implementations.
   Java-specific constructs in the regular expression syntax (e.g. [a-z&&[^bc]],
   (?<=foo), \A, \Q) work only on the JVM backend, while the Javascript-specific
   constructs $` and $' in the replacement expression work only on the Javascript
   backend, not the JVM backend, which rejects them. There are also sure to
   exist small differences between the different browser implementations,
   be sure to test thoroughly, especially when using more advanced features.
   """
throws(`class RegexException`)
shared sealed abstract class Regex(expression, global = false, ignoreCase = false, multiLine = false)
        satisfies Category<String> {
    "The regular expression to be used for all operations"
    shared String expression;
    "For returning all matches instead of only the first"
    shared Boolean global;
    "For case-insensitive matching"
    shared Boolean ignoreCase;
    "For multi-line matching where `^` and `$` also match line delimiters and not
     just the beginning or end of the entire input string"
    shared Boolean multiLine;
    
    "The zero-based position at which to start the next match"
    shared formal variable Integer lastIndex;
    
    """Applies the regular expression to the given string. This call affects the
       value returned by [[lastIndex]] if the global flag is set.
       Produces a [[match result|MatchResult]] if the string matches, else `null`.
       """
    shared formal MatchResult? find(
            "the string to apply the regular expression to"
            String input);
    
    """Applies the regular expression to the given string. Produces a sequence
       of [[match result|MatchResult]] containing all matches, or [[Empty]]
       if there was no match.
       """
    shared default MatchResult[] findAll(
        String input) {
        if (global) {
            variable MatchResult[] results = [];
            variable MatchResult? result = find(input);
            while (exists r=result) {
                results = results.withTrailing(r);
                result = find(input);
            }
            return results;
        } else {
            // We need the [[package.global]] flag for this to work
            // so we just delegate to a temporary `Regex`
            return regex(expression, true, ignoreCase, multiLine).findAll(input);
        }
    }
    
    """Splits the input string around matches of the regular expression. If the
       regular expression is completely empty, splits the input string into its
       constituent characters. If the regular expression is not empty but matches
       an empty string, the results are not well defined.
       
       Note: There are some browser inconsistencies with this implementation, as
       it is delegated to the browser, and no browser follows the spec completely.
       A major difference is that IE will exclude empty strings in the result.
       """
    shared formal String[] split(
            "the string to be split"
            String input,
            "the maximum number of strings to split off and return,
             ignoring the rest of the input string.
             If negative, there is no limit"
            Integer limit=-1);
    
    """
       Determines if the regular expression matches the given string. This call
       affects the value returned by [[lastIndex]] if the global flag is
       set. Equivalent to: `exec(input) != null`
       """
    shared default Boolean test(
            "the string to apply the regular expression to"
            String input) {
        return find(input) exists;
    }
    
    contains(String element) => test(element);

    """Returns the [[input]] string with the part(s) matching the regular expression
       replaced with the [[replacement]] string or the value returned by the
       replacement function. If the global flag is set, replaces all matches of the
       regular expression. Otherwise, replaces the first match of the regular expression.
       
       When using a replacement string, as per Javascript semantics, backslashes in the
       replacement string get no special treatment, but the replacement string can
       use the following special patterns:
       
        - `$1`, `$2`, ... `$99` - inserts the n'th group matched by the regular
       expression.
        - `$&` - inserts the entire string matched by the regular expression.
        - `$$` - inserts a $.
       
       Note: "$`" and "$'" are *not* supported in the pure Java implementation,
       and throw an exception.
       
       When using a replacement function, if the replacement function accepts a
       [[String]] parameter, this function will pass it the
       [[string that matched|MatchResult.matched]]. If the replacement function
       accepts a [[MatchResult]] parameter, this function will pass it the entire
       [[MatchResult]] instance.
       """
    shared default String replace(
            "the string in which the regular expression is to be searched"
            String input,
            "the replacement string or function"
            String|String(String)|String(MatchResult) replacement) {
        value output = StringBuilder();
        variable value lastEnd = 0;
        value matches = global
            then findAll(input)
            else (if (exists match = find(input)) then [match] else empty);
        
        for (match in matches) {
            output.append(input.substring(lastEnd, match.start));
            
            if (is String replacement) {
                output.append(replaceDollarSignPattern(match.matched, replacement));
            }
            else if (is String(String) replacement) {
                output.append(replacement(match.matched));
            } else {
                output.append(replacement(match));
            }
            
            lastEnd = match.end;
        }
        
        output.append(input.substring(lastEnd));
        
        return output.string;
    }
    
    "Replaces dollar sign patterns as described in the documentation for [[replace]]."
    shared formal String replaceDollarSignPattern(String input, String replacement);
}

"The result of a call to [[Regex.find]]"
shared class MatchResult(start, end, matched, groups) {
    "The zero-based index of the match in the input string"
    shared Integer start;
    "The zero-based index after the match in the input string"
    shared Integer end;
    "The matched string"
    shared String matched;
    "A sequence of matched groups or [[Empty]]"
    shared String?[] groups;
    
    shared actual String string => "MatchResult[``start``-``end`` '``matched``' ``groups``]";
}

"An exception that can be thrown when the [[Regex]] object couldn't be created
 or when an error occurred in any of its methods"
shared class RegexException(String? description=null, Throwable? cause=null)
        extends Exception(description, cause) {}

"""This method produces a `String` that can be used to create a
   `Regex` that would match the string as if it were a literal
   pattern. Metacharacters or escape sequences in the input sequence
   will be given no special meaning.
   """
shared String quote(
    "The string to be literalized"
    String input) {
    StringBuilder sb = StringBuilder();
    for (ch in input) {
        if (ch in """\^$*+?.()|[]{}""") {
            sb.append("\\");
        }
        sb.append(ch.string);
    }
    return sb.string;
}

/****************
 ***** JVM ******
 ****************/

native("jvm")
shared Regex regex(
    String expression,
    Boolean global = false,
    Boolean ignoreCase = false,
    Boolean multiLine = false) {
    return RegexJava(expression, global, ignoreCase, multiLine);
}

/****************
 ***** JS *******
 ****************/

native("js")
shared Regex regex(
    String expression,
    Boolean global = false,
    Boolean ignoreCase = false,
    Boolean multiLine = false) {
    return RegexJavascript(expression, global, ignoreCase, multiLine);
}

