import ceylon.collection {
    LinkedList
}
import ceylon.language.meta {
    type
}
import ceylon.language.meta.declaration {
    FunctionDeclaration,
    FunctionOrValueDeclaration
}
import ceylon.test {
    TestDescription
}


"Default implementation of [[ArgumentsResolver]]."
shared class DefaultArgumentsResolver() satisfies ArgumentsResolver {
    
    shared actual {Anything[]*} resolve(TestDescription description) {
        assert(exists f = description.functionDeclaration);
        
        value argProviders = f.annotations<Annotation>().narrow<ArgumentsProvider>();
        if( argProviders.size == 0 ) {
            return valuesFromParametersArgProviders(description);
        }
        else if( argProviders.size > 1 ) {
            errorFunctionHasMultipleArgProviders(f, argProviders);
        }
        
        assert(exists argProvider = argProviders.first);
        return valuesFromFunctionArgProvider(description, argProvider);
    }
    
    {Anything[]*} valuesFromFunctionArgProvider(TestDescription description, ArgumentsProvider argProvider) {
        value result = argProvider.values(ArgumentsProviderContext(description, null));
        if(is Iterable<Anything[], Null> result) {
            return result;
        } else if(is Iterable<Anything, Null> result) {
            return result.map((Anything e) => [e]);
        } else {
            return {[result]};
        }
    }
    
    {Anything[]*} valuesFromParametersArgProviders(TestDescription description) {
        value argProviders = resolveArgProviders(description);
        return calculateArgVariants(description, argProviders);
    }
    
    {Anything[]*} calculateArgVariants(TestDescription description, {[FunctionOrValueDeclaration, ArgumentsProvider]*} argProviders) {
        variable LinkedList<ArgumentsList> argVariants = LinkedList({ ArgumentsList() });
        for (argProvider in argProviders) {
            value values = argProvider[1].values(ArgumentsProviderContext(description, argProvider[0]));
            value newArgVariants = LinkedList<ArgumentsList>();
            for (argVariant in argVariants) {
                if (is Iterable<Anything,Null> values) {
                    for (val in values) {
                        newArgVariants.add(ArgumentsList(argVariant, val));
                    }
                } else {
                    newArgVariants.add(ArgumentsList(argVariant, values));
                }
            }
            argVariants = newArgVariants;
        }
        return argVariants.map((e) => e.sequence());
    }
    
    {[FunctionOrValueDeclaration, ArgumentsProvider]*} resolveArgProviders(TestDescription description) {
        assert(exists f = description.functionDeclaration);
        return f.parameterDeclarations.map((p) => [p, resolveArgProvider(f, p)]);
    }
    
    ArgumentsProvider resolveArgProvider(FunctionDeclaration f, FunctionOrValueDeclaration p) {
        value argProviders = p.annotations<Annotation>().narrow<ArgumentsProvider>();
        if (argProviders.size == 0) {
            errorParameterHasNoArgProvider(f, p);
        } else if (argProviders.size > 1) {
            errorParameterHasMultipleArgProviders(f, p, argProviders);
        }
        assert (exists argProvider = argProviders.first);
        return argProvider;
    }
    
    void errorFunctionHasMultipleArgProviders(FunctionDeclaration f, {ArgumentsProvider*} argProviders) {
        value argProviderNames = argProviders.map((e) => type(e).declaration.name);
        throw Exception("function ``f.qualifiedName`` has multiple argument providers: ``argProviderNames``");
    }
    
    void errorParameterHasNoArgProvider(FunctionDeclaration f, FunctionOrValueDeclaration p) {
        throw Exception("function ``f.qualifiedName`` has parameter ``p.name`` without specified argument provider");
    }
    
    void errorParameterHasMultipleArgProviders(FunctionDeclaration f, FunctionOrValueDeclaration p, {ArgumentsProvider*} argProviders) {
        value argProviderNames = argProviders.map((e) => type(e).declaration.name);
        throw Exception("function ``f.qualifiedName`` has parameter ``p.name`` with multiple argument providers: ``argProviderNames``");
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