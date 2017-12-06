/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.test {
    TestDescription
}

"Represents a strategy that can resolve test variant description by provided arguments, 
 see [[ceylon.test::TestDescription.variant]]."
shared interface TestVariantProvider satisfies TestExtension {
    
    "Returns test variant description."
    shared formal String variant(TestDescription description, Integer index, Anything[] arguments);
    
}