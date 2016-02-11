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