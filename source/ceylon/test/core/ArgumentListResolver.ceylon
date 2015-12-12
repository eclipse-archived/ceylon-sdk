import ceylon.test {
    TestDescription
}

"Represents a strategy how to resolve argument lists for parameterized test.
 Its responsibility is discover annotation, which satisfy [[ArgumentListProvider]] or 
 [[ArgumentProvider]] interface, collect values from them and prepare all possible combination."
shared interface ArgumentListResolver {
    
    "Resolve all combination of argument lists for given parametrized test."
    shared formal {Anything[]*} resolve(TestDescription description);
    
}