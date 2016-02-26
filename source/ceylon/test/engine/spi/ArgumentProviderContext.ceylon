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