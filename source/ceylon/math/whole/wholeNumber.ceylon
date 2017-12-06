/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.math {
    BigInteger {
        fromLong=valueOf
    }
}

"The given [[number]] converted to a [[Whole]]."
shared Whole wholeNumber(Integer number) {
    Integer int = number;
    if (int == 0) {
        return zeroImpl;
    } else if (int == 1) {
        return oneImpl;
    } else {
        return WholeImpl(fromLong(int));
    }
}