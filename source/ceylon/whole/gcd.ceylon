/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The greatest common divisor."
shared
Whole gcd(Whole first, Whole second) {

    function gcdInteger(Integer first, Integer second) {
        // assert first & second are within runtime.integerAddressableSize

        variable value u = first;
        variable value v = second;

        value uZeroBits = numberOfTrailingZeros(u);
        value vZeroBits = numberOfTrailingZeros(v);

        // if u and v are both even, gcd(u, v) = 2 gcd(u/2, v/2)
        value zeroBits = smallest(uZeroBits, vZeroBits);

        // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
        u = u.rightArithmeticShift(uZeroBits);
        v = v.rightArithmeticShift(vZeroBits);

        // make u be the larger one
        if (u < v) {
            value tmp = u;
            u = v;
            v = tmp;
        }

        while (v != 0) {
            // u & v are both odd
            while (true) {
                // gcd(u, v) = gcd(u - v, v)
                u = u - v; // u will be even and >= 0
                // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
                u = u.rightArithmeticShift(numberOfTrailingZeros(u));
                if (v > u) {
                    break;
                }
            }
            // make u the larger one, again
            value tmp = u;
            u = v;
            v = tmp;
        }

        return u.leftLogicalShift(zeroBits);
    }

    function gcdPositive(
            variable WholeImpl first,
            variable WholeImpl second) {

        //assert (first.positive, second.positive);

        // Knuth 4.5.2 Algorithm A
        // (Euclidean algorithm while u & v are very different in size)
        while (!second.zero && !(-2 < first.wordsSize - second.wordsSize < 2)) {
            // gcd(u, v) = gcd(v, u - qv)
            assert (is WholeImpl r = first % second); // r will be >= 0
            first = second;
            second = r;
        }

        if (second.zero) {
            return first;
        }

        // easy case
        if (first.safelyAddressable && second.safelyAddressable) {
            return wholeNumber(gcdInteger(first.integer,
                                        second.integer));
        }

        variable value u = MutableWhole.copyOfWhole(first);
        variable value v = MutableWhole.copyOfWhole(second);

        // Knuth 4.5.2 Algorithm B
        // (Binary method to find the gcd)
        value uZeroBits = u.trailingZeros;
        value vZeroBits = v.trailingZeros;

        // if u and v are both even, gcd(u, v) = 2 gcd(u/2, v/2)
        value zeroBits = smallest(uZeroBits, vZeroBits);

        // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
        u.inPlaceRightArithmeticShift(uZeroBits);
        v.inPlaceRightArithmeticShift(vZeroBits);

        // make u be the larger one
        if (u < v) {
            value tmp = u;
            u = v;
            v = tmp;
        }

        while (!v.zero) {
            // optimize single word case
            if (u.safelyAddressable) {
                //assert (v.safelyAddressable);
                return wholeNumber(gcdInteger(u.integer, v.integer))
                            .leftLogicalShift(zeroBits);
            }

            // u & v are both odd
            while (true) {
                // gcd(u, v) = gcd(u - v, v)
                u.inPlaceSubtract(v); // u will be even and >= 0
                // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
                u.inPlaceRightArithmeticShift(u.trailingZeros);
                if (v > u) {
                    break;
                }
            }
            // make u the larger one, again
            value tmp = u;
            u = v;
            v = tmp;
        }

        u.inPlaceLeftLogicalShift(zeroBits);
        return WholeImpl.ofWords(1, u.words, u.wordsSize); // helps a little
        //return Whole.CopyOfMutableWhole(u);
    }

    if (first.zero) {
        return second.magnitude;
    }
    else if (second.zero) {
        return first.magnitude;
    }
    else {
        assert (is WholeImpl firstMag = first.magnitude);
        assert (is WholeImpl secondMag = second.magnitude);
        return gcdPositive(firstMag, secondMag);
    }
}
