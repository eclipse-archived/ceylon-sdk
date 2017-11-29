/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""This module defines APIs for representing and manipulating URIs.
   
   The [[ceylon.uri::Uri]] class supports parsing and creating
   URI as defined by [RFC 3986](https://tools.ietf.org/html/rfc3986).
   A new `Uri` may be obtained using [[ceylon.uri::parse]].
   
       void printQuery(String uriAsString) {
           Uri uri = parse(uriAsString);
           print("Query part: ``uri.query``");
       }
"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
module ceylon.uri maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    import ceylon.buffer "1.3.4-SNAPSHOT";
}
