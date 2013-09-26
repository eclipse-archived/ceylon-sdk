import ceylon.test {
    createTestRunner,
    TestDescription
}

void runTestFiltering() {
    runTests(`shouldFilterTestsByName`);
}

void shouldFilterTestsByName() {
    value runner = createTestRunner{
        sources = [`methodFoo`, `methodThrowingAssertion`, `methodThrowingException`];
        filter = (TestDescription d)=>!d.name.contains("Throwing");
    };
    value description = runner.description;
    assert(description.name == "root",
           description.children.size == 1,
           description.children[0]?.declaration?.equals(`function methodFoo`) else false); 
}