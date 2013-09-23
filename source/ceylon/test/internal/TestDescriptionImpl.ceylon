import ceylon.test {
    TestDescription,
    TestSource
}

class TestDescriptionImpl(name, source = null, children = []) satisfies TestDescription {

    shared actual String name;

    shared actual TestSource? source;

    shared actual TestDescription[] children;

    shared actual String string => name;

}