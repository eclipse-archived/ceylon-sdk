/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    LinkedList
}
import ceylon.language.meta {
    type
}
import ceylon.language.meta.declaration {
    FunctionDeclaration,
    FunctionOrValueDeclaration,
    ValueDeclaration,
    OpenClassOrInterfaceType
}
import ceylon.test {
    TestDescription
}
import ceylon.test.engine.spi {
    ArgumentListProvider,
    ArgumentListResolver,
    ArgumentProvider,
    ArgumentProviderContext,
    TestExecutionContext
}


"Default implementation of [[ArgumentListResolver]]."
shared class DefaultArgumentListResolver() satisfies ArgumentListResolver {
    
    shared actual {Anything[]*} resolve(TestExecutionContext context, FunctionDeclaration functionDeclaration) {
        value argListProviders = functionDeclaration.annotations<Annotation>().narrow<ArgumentListProvider>();
        if( argListProviders.size == 0 ) {
            return resolveArgProviders(context.description, functionDeclaration);
        }
        else if( argListProviders.size > 1 ) {
            errorFunctionHasMultipleArgListProviders(functionDeclaration, argListProviders);
        }
        
        assert(exists argListProvider = argListProviders.first);
        return argListProvider.argumentLists(ArgumentProviderContext(context.description, functionDeclaration));
    }
    
    {Anything[]*} resolveArgProviders(TestDescription description, FunctionDeclaration f) {
        variable LinkedList<ArgumentsList> argVariants = LinkedList({ ArgumentsList() });
        
        for(p in f.parameterDeclarations) {
            value argProvider = findArgProvider(f, p);
            value values = argProvider.arguments(ArgumentProviderContext(description, f, p));
            value newArgVariants = LinkedList<ArgumentsList>();
            for (argVariant in argVariants) {
                for (val in values) {
                    newArgVariants.add(ArgumentsList(argVariant, val));
                }
            }
            argVariants = newArgVariants;
        }
        
        return argVariants.map((e) => e.sequence());
    }
    
    ArgumentProvider findArgProvider(FunctionDeclaration f, FunctionOrValueDeclaration p) {
        value argProviders = p.annotations<Annotation>().narrow<ArgumentProvider>();
        if (argProviders.size == 0) {
            if( isTestDescription(p) ) {
                return testDescriptionArgumentProvider;
            }
            errorParameterHasNoArgProvider(f, p);
        } else if (argProviders.size > 1) {
            errorParameterHasMultipleArgProviders(f, p, argProviders);
        }
        assert (exists argProvider = argProviders.first);
        return argProvider;
    }
    
    Boolean isTestDescription(FunctionOrValueDeclaration p) {
        if( is ValueDeclaration v = p, 
            is OpenClassOrInterfaceType t = p.openType,
            t.declaration == `class TestDescription`) {
            return true;
        }
        return false;
    }
    
    void errorFunctionHasMultipleArgListProviders(FunctionDeclaration f, {ArgumentListProvider*} argListProviders) {
        value argListProviderNames = argListProviders.map((e) => type(e).declaration.name);
        throw Exception("function ``f.qualifiedName`` has multiple ArgumentListProviders: ``argListProviderNames``");
    }
    
    void errorParameterHasNoArgProvider(FunctionDeclaration f, FunctionOrValueDeclaration p) {
        throw Exception("function ``f.qualifiedName`` has parameter ``p.name`` without specified ArgumentProvider");
    }
    
    void errorParameterHasMultipleArgProviders(FunctionDeclaration f, FunctionOrValueDeclaration p, {ArgumentProvider*} argProviders) {
        value argProviderNames = argProviders.map((e) => type(e).declaration.name);
        throw Exception("function ``f.qualifiedName`` has parameter ``p.name`` with multiple ArgumentProviders: ``argProviderNames``");
    }
    
}

class ArgumentsList(ArgumentsList? head = null, Anything tail = null) extends Object() satisfies List<Anything> {
    
    shared actual Integer? lastIndex {
        if(exists head) {
            return head.lastIndex?.plus(1) else 0;
        } else {
            return null;
        }
    }
    
    shared actual Anything? getFromFirst(Integer index) {
        if( exists i = lastIndex ) {
            switch (index <=> i)
            case (smaller) { return head?.getFromFirst(index); }
            case (equal) { return tail; }
            case (larger) { return null; }
        } else {
            return null;
        }
    }
    
}

object testDescriptionArgumentProvider satisfies ArgumentProvider {
    
    shared actual {Anything*} arguments(ArgumentProviderContext context)
            => {context.description};
    
}