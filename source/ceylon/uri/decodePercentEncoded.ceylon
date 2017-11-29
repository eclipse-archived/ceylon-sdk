/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer.charset {
    ascii, utf8
}

Integer fromHex(Integer hex) {
    if(hex >= '0'.integer && hex <= '9'.integer) {
        return hex - '0'.integer;
    }
    if(hex >= 'A'.integer && hex <= 'F'.integer) {
        return 10 + hex - 'A'.integer;
    }
    if(hex >= 'a'.integer && hex <= 'f'.integer) {
        return 10 + hex - 'a'.integer;
    }
    throw Exception("Invalid hexadecimal number: "+hex.string);
}

"Decodes a percent-encoded ASCII string."
by("Stéphane Épardaud")
shared String decodePercentEncoded(String str) {
    Byte percent = '%'.integer.byte;
    value array = Array(ascii.encode(str));
    variable Integer r = 0;
    variable Integer w = 0;
    while(r < array.size) {
        assert (exists char = array[r]);
        if(char == percent) {
            // must read the next two items
            if (exists first = array[++r]) {
                if (exists second = array[++r]) {
                    array[w]
                        = (16 * fromHex(first.unsigned)
                        + fromHex(second.unsigned)).byte;
                } else {
                    throw Exception("Missing second hex number");
                }
            } else {
                throw Exception("Missing first hex number");
            }
        } else {
            array[w] = char;
        }
        r++;
        w++;
    }
    return utf8.decode(array.take(w));
}
