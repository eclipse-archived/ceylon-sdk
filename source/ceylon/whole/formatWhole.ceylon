/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared
String formatWhole(
        "The number value to format."
        Whole whole,
        "The base, between 2 and 36 inclusive."
        Integer radix = 10,
        "If not `null`, `groupingSeparator` will be used to
         separate each group of three digits if `radix` is 10,
         or each group of four digits if `radix` is 2 or 16.

         `groupingSeparator` may not be '-', a digit as
         defined by the Unicode general category *Nd*, or a
         letter as defined by the Unicode general categories
         *Lu, Ll, Lt, Lm, and Lo*."
        Character? groupingSeparator = null) {
    assert (minRadix <= radix <= maxRadix);
    assert (is WholeImpl whole);

    if (exists groupingSeparator) {
        "groupingSeparator may not be '-', a digit, or a letter."
        assert (!groupingSeparator.digit
                && !groupingSeparator.letter
                && !groupingSeparator == '-');
    }

    // TODO better would be whole.integerRepresentable
    if (whole.safelyAddressable) {
        return Integer.format {
            integer = whole.integer;
            radix = radix;
            groupingSeparator = groupingSeparator;
        };
    }

    if (whole.zero) {
        return "0";
    }

    value groupingSize =
            if (!groupingSeparator exists)
                then 0
            else if (radix == 10)
                then 3
            else if (radix == 2 || radix == 16)
                then 4
            else 0;

    value groupingChar =
            if (exists groupingSeparator,
                groupingSize != 0)
            then groupingSeparator
            else 'X';

    value toRadix = wholeNumber(radix);
    variable value digitNumber = 0;
    variable value digits = StringBuilder();

    variable Whole x = whole.magnitude;
    while (!x.zero) {
        value qr = x.quotientAndRemainder(toRadix);
        value d = qr.last.integer;
        Character c;
        if (0 <= d <10) {
            c = (d + zeroInt).character;
        }
        else if (10 <= d <36) {
            c = (d - 10 + aIntLower).character;
        }
        else {
            assert (false);
        }
        if (groupingSize != 0
                && groupingSize.divides(digitNumber++)
                && digitNumber != 1) {
            digits = digits.appendCharacter(groupingChar);
        }
        digits.appendCharacter(c);
        x = qr.first;
    }
    if (whole.negative) {
        digits.appendCharacter('-');
    }
    return digits.reverseInPlace().string;
}
