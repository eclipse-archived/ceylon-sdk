/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Provides limits relevant to generating random numbers on the current runtime."
by ("John Vasileff")
shared object randomLimits {

    "The largest value that may be used as an argument to [[Random.nextInteger]].
     `maxIntegerBound` is the lesser of:

     1. [[runtime.maxIntegerValue]], and

     1. 2<sup>n</sup>-1, where n = [[maxBits]].

     On both the Java and JavaScript runtimes, `maxIntegerBound` is equal
     to [[runtime.maxIntegerValue]]."
    shared Integer maxIntegerBound;// = runtime.maxIntegerValue;

    "The largest value that may be used as an argument to [[Random.nextBits]]. `maxBits`
     is the greater of:

     1. [[runtime.integerAddressableSize]], and

     1. The number of bits required to represent [[runtime.maxIntegerValue]] if the value
     of `maxIntegerBound` can be represented by 2<sup>n</sup>-1 for some `n`. Otherwise,
     one less than the number of bits required to represent [[runtime.maxIntegerValue]].

     `maxBits` is `64` for the Java runtime and `53` for the
     JavaScript runtime."
    shared Integer maxBits;

    // calculate maxBits
    variable value maxValue = runtime.maxIntegerValue;
    variable value bits = 0;
    while (maxValue > 0) {
        bits++;
        maxValue /= 2;
    }
    // reduce by one if not "all 1's"
    // which is a theoretical concern; JS will be 53, Java 63
    if ((2^bits-1) > runtime.maxIntegerValue) {
        bits--;
    }
    maxBits = largest(bits, runtime.integerAddressableSize);

    // calculate maxIntegerBound
    maxIntegerBound = smallest(runtime.maxIntegerValue,
        2^smallest(63, maxBits) - 1);
}
