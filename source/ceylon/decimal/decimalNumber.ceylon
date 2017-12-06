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
    Whole
}

import java.math {
    BigDecimal
}

"The given [[number]] converted to a [[Decimal]]."
// TODO: Document peculiarities of passing a Float or switch
//       to using valueOf(double)
shared Decimal decimalNumber(Whole|Integer|Float number,
                             Rounding? rounding = null) {
    BigDecimal val;
    switch(number)
    case(Whole) {
        if (is RoundingImpl rounding) {
            value bi = toBigInteger(number);
            val = BigDecimal(bi).plus(rounding.implementation);
        } else {
            value bi = toBigInteger(number);
            val = BigDecimal(bi);
        }
    }
    case(Integer) {
        if (is RoundingImpl rounding) {
            val = BigDecimal(number, rounding.implementation);
        } else {
            val = BigDecimal(number);
        }
    }
    case(Float) {
        if (is RoundingImpl rounding) {
            val = BigDecimal(number, rounding.implementation);
        } else {
            val = BigDecimal(number);
        }
    }
    return DecimalImpl(val);
}
