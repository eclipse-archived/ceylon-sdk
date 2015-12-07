"Represents a contract for annotation, which serves as arguments values provider for parametrized tests.
 These annotations are resolved during execution of parameterized tests, and can be specified on test 
 function or individually on each parameter. Basic implementation is annotation [[ceylon.test::parameters]]
 but custom implementation can be very easily implemented, see example below.
 
 Example (`random` annotation is custom implementation of `ArgumentProvider`, which returns random number for every test):
 
     shared annotation RandomAnnotation random() => RandomAnnotation();
     
     shared final annotation class RandomAnnotation()
              satisfies OptionalAnnotation<RandomAnnotation,FunctionOrValueDeclaration> & ArgumentsProvider {
              
         shared actual Anything values(ArgumentsProviderContext context)
              => randomGenerator.nextInteger();
         
     }
 
     test
     shared void shouldGuessNumber(random Integer num) {
         assert(magician.guessNumber() == num);
     }
 
"
shared interface ArgumentsProvider {
    
    "Returns arguments values."
    shared formal Anything values(ArgumentsProviderContext context);
    
}