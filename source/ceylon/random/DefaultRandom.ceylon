/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A pseudorandom number generator.

 The algorithm used by this class to generate pseudorandom numbers may be platform
 specific and is subject to change in future versions of this module.

 Currently, A [Linear Congruential Generator](http://en.wikipedia.org/wiki/Linear_congruential_generator)
 (LCG) pseudorandom number generator is used, as defined by the recurrence relation:

     Xₙ₊₁ ≡ (a Xₙ + c) (mod m)

 The following parameters are used for the JVM:

     a = 25214903917
     c = 11
     m = 2^48
     output bits = 16..47

 And for JavaScript:

     a = 214013
     c = 2531011
     m = 2^32
     output bits = 16..30

 See <http://en.wikipedia.org/wiki/Linear_congruential_generator>"
shared final class DefaultRandom (
        "The seed. The value is processed by [[reseed]] prior to use."
        Integer seed = nextUniqueSeed)
        satisfies Random {

    Integer a;
    Integer c;
    Integer m;
    Integer highUsableBit; // counting from 1
    Integer usableBitCount;

    if (realInts) {
        // Same parameters as java.util.Random, apparently
        a = 25214903917;
        c = 11;
        m = 2^48;
        highUsableBit = 48; // counting from 1
        usableBitCount = 32;
    }
    else {
        a = 214013;
        c = 2531011;
        m = 2^32;
        highUsableBit = 31; // counting from 1
        usableBitCount = 15;
    }

    value mask = m - 1;
    value highBitM = 2^highUsableBit;

    // initialized later by reseed(seed)
    variable Integer xn = 0;

    Integer next() {
        if (realInts) {
            return xn = (a * xn + c).and(mask);
        } else {
            // x % 2^n == x & (2^n - 1) for x >= 0
            value step1 = a * xn + c;
            assert(!step1.negative);
            return xn = step1 % m;
        }
    }

    "Reseed this random number generator. For the Java runtime, the seed value is
     processed using `newSeed.xor(a).and(m - 1)` prior to use, and for the JavaScript
     runtime, `newSeed.magnitude % m`."
    shared void reseed(Integer newSeed) {
        if (realInts) {
            xn = newSeed.xor(a).and(mask);
        } else {
            xn = newSeed.magnitude % m;
        }
        next();
    }

    reseed(seed);

    shared actual
    Integer nextBits(Integer bits) {
        // NOTE: only using the high-order bits; the low-order
        // bits have shorter cycles, with the lowest order bit
        // simply alternating

        if (bits <= 0) {
            return 0;
        }
        else if (bits <= usableBitCount) {
            // next will never be negative
            return next()
                    % highBitM
                    / (2^(highUsableBit - bits));
        }
        else if (bits <= randomLimits.maxBits) {
            variable value remaining = bits;
            variable Integer result = 0;
            while (remaining > 0) {
                value count = if (remaining <= usableBitCount)
                              then remaining
                              else usableBitCount;
                result *= 2^count;
                result += nextBits(count);
                remaining -= count;
            }
            return result;
        }
        else {
            throw Exception("bits cannot be greater than \
                             ``randomLimits.maxBits`` on this platform");
        }
    }

}

// true for Java (64 bit bitwise operations supported)
Boolean realInts = runtime.integerAddressableSize == 64;

variable
Integer uniqueSeedComponent = 0;

Integer nextUniqueSeed
    // or(0) to truncate to 32 bits on JavaScript
    =>  (uniqueSeedComponent = uniqueSeedComponent.or(0) + 1)
            + system.nanoseconds.or(0) + system.milliseconds.or(0);
