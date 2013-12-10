import ceylon.language.meta.declaration {
    ...
}

"Marks a function as being a test.
 Only nullary functions should be annotated with `test`.
 
 Example of simplest test:
 
     test
     shared void shouldAlwaysSucceed() {}
"
shared annotation TestAnnotation test() => TestAnnotation();


"Annotation to specify test suite, which allow combine several tests or test suites and run them together.
 
     testSuite({`class YodaTest`,
                `class DarthVaderTest`,
                `function starOfDeathTestSuite`})
     shared void starwarsTestSuite() {}
"
shared annotation TestSuiteAnnotation testSuite(
    "The program elements from which tests will be executed." {Declaration+} sources) => TestSuiteAnnotation(sources);


"Annotation to specify custom [[TestExecutor]] implementation, which will be used for running test.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 If multiple occurrences will be found, the most closest will be used.
 
      testExecutor(`class ArquillianTestExecutor`)
      package com.acme;
"
shared annotation TestExecutorAnnotation testExecutor(
    "The class declaration of [[TestExecutor]]." ClassDeclaration executor) => TestExecutorAnnotation(executor);


"Annotation to specify custom [[TestListener]]s, which will be used during running test.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 If multiple occurrences will be found, all listeners will be used.
 
     testListeners({`class DependencyInjectionTestListener`,
                    `class TransactionalTestListener`})
     package com.acme;
"
shared annotation TestListenersAnnotation testListeners(
    "The class declarations of [[TestListener]]s" {ClassDeclaration+} listeners) => TestListenersAnnotation(listeners);


"Marks a function which will be run before each test in its scope.
 
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `beforeTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
"
shared annotation BeforeTestAnnotation beforeTest() => BeforeTestAnnotation();


"Marks a function which will be run after each test in its scope.
 
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `afterTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
 "
shared annotation AfterTestAnnotation afterTest() => AfterTestAnnotation();


"Marks a test or group of tests which should not be executed.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 
     test
     ignore(\"still not implemented\")
     void shouldBeFasterThanLight() {
 
"
shared annotation IgnoreAnnotation ignore(
    "Reason why the test is ignored." String reason = "") => IgnoreAnnotation(reason);


"Annotation class for [[test]]."
shared final annotation class TestAnnotation() 
        satisfies OptionalAnnotation<TestAnnotation, FunctionDeclaration> {}


"Annotation class for [[testSuite]]"
shared final annotation class TestSuiteAnnotation(
    "The program elements from which tests will be executed." shared {Declaration+} sources) 
        satisfies OptionalAnnotation<TestSuiteAnnotation, FunctionDeclaration> {}


"Annotation class for [[testExecutor]]."
shared final annotation class TestExecutorAnnotation(
    "The class declaration of [[TestExecutor]]." shared ClassDeclaration executor) 
        satisfies OptionalAnnotation<TestExecutorAnnotation, FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[testListeners]]."
shared final annotation class TestListenersAnnotation(
    "The class declarations of [[TestListener]]s" shared {ClassDeclaration+} listeners) 
        satisfies OptionalAnnotation<TestListenersAnnotation, FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[beforeTest]]."
shared final annotation class BeforeTestAnnotation() 
        satisfies OptionalAnnotation<BeforeTestAnnotation, FunctionDeclaration> {}


"Annotation class for [[afterTest]]."
shared final annotation class AfterTestAnnotation() 
        satisfies OptionalAnnotation<AfterTestAnnotation, FunctionDeclaration> {}


"Annotation class for [[ignore]]."
shared final annotation class IgnoreAnnotation(
    "Reason why the test is ignored." shared String reason) 
        satisfies OptionalAnnotation<IgnoreAnnotation, FunctionDeclaration|ClassDeclaration|Package|Module> {}