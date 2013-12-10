"Represent a strategy how to run test.
 During test execution notifies test mechanism about significant events via given [[TestRunContext]].
 
 Custom implementation can be specify via [[testExecutor]] annotation. It should accept two parameters:
 
    - the first parameter is own test function, 
      represented like [[FunctionDeclaration|ceylon.language.meta.declaration::FunctionDeclaration]]
    - the second parameter is class containg this test function, if exists, 
      represented like [[ClassDeclaration?|ceylon.language.meta.declaration::ClassDeclaration]]
 
"
shared interface TestExecutor {

    "The description of the test to be run."
    shared formal TestDescription description;

    "Run the test."
    shared formal void execute(
        "The context of this test."TestRunContext context);

}