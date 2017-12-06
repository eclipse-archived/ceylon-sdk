/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Shuffle the given elements. This operation modifies the `Array`."
shared void randomizeInPlace<Element>(
        Array<Element> elements, Random random = DefaultRandom()) {
    // Fisher-Yates Shuffle
    value size = elements.size;
    for (i in 0:size - 1) {
        value j = random.nextInteger(size - i) + i;
        assert (exists oldi = elements[i]);
        assert (exists oldj = elements[j]);
        elements[i] = oldj;
        elements[j] = oldi;
    }
}
