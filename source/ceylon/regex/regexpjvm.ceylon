/*
 * Copyright 2010 Google Inc., 2015 Red Hat Inc. and/or its affiliates and other
 * contributors as indicated by the authors tag. All rights reserved.
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

import java.lang {
    Types {
        nativeString
    }
}
import java.util.regex {
    Pattern
}

native("jvm")
class RegexJava(expression, global = false, ignoreCase = false, multiLine = false)
        extends Regex(expression, global, ignoreCase, multiLine) {
    String expression;
    Boolean global;
    Boolean ignoreCase;
    Boolean multiLine;
    
    shared actual variable Integer lastIndex = 0;
    
    Integer patternFlags {
        variable Integer f = Pattern.unixLines;
        if (ignoreCase) {
            f = f.or(Pattern.caseInsensitive).or(Pattern.unicodeCase);
        }
        if (multiLine) {
            f = f.or(Pattern.multiline);
        }
        return f;
    }
    
    Pattern pattern;
    try {
        pattern = Pattern.compile(expression, patternFlags);
    } catch (Exception ex) {
        throw RegexException("Problem found within regular expression", ex);
    }
    
    shared actual MatchResult? find(
        String input) {
        // Start the search at lastIndex if the global flag is true.
        Integer searchStartIndex = if (global) then lastIndex else 0;
        if (0 <= searchStartIndex <= nativeString(input).length()) {
            if (exists m = pattern.matcher(nativeString(input)),
                m.find(searchStartIndex)) {
                Integer groupCount = m.groupCount();
                value groups = Array<String?>.ofSize(1 + groupCount, "");
                for (value group in 0 : groupCount+1) {
                    groups[group] = m.group(group);
                }
                if (global) {
                    lastIndex = m.end();
                }
                String matched = groups[0] else "";
                return MatchResult(m.start(), m.end(), matched, groups.sequence().rest);
            }
        }
        // No match
        if (global) {
            lastIndex = 0;
        }
        return null;
    }
    
    shared actual String[] split(
        String input,
        Integer limit) {
        Array<String> result;
        if (expression.empty) {
            // Javascript split using a completely empty regular expression splits the
            // string into its constituent characters.
            variable Integer resultLength = input.size;
            if (resultLength > limit && limit >= 0) {
                resultLength = limit;
            }
            result = Array<String>.ofSize(resultLength, "");
            for (value i in 0 : resultLength) {
                result[i] = input.measure(i, i + 1);
            }
        } else {
            value tmpResult = pattern.split(nativeString(input), if (limit < 0) then -1 else (limit + 1));
            // If we have a limit we chop off the unsplit part of
            // the string which has been put in result[limit].
            // Javascript split does not return it.
            // But in any case we need to copy the result to a
            // new array because we need Ceylon Strings
            value realSize = if (tmpResult.size > limit && limit >= 0) then limit else tmpResult.size;
            Array<String> realResult = Array<String>.ofSize(realSize, "");
            for (value i in 0 : realSize) {
                realResult[i] = tmpResult.get(i).string;
            }
            result = realResult;
        }
        return result.sequence();
    }
    
    // In JS syntax, a \ in the replacement string has no special meaning.
    // In Java syntax, a \ in the replacement string escapes the next character,
    // so we have to translate \ to \\ before passing it to Java.
    Pattern _REPLACEMENT_BACKSLASH = Pattern.compile("""\\""");
    // To get \\, we have to say \\\\\\\\:
    // \\\\\\\\ --> Java string unescape --> \\\\
    // \\\\ ---> Pattern replacement unescape in replacement preprocessing --> \\
    String _REPLACEMENT_BACKSLASH_FOR_JAVA = """\\\\""";
    // In JS syntax, a $& in the replacement string stands for the whole match.
    // In Java syntax, the equivalent is $0, so we have to translate $& to
    // $0 before passing it to Java. However, we have to watch out for $$&, which
    // is actually a Javascript $$ (see below) followed by a & with no special
    // meaning, and must not get translated.
    Pattern _REPLACEMENT_DOLLAR_AMPERSAND =
            Pattern.compile("""((?:^|\G|[^$])(?:\$\$)*)\$&""");
    String _REPLACEMENT_DOLLAR_AMPERSAND_FOR_JAVA = """$1\$0""";
    // In JS syntax, a $` and $' in the replacement string stand for everything
    // before the match and everything after the match.
    // In Java syntax, there is no equivalent, so we detect and reject $` and $'.
    // However, we have to watch out for $$` and $$', which are actually a JS $$
    // (see below) followed by a ` or ' with no special meaning, and must not be
    // rejected.
    Pattern _REPLACEMENT_DOLLAR_APOSTROPHE =
            Pattern.compile("""(?:^|[^$])(?:\$\$)*\$[`']""");
    // In JS syntax, a $$ in the replacement string stands for a (single) dollar
    // sign, $.
    // In Java syntax, the equivalent is \$, so we have to translate $$ to \$
    // before passing it to Java.
    Pattern _REPLACEMENT_DOLLAR_DOLLAR = Pattern.compile("""\$\$""");
    // To get \$, we have to say \\\\\\$:
    // \\\\\\$ --> Java string unescape --> \\\$
    // \\\$ ---> Pattern replacement unescape in replacement preprocessing --> \$
    String _REPLACEMENT_DOLLAR_DOLLAR_FOR_JAVA = """\\\$""";
    
    shared actual String replaceDollarSignPattern(
        String input,
        String replacement) {
        // Replace \ in the replacement with \\ to escape it for Java replace.
        variable String rep = _REPLACEMENT_BACKSLASH.matcher(nativeString(replacement))
                .replaceAll(_REPLACEMENT_BACKSLASH_FOR_JAVA);
        // Replace the Javascript-ese $& in the replacement with Java-ese $0, but
        // watch out for $$&, which should stay $$&, to be changed to \$& below.
        rep = _REPLACEMENT_DOLLAR_AMPERSAND.matcher(nativeString(rep)).replaceAll(
            _REPLACEMENT_DOLLAR_AMPERSAND_FOR_JAVA);
        // Test for Javascript-ese $` and $', which we do not support in the pure
        // Java version.
        if (_REPLACEMENT_DOLLAR_APOSTROPHE.matcher(nativeString(rep)).find()) {
            throw RegexException("$` and $' replacements are not supported");
        }
        // Replace the Javascript-ese $$ in the replacement with Java-ese \$.
        rep = _REPLACEMENT_DOLLAR_DOLLAR.matcher(nativeString(rep)).replaceAll(
            _REPLACEMENT_DOLLAR_DOLLAR_FOR_JAVA);
        return if (global) then pattern.matcher(nativeString(input)).replaceAll(rep)
        else pattern.matcher(nativeString(input)).replaceFirst(rep);
    }
}
