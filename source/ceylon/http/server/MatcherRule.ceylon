/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
by("Matej Lazar")
shared abstract class Matcher() {
    shared formal Boolean matches(String path);
    
    "Returns requestPath with truncated matched path.
     Note that relative path should be used only when using 
     [[startsWith]] matcher without [[and]] condition.
     [[endsWith]] and [[and]] are ignored while constructing 
     relative path. [[endsWith]] and [[and]] returns 
     unmodified requestPath."
    deprecated
    shared default String relativePath(String requestPath)
            => requestPath;
    shared Matcher and(Matcher other) 
            => And(this, other);
    shared Matcher or(Matcher other) 
            => Or(this, other);
}

"Matcher to leverage Undertow's template mechanism for path templates and path parameters.
 It should be given to an Endpoint without combining it with other matchers.
 
 Matches a path with path parameters. The parameters are indicated
 by curly braces in the template, for example /a/{b}/c/{d} Their values can be obtained from
 the Request via the Request.pathParameter() method."
shared class TemplateMatcher(shared String template)
        extends Matcher() {
	// Don't use it as a conventional matcher!
	matches(String path) => false;
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
            => path == this.path;
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
    suppressWarnings("deprecation")
    shared actual String relativePath(String requestPath) 
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

shared TemplateMatcher template(String template) => TemplateMatcher(template);
