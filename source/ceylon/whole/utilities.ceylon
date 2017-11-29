/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
Comparison unsignedCompare(Integer first, Integer second)
    =>  if (first == second) then
            equal
        else if (first + minAddressableInteger >
                 second + minAddressableInteger) then
            larger
        else
            smaller;

"
 Divide [[n]] by [[d]], interpreting `n` as an unsigned integer.

 The lowest wordsize bits of the return value will contain the remainder,
 the next lowest wordsize bits will contain the quotient.

 *Warning*: the quotient and remainder must both fit within wordBits bits,
 so the following must hold:

     assert (d > n.rightLogicalShift(wordBits));
     assert (d <= wordMask);
"
Integer unsignedDivide(Integer n, Integer d) {
    // assert (d > n.rightLogicalShift(wordBits));
    // assert (d <= wordMask);

    variable Integer quotient;
    variable Integer remainder;

    if (n >= 0) {
        // easy way
        quotient = n / d;
        remainder = n % d;
    }
    else if (!usesTwosComplementArithmetic) {
        // platforms without two's complement arithmetic (JavaScript and Dart) can
        // safely represent n as a positive number, which will have 2*wordBits bits
        value positiveN = n - minAddressableInteger - minAddressableInteger;
        quotient = positiveN / d;
        remainder = positiveN % d;
    }
    else {
        // perform unsigned division using two's complement signed integers

        // approximate
        quotient = n.rightLogicalShift(1) / d.rightLogicalShift(1);
        remainder = n - quotient * d;

        // correct overshoot
        while (remainder < 0) {
            quotient -= 1;
            remainder += d;
        }

        // correct undershoot
        while (remainder >= d) {
            quotient += 1;
            remainder -= d;
        }
    }
    return quotient * wordRadix + remainder;
}

Integer numberOfTrailingZeros(variable Integer x) {
    x = x.leftLogicalShift(0); // convert to Int32 on JS
    if (x == 0) {
        return runtime.integerAddressableSize;
    }
    else {
        variable value result = 0;
        while (x.and(1) == 0) {
            x = x.rightLogicalShift(1);
            result++;
        }
        return result;
    }
}

Integer unsignedHighestNonZeroBit(variable Integer x) {
    // more convenient than leadingZeros, since
    // integerAddressableSize can vary.
    variable value result = -1;
    while (x != 0) {
        result++;
        x /= 2;
    }
    return result;
}
