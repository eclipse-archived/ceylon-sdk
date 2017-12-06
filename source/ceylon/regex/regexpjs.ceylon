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
native("js")
class RegexJavascript(expression, global = false, ignoreCase = false, multiLine = false)
        extends Regex(expression, global, ignoreCase, multiLine) {
    String expression;
    Boolean global;
    Boolean ignoreCase;
    Boolean multiLine;
    
    String jsflags => (global then "g" else "") +
            (ignoreCase then "i" else "") +
            (multiLine then "m" else "");
     
    dynamic ex;
    dynamic {
        try {
            ex = \iRegExp(expression, jsflags);
        } catch (Throwable th) {
            throw RegexException("Problem found within regular expression", th);
        }
    }
    
    shared actual Integer lastIndex {
        dynamic {
            return ex.lastIndex;
        }
    }
    assign lastIndex {
        dynamic {
            ex.lastIndex = lastIndex;
        }
    }
    
    shared actual MatchResult? find(
        String input) {
        dynamic {
            dynamic result = ex.exec(input);
            if (exists result) {
                dynamic start = result.index;
                dynamic end = result.index + result[0].size;
                dynamic matched = result[0];
                result.shift();
                variable String?[] groups  = [];
                for (String? s in result) {
                    groups = groups.append([s]);
                }
                return MatchResult(start, end, matched, groups);
            } else {
                return null;
            }
        }
    }
    
    shared actual String[] split(
        String input,
        Integer limit) {
        variable String[] result  = [];
        dynamic i = input;
        dynamic {
            dynamic y = if (limit >= 0) then i.split(ex, limit) else i.split(ex);
            for (String s in y) {
                result = result.append([s]);
            }
        }
        return result;
    }
    
    shared actual String replaceDollarSignPattern(
        String input,
        String replacement) {
        dynamic i = input;
        dynamic r = replacement;
        dynamic {
            dynamic result = i.replace(ex, r, jsflags);
            return result;
        }
    }
}
