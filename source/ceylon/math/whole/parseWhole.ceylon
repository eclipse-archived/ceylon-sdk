/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
Integer minRadix = 2;
Integer maxRadix = 36;

"The [[Whole]] represented by the given string, or `null`
 if the given string does not represent a `Whole`."
throws (`class AssertionError`,
        "if [[radix]] is not between 2 and 36")
shared Whole? parseWhole(
            "The string representation to parse."
            String string,
            "The base, between [[minRadix]] and [[maxRadix]]
             inclusive."
            Integer radix = 10) {

    assert (minRadix <= radix <= maxRadix);
    value wRadix = wholeNumber(radix);
    Integer start;

    // Parse the sign
    Boolean negative;
    if (exists char = string.first) {
        if (char == '-') {
            negative = true;
            start = 1;
        }
        else if (char == '+') {
            negative = false;
            start = 1;
        }
        else {
            negative = false;
            start = 0;
        }
    }
    else {
        return null;
    }

    Integer length = string.size;
    variable Whole result = zero;
    variable Integer digitIndex = 0;
    variable Integer index = start;
    while (index < length) {
        assert (exists ch = string[index]);

        if (index + 1 == length &&
                radix == 10 &&
                ch in "kMGTP") {
            // The SI-style magnitude
            if (exists exp = parseIntegerExponent(ch)) {
                Whole magnitude = wholeNumber(10).powerOfInteger(exp);
                result *= magnitude;
                break;
            }
            else {
                return null;
            }
        }
        else if (exists digit = parseDigit(ch, radix)) {
            // A regular digit
            result *= wRadix;
            result += wholeNumber(digit);
        }
        else {
            // Invalid character
            return null;
        }

        index++;
        digitIndex++;
    }

    if (digitIndex == 0) {
        return null;
    }
    else {
        return negative then -result else result;
    }
}

Integer? parseIntegerExponent(Character char) {
    switch (char)
    case ('P') {
        return 15;
    }
    case ('T') {
        return 12;
    }
    case ('G') {
        return 9;
    }
    case ('M') {
        return 6;
    }
    case ('k') {
        return 3;
    }
    else {
        return null;
    }
}

Integer aIntLower = 'a'.integer;
Integer aIntUpper = 'A'.integer;
Integer zeroInt = '0'.integer;

Integer? parseDigit(Character digit, Integer radix) {
    Integer figure;
    Integer digitInt = digit.integer;
    if (0<=digitInt-zeroInt<10) {
        figure=digitInt-zeroInt;
    }
    else if (0<=digitInt-aIntLower<26) {
        figure=digitInt-aIntLower+10;
    }
    else if (0<=digitInt-aIntUpper<26) {
        figure=digitInt-aIntUpper+10;
    }
    else {
        return null;
    }
    return figure<radix then figure;
}
