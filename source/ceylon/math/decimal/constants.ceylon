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
    JInteger=Integer {
        maxInt=MAX_VALUE,
        minInt=MIN_VALUE
    }
}
import java.math {
    BigDecimal
}

"A `Decimal` instance representing zero."
shared Decimal zero = DecimalImpl(BigDecimal.zero);

"A `Decimal` instance representing one."
shared Decimal one = DecimalImpl(BigDecimal.one);

"A `Decimal` instance representing ten."
shared Decimal ten = DecimalImpl(BigDecimal.ten);

Decimal intMax = decimalNumber(maxInt);
Decimal intMin = decimalNumber(minInt);
