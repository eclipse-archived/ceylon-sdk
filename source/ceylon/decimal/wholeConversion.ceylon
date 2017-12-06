/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.whole {
    Whole,
    parseWhole
}

import java.math {
    BigInteger
}

BigInteger toBigInteger(Whole whole) {
    if (whole.zero) {
        return BigInteger.zero;
    }
    else if (whole.unit) {
        return BigInteger.one;
    }
    else {
        variable value wholeMagnitude = whole.magnitude;
        variable value result = BigInteger.zero;
        variable value shift = 0;
        while (!wholeMagnitude.zero) {
            value x = BigInteger.valueOf(
                wholeMagnitude.integer.and(#ffffffff)).shiftLeft(shift);
            result = result.or(x);
            wholeMagnitude = wholeMagnitude.rightArithmeticShift(32);
            shift += 32;
        }
        if (whole.negative) {
            result = result.negate();
        }
        return result;
    }
}

Whole toWhole(BigInteger implementation) {
    assert (exists whole = parseWhole(implementation.string));
    return whole;
}
