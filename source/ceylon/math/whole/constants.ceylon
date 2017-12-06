/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.lang {
    JInt=Integer {
        maxInt=MAX_VALUE
    },
    Long {
        maxLong=MAX_VALUE,
        minLong=MIN_VALUE
    }
}
import java.math {
    BigInteger
}

"A `Whole` instance representing zero."
shared Whole zero => zeroImpl;
WholeImpl zeroImpl = WholeImpl(BigInteger.zero);

"A `Whole` instance representing one."
shared Whole one => oneImpl;
WholeImpl oneImpl = WholeImpl(BigInteger.one);

"A `Whole` instance representing two."
shared Whole two = wholeNumber(2);

Whole intMax = wholeNumber(maxInt);
Whole longMax= wholeNumber(maxLong);
Whole longMin = wholeNumber(minLong);
