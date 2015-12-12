import ceylon.test {
    TestDescription
}
import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}

"Represents a context given to [[ArgumentProvider]] or [[ArgumentListProvider]] 
 when arguments values are collected."
shared class ArgumentProviderContext(description, parameter = null) {

    "The description of parametrized test."
    shared TestDescription description;
    
    "The parameter declaration, if arguments values are resolved per parameter."
    shared FunctionOrValueDeclaration? parameter;
    
}