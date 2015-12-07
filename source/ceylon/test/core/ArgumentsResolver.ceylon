import ceylon.test {
    TestDescription
}

"Represents a strategy how to resolve argument values for parameterized test.
 Its responsibility is discover annotation, which satisfy [[ArgumentsProvider]] interface, 
 collect values from them and prepare all possible combination."
shared interface ArgumentsResolver {
    
    "Resolve all combination of arguments values for given parametrized test."
    shared formal {Anything[]*} resolve(TestDescription description);
    
}