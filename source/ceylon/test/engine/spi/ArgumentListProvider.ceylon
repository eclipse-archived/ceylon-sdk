"Represents a contract for annotations, which serves as argument lists provider for parametrized tests.
 These annotations are used on function and are resolved during execution. Basic implementation is 
 annotation [[ceylon.test::parameters]], but custom implementation can be very easily implemented, 
 see example below.
 
 Example:
 
     shared annotation DataFileAnnotation dataFile(String fileName) => DataFileAnnotation(fileName);
     
     shared final annotation class DataFileAnnotation(String fileName)
              satisfies OptionalAnnotation<DataFileAnnotation,FunctionDeclaration> & ArgumentListProvider {
              
         shared actual {Anything[]*} argumentLists(ArgumentProviderContext context)
              => CsvFileParser(fileName).parse();         
         
     }
 
     test
     dataFile(\"people.csv\")
     shared void shouldProcessPerson(String firstname, String surname, Integer age) {
         ...
     }
 
"
shared interface ArgumentListProvider {
    
    "Returns arguments lists."
    shared formal {Anything[]*} argumentLists(ArgumentProviderContext context);
    
}