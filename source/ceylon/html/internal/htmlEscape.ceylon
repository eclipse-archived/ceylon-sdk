/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
String htmlEscape(
        String raw, EscapableType type,
        Boolean escapeNonAscii, String? forTag=null) {

    switch (type)
    case (\Iname) {
        assert(name.isValid(raw));
        if (escapeNonAscii && raw.any((c) => !c in asciiCharacterRange)) {
            throw Exception(
                "Unescapable non-ascii character found in tag name '``raw``'.");
        }
        // return; names don't have CRLF
        return raw;
    } case (\IrawText) {
        assert (exists forTag);
        value lowerRaw = raw.lowercased;
        value lowerTag = forTag.lowercased;
        // make sure doesn't contain something like "</script"
        if (("</" + lowerTag) in lowerRaw) {
            throw Exception(
                "Unescapable string '</``forTag``' found in rawText content.");
        }
        // disallow comments (if necessary, a comment node type should be created)
        if ("<!--" in raw) {
            throw Exception(
                "Unescapable string '<!--' found in rawText content.");
        }
        // make sure only ascii chars are present if escapeNonAscii is true
        if (escapeNonAscii && raw.any((c)
                    => !c in asciiCharacterRange
                    && c != '\r' && c != '\n' && c != '\t')) {
            throw Exception(
                "Unescapable non-ascii character found in rawText content.");
        }
        // don't return yet, continue with CRLF normalization
    }
    else {}

    // CRLF normalization not necessary per
    // http://www.w3.org/TR/html5/syntax.html#newlines
    // but we'll do it anyway
    variable value lastWasCR = false;

    value sb = StringBuilder();

    value entities = type.entities;

    for (c in raw) {
        if (lastWasCR) {
            if (c != '\n') {
                // output CR not followed by LF as LF
                sb.appendCharacter('\n');
            }
            lastWasCR = false;
        }

        if (c == '\r') {
            lastWasCR = true;
        }
        else if (exists replacement = entities[c]) {
            sb.append(replacement);
        }
        else if (escapeNonAscii
                    && !asciiCharacterRange.containsElement(c)
                    && !c == '\t'
                    && !c == '\n') {
            sb.append("&#");
            sb.append(c.integer.string);
            sb.appendCharacter(';');
        }
        else {
            sb.appendCharacter(c);
        }
    }
    if (lastWasCR) {
        sb.appendCharacter('\n');
    }
    return sb.string;
}
