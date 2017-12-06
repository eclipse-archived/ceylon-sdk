/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The string representation of the given [[whole]] in the 
 base given by [[radix]]. If the given `Whole` is 
 [[negative|Integer.negative]], the string representation 
 will begin with `-`. Digits consist of decimal digits `0` 
 to `9`, together with and lowercase letters `a` to `z` for 
 bases greater than 10.
 
 For example:
 
 - `formatWhole(wholeNumber(-46))` is `\"-46\"`
 - `formatWhole(wholeNumber(9),2)` is `\"1001\"`
 - `formatWhole(wholeNumber(10),8)` is `\"12\"`
 - `formatWhole(wholeNumber(511),16)` is `\"1ff\"`
 - `formatWhole(wholeNumber(512),32)` is `\"g0\"`"
throws (`class AssertionError`,
        "if [[radix]] is not between 2 and 36")
see (`function parseInteger`)
shared String formatWhole(Whole whole, Integer radix = 10) {
    assert (minRadix <= radix <= maxRadix);
    assert (is WholeImpl whole);

    if (whole.zero) {
        return "0";
    }

    value toRadix = wholeNumber(radix);
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
        digits.appendCharacter(c);
        x = qr.first;
    }
    if (whole.negative) {
        digits.appendCharacter('-');
    }
    return digits.reverseInPlace().string;
}
