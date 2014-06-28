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
           description.children[0]?.functionDeclaration?.equals(`function foo`) else false); 
}

test
shared void shouldFilterTestsAndFireExcludeEvent() {
    value excludedList = ArrayList<TestDescription>();
    object excludedListener satisfies TestListener {
        shared actual void testExclude(TestExcludeEvent event) => excludedList.add(event.description);
    }

    createTestRunner{
        sources = [`foo`, `fooThrowingAssertion`];
        listeners = [excludedListener];
        filter = (TestDescription d)=>!d.name.contains("Throwing");
    };
    
    assertEquals(excludedList[0]?.functionDeclaration, `function fooThrowingAssertion`);
}