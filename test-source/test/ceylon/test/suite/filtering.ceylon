import test.ceylon.test.stubs {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.collection {
    ArrayList
}

test
void shouldFilterEverything() {
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
void shouldFilterTestsByName() {
    value runner = createTestRunner{
        sources = [`foo`, `fooThrowingAssertion`, `fooThrowingAssertion`];
        filter = (TestDescription d)=>!d.name.contains("Throwing");
    };

    value description = runner.description;
    assert(description.name == "root",
           description.children.size == 1,
           description.children[0]?.functionDeclaration?.equals(`function foo`) else false); 
}

test
void shouldFilterTestsAndFireExcludeEvent() {
    value excludedList = ArrayList<TestDescription>();
    object excludedListener satisfies TestListener {
        shared actual void testExcluded(TestExcludedEvent event) => excludedList.add(event.description);
    }

    createTestRunner{
        sources = [`foo`, `fooThrowingAssertion`];
        extensions = [excludedListener];
        filter = (TestDescription d)=>!d.name.contains("Throwing");
    };
    
    assertEquals(excludedList[0]?.functionDeclaration, `function fooThrowingAssertion`);
}