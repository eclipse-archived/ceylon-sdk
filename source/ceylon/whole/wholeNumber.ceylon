/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The given [[number]] converted to a [[Whole]]."
throws (`class OverflowException`,
        "if the number is greater than [[runtime.maxIntegerValue]]
         or less than [[runtime.minIntegerValue]]")
shared
Whole wholeNumber(variable Integer number)
    =>   if (number == -1) then negativeOne
    else if (number == 0)  then zero
    else if (number == 1)  then one
    else if (number == 2)  then two
    else if (number == 10) then ten
    else WholeImpl.ofWords(number.sign,
                        wordsUnsignedInteger(number));

MutableWhole mutableWholeNumber(variable Integer number)
    =>  MutableWhole.copyOfWords(number.sign,
                wordsUnsignedInteger(number));

Words wordsUnsignedInteger(variable Integer integer) {
    // * Bitwise operations are not used; JavaScript's min/max Integer range
    //   is greater than what is supported by runtime.integerAddressableSize
    //
    // * The absolute value is not calculated as an initial step; on the JVM,
    //   runtime.minIntegerValue.magnitude == runtime.minIntegerValue
    //
    // * These min/max limits were chosen as sane, justifiable, and
    //   easily documented values. A 64-bit range would require additional
    //   constants. Using runtime.integerAddressableSize would seem punitive
    //   on JavaScript, and would also require new constants.
    //
    // * Having no limits at all would allow numbers as large as 1.79E+308,
    //   and would require a different conversion method.
    if (! runtime.minIntegerValue <= integer <= runtime.maxIntegerValue) {
        throw OverflowException();
    }
    value wBits = wordBits;
    value wRadix = wordRadix;

    value highBit = unsignedHighestNonZeroBit(integer);
    value wordsSize = (highBit + wBits)/wBits;
    value words = wordsOfSize(wordsSize);
    for (i in 0:wordsSize) {
        variable value word = integer % wRadix;
        if (word < 0) {
            // avoid boxing w/word.magnitude
            word = -word;
        }
        words.set(i, word);
        integer /= wRadix;
    }
    return words;
}
