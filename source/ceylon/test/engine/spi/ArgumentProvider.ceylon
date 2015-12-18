"Represents a contract for annotations, which serves as arguments provider for parametrized tests.
 These annotations are used on parameters and are resolved during execution of parameterized tests. 
 Basic implementation is annotation [[ceylon.test::parameters]], but custom implementation can be 
 very easily implemented, see example below.
 
 Example (`random` annotation is custom implementation of `ArgumentProvider`, which returns random number for every test):
 
     shared annotation RandomAnnotation random() => RandomAnnotation();
     
     shared final annotation class RandomAnnotation()
              satisfies OptionalAnnotation<RandomAnnotation,FunctionOrValueDeclaration> & ArgumentProvider {
              
         shared actual {Anything*} arguments(ArgumentProviderContext context)
              => randomGenerator.nextInteger();
         
     }
 
     test
     shared void shouldGuessNumber(random Integer num) {
         assert(magician.guessNumber() == num);
     }
 
"
shared interface ArgumentProvider {
    
    "Returns arguments values."
    shared formal {Anything*} arguments(ArgumentProviderContext context);
    
}