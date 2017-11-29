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
    FunctionOrValueDeclaration,
    FunctionDeclaration
}
import ceylon.test {
    TestDescription
}

"Represents a context given to [[ArgumentProvider]] or [[ArgumentListProvider]] 
 when arguments values are collected."
shared class ArgumentProviderContext(description, functionDeclaration, parameterDeclaration = null) {

    "The description of parameterized test."
    shared TestDescription description;
    
    "The function declaration."
    shared FunctionDeclaration functionDeclaration;
    
    "The parameter declaration, if arguments values are resolved per parameter."
    shared FunctionOrValueDeclaration? parameterDeclaration;
    
}