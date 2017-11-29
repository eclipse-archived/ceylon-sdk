/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""This module defines APIs for connecting to HTTP servers.
   
   Given a [[ceylon.uri::Uri]] to an HTTP service, you can
   get its text representation with:
   
       void getit(Uri uri) {
           Request request = get(uri);
           Response response = request.execute();
           print(response.contents);
       }
"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
native("jvm")
label("Ceylon HTTP Client")
module ceylon.http.client maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.http.common "1.3.4-SNAPSHOT";
    shared import ceylon.collection "1.3.4-SNAPSHOT";
    shared import ceylon.io "1.3.4-SNAPSHOT";
    shared import ceylon.uri "1.3.4-SNAPSHOT";
}
