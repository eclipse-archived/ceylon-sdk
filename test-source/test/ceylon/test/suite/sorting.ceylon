import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}

test
shared void shouldSortTestsByNameAscending() {
    value runResult = createTestRunner{
        sources = [`fooThrowingAssertion`, `fooThrowingException`, `foo`];
        comparator = (TestDescription d1, TestDescription d2)=>d1.name.compare(d2.name);
    }.run();
    
    assertEquals(runResult.results.size, 3);
    assertEquals(runResult.results[0]?.description?.functionDeclaration, `function foo`);
    assertEquals(runResult.results[1]?.description?.functionDeclaration, `function fooThrowingAssertion`);
    assertEquals(runResult.results[2]?.description?.functionDeclaration, `function fooThrowingException`);
}

test
shared void shouldSortTestsByNameDescending() {
    value runResult = createTestRunner{
        sources = [`fooThrowingAssertion`, `fooThrowingException`, `foo`];
        comparator = (TestDescription d1, TestDescription d2)=> d2.name.compare(d1.name);
    }.run();
    
    assertEquals(runResult.results.size, 3);
    assertEquals(runResult.results[0]?.description?.functionDeclaration, `function fooThrowingException`);
    assertEquals(runResult.results[1]?.description?.functionDeclaration, `function fooThrowingAssertion`);
    assertEquals(runResult.results[2]?.description?.functionDeclaration, `function foo`);
}