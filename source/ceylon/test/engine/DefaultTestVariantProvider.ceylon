/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.test.engine.spi {
    TestVariantProvider
}
import ceylon.test {
    TestDescription
}

"Default implementation of [[TestVariantProvider]]."
shared class DefaultTestVariantProvider() satisfies TestVariantProvider {
    
    shared actual String variant(TestDescription description, Integer index, Anything[] arguments) {
        value result = StringBuilder();
        
        result.append("(");
        for(arg in arguments.indexed) {
            result.append(stringify(arg.item));
            if( arg.key < arguments.size-1 ) {
                result.append(", ");            
            }
        }
        result.append(")");
        
        return result.string;
    }
    
    String stringify(Anything item) {
        switch(item)
        case(Null) {
             return "<null>";
        }
        case(String) {
            return "\"``item``\"";
        }
        case(Character) {
            return "'``item``'";
        }
        else {
             return item.string;
        }
    }
    
}