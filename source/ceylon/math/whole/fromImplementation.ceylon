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
    BigInteger
}

"Converts a platform-specific implementation object to a 
 `Whole` instance. This is provided for interoperation 
 with the runtime platform."
//see(Whole.implementation)
shared Whole fromImplementation(Object implementation) {
    assert (is BigInteger implementation);
    return WholeImpl(implementation);
}