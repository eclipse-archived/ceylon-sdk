import ceylon.test {
    createTestRunner,
    TestDescription
}

void runTestSorting() {
    runTests(
        `shouldSortTestsByNameAscending`,
        `shouldSortTestsByNameDescending`);
}

void shouldSortTestsByNameAscending() {
    value runResult = createTestRunner{
        sources = [`methodThrowingAssertion`, `methodFoo`, `methodThrowingException`];
        comparator = (TestDescription d1, TestDescription d2)=>d1.name.compare(d2.name);
        }.run();

   assert(runResult.results.size==3,
          runResult.results[0]?.description?.source?.equals(`function methodFoo`) else false,
          runResult.results[1]?.description?.source?.equals(`function methodThrowingAssertion`) else false,
          runResult.results[2]?.description?.source?.equals(`function methodThrowingException`) else false);
}

void shouldSortTestsByNameDescending() {
    value runResult = createTestRunner{
        sources = [`methodThrowingAssertion`, `methodFoo`, `methodThrowingException`];
        comparator = (TestDescription d1, TestDescription d2)=> d2.name.compare(d1.name);
        }.run();

   assert(runResult.results.size==3,
          runResult.results[0]?.description?.source?.equals(`function methodThrowingException`) else false,
          runResult.results[1]?.description?.source?.equals(`function methodThrowingAssertion`) else false,
          runResult.results[2]?.description?.source?.equals(`function methodFoo`) else false);
}