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

"Alias for function which filter tests."
shared alias TestFilter => Boolean(TestDescription);

"Alias for function which compare two tests."
shared alias TestComparator => Comparison(TestDescription, TestDescription);

"Represent a facade for running tests, new instance is created via factory method [[createTestRunner]]."
shared interface TestRunner {

    "The description of all tests to be run."
    shared formal TestDescription description;

    "Run all tests and return summary result."
    shared formal TestRunResult run();

}

"Create a new [[TestRunner]] for given test sources and configure it with given parameters."
shared TestRunner createTestRunner(
    "The program elements from which tests will be executed."
    TestSource[] sources,
    "The listeners which will be notified about events during test run."
    TestListener[] listeners = [],
    "The filter which allow exclude tests."
    TestFilter filter = defaultFilter,
    "The function comparing pairs of tests, which allow sort and run tests in certain order."
    TestComparator comparator = defaultComparator)
        => TestRunnerImpl(sources, listeners, filter, comparator);

Boolean defaultFilter(TestDescription description) => true;

Comparison defaultComparator(TestDescription description1, TestDescription description2) => equal;