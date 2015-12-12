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


"Default implementation of [[ArgumentListResolver]]."
shared class DefaultArgumentListResolver() satisfies ArgumentListResolver {
    
    shared actual {Anything[]*} resolve(TestDescription description) {
        assert(exists f = description.functionDeclaration);
        
        value argListProviders = f.annotations<Annotation>().narrow<ArgumentListProvider>();
        if( argListProviders.size == 0 ) {
            return resolveArgProviders(description);
        }
        else if( argListProviders.size > 1 ) {
            errorFunctionHasMultipleArgListProviders(f, argListProviders);
        }
        
        assert(exists argListProvider = argListProviders.first);
        return argListProvider.argumentLists(ArgumentProviderContext(description));
    }
    
    {Anything[]*} resolveArgProviders(TestDescription description) {
        assert(exists f = description.functionDeclaration);
        value argProviders = f.parameterDeclarations.map((p) => [p, resolveArgProvider(f, p)]);
        return calculateArgVariants(description, argProviders);
    }
    
    ArgumentProvider resolveArgProvider(FunctionDeclaration f, FunctionOrValueDeclaration p) {
        value argProviders = p.annotations<Annotation>().narrow<ArgumentProvider>();
        if (argProviders.size == 0) {
            errorParameterHasNoArgProvider(f, p);
        } else if (argProviders.size > 1) {
            errorParameterHasMultipleArgProviders(f, p, argProviders);
        }
        assert (exists argProvider = argProviders.first);
        return argProvider;
    }
    
    {Anything[]*} calculateArgVariants(TestDescription description, {[FunctionOrValueDeclaration, ArgumentProvider]*} argProviders) {
        variable LinkedList<ArgumentsList> argVariants = LinkedList({ ArgumentsList() });
        for (argProvider in argProviders) {
            value values = argProvider[1].arguments(ArgumentProviderContext(description, argProvider[0]));
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