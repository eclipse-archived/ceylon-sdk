/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"An interface for random number generators. Satisfying classes must implement
 [[nextBits]], which is used by the default implementations of the methods of this
 interface."
by("John Vasileff")
shared interface Random {

    "Generates an Integer holding `bits` pseudorandom bits.
     The returned value will be:

     * equal to `0` for `bits <= 0`
     * in the range `0..(2^n - 1)` for `bits in 1..63`
     * in the range `-2^63..(2^63 - 1)` for `bits == 64`

     Note that `bits` may not be greater than [[randomLimits.maxBits]]."
    throws(`class Exception`,
           "if [[bits]] is greater than [[randomLimits.maxBits]].")
    shared formal see(`function Random.bits`)
    Integer nextBits(
            "The number of psuedorandom bits to generate"
            Integer bits);

    "Returns the next pseudorandom [[Integer]] between `0` (inclusive)
     and [[bound]] (exclusive)."
    throws (`class Exception`,
        "if [[bound]] is less than `1` or greater \
         than [[randomLimits.maxIntegerBound]]")
    shared default see(`function integers`)
    Integer nextInteger(
            "The upper bound (exclusive)."
            Integer bound) {
        if (bound < 1 || bound > randomLimits.maxIntegerBound) {
            throw Exception(
                "bound must be a positive value less than \
                 randomLimits.maxIntegerBound");
        } else if (bound.and(bound - 1) == 0) {
            // bound is an exact power of two
            return nextBits(bitLength(bound) - 1);
        } else {
            variable Integer result;
            value bits = bitLength(bound);
            while ((result = nextBits(bits)) >= bound) { }
            return result;
        }
    }

    "Returns the next pseudorandom [[Boolean]]."
    shared default see(`function booleans`)
    Boolean nextBoolean()
        =>  nextBits(1) == 1;

    "Returns the next pseudorandom [[Byte]]."
    shared default see(`function bytes`)
    Byte nextByte()
        =>  nextBits(8).byte;

    "Returns the next pseudorandom [[Float]] between `0.0` and `1.0`."
    shared default see(`function floats`)
    Float nextFloat()
        =>  nextBits(53).float * floatUnit;

    "Returns a random element from the supplied [[Iterable]]. Useful
     argument types include [[Sequence]]s, such as `[\"heads\", \"tails\"]`,
     and [[Range]]s, such as `[1:100]` or `['A'..'Z']`."
    shared default see(`function elements`)
    Element|Absent nextElement<Element, Absent>
                (Iterable<Element, Absent> stream)
                given Element satisfies Object
                given Absent satisfies Null {
        value size = stream.size;
        if (size == 0) {
            assert (is Absent null);
            return null;
        }
        else if (size < 1) {
            throw OverflowException(
                "Invalid size ``size``; number of elements \
                 must be less than 'runtime.maxIntegerValue'.");
        }
        assert (exists element = stream.getFromFirst(nextInteger(size)));
        return element;
    }

    "Return an infinite stream of [[Integer]]s holding `bits` pseudorandom bits."
    shared see(`function nextBits`)
    {Integer+} bits(Integer bits)
        =>  stream(() => nextBits(bits));

    "Return an infinite stream of pseudorandom [[Integer]]s between `0` (inclusive)
     and [[bound]] (exclusive)."
    shared see(`function nextInteger`)
    {Integer+} integers(
            "The upper bound (exclusive)."
            Integer bound)
        =>  stream(() => nextInteger(bound));

    "Return an infinite stream of pseudorandom [[Boolean]]s."
    shared see(`function nextBoolean`)
    {Boolean+} booleans()
        =>  stream(nextBoolean);

    "Return an infinite stream of pseudorandom [[Byte]]s."
    shared see(`function nextByte`)
    {Byte+} bytes()
        =>  stream(nextByte);

    "Return an infinite stream of pseudorandom [[Float]]s."
    shared see(`function nextFloat`)
    {Float+} floats()
        =>  stream(nextFloat);

    "Returns an infinite stream of random elements from the given [[stream]]. The stream
     is eagerly evaluated a single time using [[Iterable.sequence]], with random elements
     being selected from the result of that evaluation.

     The result will be empty if the provided [[stream]] is empty."
    shared see(`function nextElement`)
    Iterable<Element, Absent> elements<Element, Absent>
            (Iterable<Element, Absent> stream)
            given Element satisfies Object
            given Absent satisfies Null {

        value elements = stream.sequence();
        if (!nonempty elements) {
            return elements;
        }
        return package.stream(() => nextElement(elements));
    }
}

Float floatUnit = 1.0 / 2^53; // avoid left shift on JS

Integer bitLength(variable Integer number) {
    // avoid right shift on JS
    assert(number >= 0 && number <= runtime.maxIntegerValue);
    variable value bits = 0;
    while (number > 0) {
        bits++;
        number /= 2;
    }
    return bits;
}
