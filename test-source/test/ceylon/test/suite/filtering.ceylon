import test.ceylon.test.stubs {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

test
shared void shouldFilterEverything() {
    value runner = createTestRunner{
        sources = [`foo`, `fooThrowingAssertion`, `fooThrowingAssertion`];
        filter = (TestDescription d)=>false;
    };

    value description = runner.description;
    assert(description.name == "root",
    description.children.size == 0);

    value result = runner.run(); 
    assertResultCounts {
        result;
        runCount = 0;
    };
}

test
shared void shouldFilterTestsByName() {
    value runner = createTestRunner{
        sources = [`foo`, `fooThrowingAssertion`, `fooThrowingAssertion`];
        filter = (TestDescription d)=>!d.name.contains("Throwing");
    };

    value description = runner.description;
    assert(description.name == "root",
           description.children.size == 1,
           description.children[0]?.declaration?.equals(`function foo`) else false); 
}

test
shared void shouldFilterTestsAndFireExcludeEvent() {
    value excludedBuilder = SequenceBuilder<TestDescription>();
    object excludedListener satisfies TestListener {
        shared actual void testExclude(TestExcludeEvent event) => excludedBuilder.append(event.description);
    }

    createTestRunner{
        sources = [`foo`, `fooThrowingAssertion`];
        listeners = [excludedListener];
        filter = (TestDescription d)=>!d.name.contains("Throwing");
    };

    assert(exists d = excludedBuilder.sequence[0]?.declaration, d == `function fooThrowingAssertion`);
}