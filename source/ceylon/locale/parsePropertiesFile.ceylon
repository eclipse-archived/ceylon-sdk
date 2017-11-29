/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Parse a properties file."
void parsePropertiesFile(String textContent, 
        void handleEntry(String key, String text)) {
    value lines = textContent.lines.iterator();
    value builder = StringBuilder();
    while (!is Finished rawline = lines.next()) {
        builder.clear().append(rawline);
        variable value lastline = rawline;
        while (lastline.endsWith("\\"), //line continuation
                !is Finished nextline = lines.next()) {
            builder.deleteTerminal(1); //remove the \
            variable value trimming = true;
            value chars = nextline.iterator();
            while (!is Finished char = chars.next()) {
                if (trimming) { //trim leading whitespace
                    if (char.whitespace) {
                        continue;
                    }
                    else {
                        trimming = false;
                    }
                }
                builder.appendCharacter(char);
            }
            lastline = nextline;
        }
        value line = builder.string;
        if (exists first = line.first, 
                !first in "!#", //ignore comments
            exists index //split key/value on = or :
                = line.firstIndexWhere("=:".contains)) {
            let ([key, definition] = line.slice(index));
            builder.clear();
            variable value trimming = true;
            value chars = definition.iterator();
            chars.next(); //skip the = or :
            while (!is Finished char = chars.next()) {
                if (trimming) { //trim leading whitespace
                    if (char.whitespace) {
                        continue;
                    }
                    else {
                        trimming = false;
                    }
                }
                Character c;
                if (char=='\\', //interpolate \ escape
                    !is Finished next = chars.next()) {
                    c = switch (next)
                        case ('n') '\n'
                        case ('r') '\r'
                        case ('t') '\t'
                        case ('\\') '\\'
                        //TODO: unicode escapes!
                        else next;
                }
                else {
                    c = char;
                }
                builder.appendCharacter(c);
            }
            handleEntry(key.trimmed, builder.string);
        }
    }
}