/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared class Token(type, text, position, line, column,
        errors, processedText = null) {

    shared TokenType type;
    shared String text;
    shared String? processedText;
    shared Integer position;
    shared Integer line;
    shared Integer column;
    shared [ParseException*]  errors;

    string => "Token(``type.string``)";
}
