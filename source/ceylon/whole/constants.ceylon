/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A `Whole` instance representing zero."
shared Whole zero = WholeImpl.ofWords(0, wordsOfSize(0));

"A `Whole` instance representing one."
shared Whole one = WholeImpl.ofWords(1, wordsOfOne(1));

"A `Whole` instance representing negative one."
Whole negativeOne = WholeImpl.ofWords(-1, wordsOfOne(1));

"A `Whole` instance representing two."
shared Whole two = WholeImpl.ofWords(1, wordsOfOne(2));

"A `Whole` instance representing ten."
Whole ten = WholeImpl.ofWords(1, wordsOfOne(10));

// These are used for Whole.offset, so integerAddressableSize is irrelevant
Whole integerMax = wholeNumber(runtime.maxIntegerValue);
Whole integerMin = wholeNumber(runtime.minIntegerValue);

// Word size is 32 for the Java Runtime, 16 for JavaScript
// any factor of integerAddressableSize <= iAS / 2 will work
Integer wordBits = runtime.integerAddressableSize / 2;
Integer wordMask = 2 ^ wordBits - 1;
Integer wordRadix = 2 ^ wordBits;

Integer minAddressableInteger = 1.leftLogicalShift(runtime.integerAddressableSize-1);
Integer maxAddressableInteger = minAddressableInteger.not;

Boolean usesTwosComplementArithmetic = minAddressableInteger == -minAddressableInteger;

MutableWhole mutableZero() => MutableWhole.ofWords(0, wordsOfSize(0));
MutableWhole mutableOne() => MutableWhole.ofWords(1, wordsOfOne(1));
MutableWhole mutableNegativeOne() => MutableWhole.ofWords(-1, wordsOfOne(1));

object dummyWords satisfies Words {
    shared actual
    Words clone() {
        throw AssertionError("Misuse of internal object.");
    }

    shared actual
    void copyTo(Words destination, Integer sourcePosition, Integer destinationPosition,
            Integer length) {
        throw AssertionError("Misuse of internal object.");
    }

    shared actual Integer get(Integer index) {
        throw AssertionError("Misuse of internal object.");
    }

    shared actual void set(Integer index, Integer word) {
        throw AssertionError("Misuse of internal object.");
    }

    shared actual Integer size {
        throw AssertionError("Misuse of internal object.");
    }
}
