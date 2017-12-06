/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""This module provides basic cross-platform regular expression support.
   It's based on Google's [RegExp object](http://www.gwtproject.org/javadoc/latest/com/google/gwt/regexp/shared/RegExp.html)
   for GWT.
   
   For documentation pertaining to regular expressions and patterns take
   a look at the information for the original implementations:
   
    - [Java RegExp documentation](http://docs.oracle.com/javase/7/docs/api/java/util/regex/package-summary.html)
    - [ECMAScript RegExp documentation](http://www.ecma-international.org/ecma-262/5.1/#sec-15.10)
    - [Mozilla RegExp documentation](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/RegExp)
   
   A simple example of how to use this module:
   
       Regex re = regex("[0-9]+ years");
       assert(re.test("90 years old"));
       print(re.replace("90 years old", "very"));

   For more information see [[regex]] and [[Regex]].
   """
by("Tako Schotanus")
license("Apache Software License 2.0")
label("Ceylon Regular Expressions API")
module ceylon.regex maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    native("jvm") import java.base "7";
}
