import ceylon.language.meta.declaration {
    Module,
    Package,
    ClassDeclaration,
    FunctionDeclaration
}
import ceylon.language.meta.model {
    Class,
    FunctionModel
}
import ceylon.test.internal {
    TestRunnerImpl
}

"Alias for program elements from which tests can be run."
shared alias TestSource => Module|Package|ClassDeclaration|FunctionDeclaration|Class|FunctionModel|String|Anything()|[Anything(), String];

"Alias for functions which filter tests. 
 Should return true if the given test should be run."
shared alias TestFilter => Boolean(TestDescription);

"Alias for functions which compare two tests."
shared alias TestComparator => Comparison(TestDescription, TestDescription);

"Represents a facade for running tests. 
 Instances are usually created via the [[createTestRunner]] factory method."
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
     The default comparator runs the tests in the order they are given in 
     the _sources_ parameter."
    TestComparator comparator = defaultTestComparator)
        => TestRunnerImpl(sources, listeners, filter, comparator);

"Default test filter, always return true."
shared Boolean defaultTestFilter(TestDescription description) => true;

"Default test comparator, doesn't change tests order."
shared Comparison defaultTestComparator(TestDescription description1, TestDescription description2) => equal;