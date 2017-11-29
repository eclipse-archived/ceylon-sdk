/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A JSON Printer that prints to a [[String]]."
by("Stéphane Épardaud")
shared class StringPrinter(Boolean pretty = false) 
        extends Printer(pretty){
    
    value builder = StringBuilder();

    "Appends the given value to our `String` representation"
    shared actual void print(String string)
            => builder.append(string);

    "Returns the printed JSON"
    shared actual default String string => builder.string;
}