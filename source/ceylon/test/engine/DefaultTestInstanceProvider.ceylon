/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language.meta.model {
    Class
}
import ceylon.test.engine.spi {
    TestInstanceProvider,
    TestExecutionContext
}

"Default implementation of [[TestInstanceProvider]]."
shared class DefaultTestInstanceProvider() satisfies TestInstanceProvider {
    
    shared actual Object instance(TestExecutionContext context) {
        assert (exists c = context.description.classDeclaration);
        if (c.anonymous) {
            assert (exists objectInstance = c.objectValue?.get());
            return objectInstance;
        } else {
            assert (is Class<Object,[]> classModel = c.apply<Object>());
            return classModel();
        }
    }
    
}
