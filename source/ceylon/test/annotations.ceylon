import ceylon.language.meta.declaration {
    Declaration,
    ClassDeclaration,
    FunctionOrValueDeclaration
}
import ceylon.test.annotation {
    AfterTestAnnotation,
    BeforeTestAnnotation,
    TestAnnotation,
    TestSuiteAnnotation,
    TestExecutorAnnotation,
    TestExtensionAnnotation,
    TagAnnotation,
    IgnoreAnnotation,
    ParametersAnnotation
}


"Marks a function as being a test.
 
 Example of simplest test:
 
     test
     shared void shouldAlwaysSucceed() {}
"
shared annotation TestAnnotation test()
        => TestAnnotation();


"Annotation to specify test suite, which allow combine several
 tests or test suites and run them together.
 
     testSuite({`class YodaTest`,
                `class DarthVaderTest`,
                `function starOfDeathTestSuite`})
     shared void starwarsTestSuite() {}
"
shared annotation TestSuiteAnnotation testSuite(
    "The program elements from which tests will be executed."
    {Declaration+} sources)
        => TestSuiteAnnotation(sources);


"Annotation to specify custom [[ceylon.test.engine.spi::TestExecutor]] 
 implementation, which will be used for running test. It can be set on 
 several places: on concrete test, on class which contains tests, on whole 
 package or even module. If multiple occurrences will be found, the most 
 closest will be used.
 
      testExecutor(`class ArquillianTestExecutor`)
      package com.acme;
"
shared annotation TestExecutorAnnotation testExecutor(
    "The class declaration of [[ceylon.test.engine.spi::TestExecutor]]."
    ClassDeclaration executor)
        => TestExecutorAnnotation(executor);


"Annotation to specify various [[ceylon.test.engine.spi::TestExtension]] 
 implementation, which will be used during running test. It can be set on 
 several places: on concrete test, on class which contains tests, on whole 
 package or even module.
 
     testExtension(`class DependencyInjectionInstancePostProcessor`,
                   `class TransactionTestListener`)
     package com.acme;
"
shared annotation TestExtensionAnnotation testExtension(
    "The class declarations of [[ceylon.test.engine.spi::TestExtension]]."
    ClassDeclaration+ extensions)
        => TestExtensionAnnotation(extensions);


"Marks a function which will be run before each test in its scope.
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `beforeTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
"
shared annotation BeforeTestAnnotation beforeTest()
        => BeforeTestAnnotation();


"Marks a function which will be run after each test in its scope.
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `afterTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
 "
shared annotation AfterTestAnnotation afterTest()
        => AfterTestAnnotation();


"Marks a test or group of tests which should not be executed,
 which will be skipped during test run. It can be set on several 
 places: on concrete test, on class which contains tests, on whole 
 package or even module.
 
     test
     ignore(\"still not implemented\")
     void shouldBeFasterThanLight() {
 
"
shared annotation IgnoreAnnotation ignore(
    "Reason why the test is ignored."
    String reason = "")
        => IgnoreAnnotation(reason);


"Marks a test or group of tests with one or more tags, 
 tags can be used for filtering, which tests will be executed.
 
 For example test, which is failing often, but from unknow reasons, 
 can be marked as _unstable_ ...
 
 ~~~~
 test
 tag(\"unstable\")
 shared void shouldSucceedWithLittleLuck() { ... }
 ~~~~
     
 ... and then excluded from test execution
 
 ~~~~plain
 $ceylon test --tag=!unstable com.acme.mymodule
 ~~~~
 
 ... or visa versa, we can execute only tests with this tag
 
 ~~~~plain
 $ceylon test --tag=unstable com.acme.mymodule
 ~~~~
 "
shared annotation TagAnnotation tag(
    "One or more tags associated with the test."
    String+ tags)
        => TagAnnotation(*tags);


"Annotations to specify source of argument values for parameterized tests, 
 can be used for whole function or individually for each parameter.
 As a source, can be used toplevel value or function, 
 which type is compatible with parameters of test function.
 
 A test function may have multiple parameters, each with own value source.
 The test engine will execute it for each combination of provided values. 
 For example, a function with one parameter whose argument provider yields two values, 
 and second parameter whose argument provider yields three values, will be executed six times.
 
 Example: 
 
     shared {[Integer, Integer]*} fibonnaciNumbers => {[1, 1], [2, 1], [3, 2], [4, 3], [5, 5], [6, 8] ...};
 
     test
     parameters(`value fibonnaciNumbers`)
     shared void shouldCalculateFibonacciNumber(Integer input, Integer result) {
         assert(fibonacciNumber(input) == result);
     }
 
"
shared annotation ParametersAnnotation parameters(
    "The source function or value declaration."
    FunctionOrValueDeclaration source)
        => ParametersAnnotation(source);
