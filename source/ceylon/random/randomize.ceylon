/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Shuffle the given elements, returning a new `List`."
shared List<Elements> randomize<Elements>
        ({Elements*} elements, Random random = DefaultRandom()) {
    value result = Array(elements);
    randomizeInPlace<Elements>(result, random);
    return result;
}
