/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language.meta.declaration {
    FunctionDeclaration
}

"Represents a strategy how to resolve argument lists for parameterized test.
 Its responsibility is discover annotation, which satisfy [[ArgumentListProvider]] or 
 [[ArgumentProvider]] interface, collect values from them and prepare all possible combination."
shared interface ArgumentListResolver satisfies TestExtension {
    
    "Resolve all combination of argument lists for given parametrized test or before/after callback"
    shared formal {Anything[]*} resolve(TestExecutionContext context, FunctionDeclaration functionDeclaration);
    
}