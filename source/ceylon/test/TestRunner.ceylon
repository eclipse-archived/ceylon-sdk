import ceylon.language.meta.declaration {
...
}
import ceylon.language.meta.model {
...
}
import ceylon.test.internal {
    TestRunnerImpl
}

"Alias for program elements from which tests can be run."
shared alias TestSource => Module|Package|ClassDeclaration|FunctionDeclaration|Class|FunctionModel|String;

"Alias for functions which filter tests. 
 Should return true if the given test should be run."
shared alias TestFilter => Boolean(TestDescription);

"Alias for functions which compare two tests."
shared alias TestComparator => Comparison(TestDescription, TestDescription);

"Represents a facade for running tests.
 
 Instances are usually created via the [[createTestRunner]] factory method. 
 For running tests is more convenient to use command line tool `ceylon test` 
 or use integration with IDE, so it is not necessary to use this API directly."
shared interface TestRunner {

    "The description of all tests to be run."
    shared formal TestDescription description;

    "Runs all the tests and returns a summary result."
    shared formal TestRunResult run();

}

"Create a new [[TestRunner]] for the given test sources and configures it 
 according to the given parameters."
shared TestRunner createTestRunner(
    "The program elements from which tests will be executed."
    TestSource[] sources,
    "The listeners which will be notified about events during the test run."
    TestListener[] listeners = [],
    "A filter function for determining which tests should be run.
     Returns true if the test should be run. 
     The default filter always returns true."
    TestFilter filter = defaultTestFilter,
    "A comparator used to sort the tests, used tests in certain order.
     The default comparator runs the tests in alphabetical order."
    TestComparator comparator = defaultTestComparator)
        => TestRunnerImpl(sources, listeners, filter, comparator);

"Default test filter, always return true."
shared Boolean defaultTestFilter(TestDescription description) => true;

"Default test comparator sort tests alphabetically."
shared Comparison defaultTestComparator(TestDescription description1, TestDescription description2) => description1.name <=> description2.name;