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
shared alias TestSource => Module|Package|ClassDeclaration|FunctionDeclaration|Class|FunctionModel;

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
     the [[sources]] parameter."
    TestComparator comparator = defaultComparator)
        => TestRunnerImpl(sources, listeners, filter, comparator);

// TODO This is where we should do the filtering of `ignored` tests
// so it's easy to override and actually run stuff which is ignored
// (e.g. it ca be useful to know which tests which are ignored actually pass)
shared Boolean defaultTestFilter(TestDescription description) => true;

Comparison defaultComparator(TestDescription description1, TestDescription description2) => equal;