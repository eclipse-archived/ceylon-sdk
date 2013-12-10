import ceylon.test {
    ...
}

test
shared void foo() {
    sum(0..1M);
}

test
shared void fooThrowingAssertion() {
    throw AssertionException("assertion failed");
}

test
shared void fooThrowingException() {
    throw Exception("unexpected exception");
}

test
ignore("ignore function foo")
shared void fooWithIgnore() {}

shared void fooWithoutTestAnnotation() {}

shared variable Bar? barInstance1 = null;
shared variable Bar? barInstance2 = null;

shared class Bar() {

    test
    shared void bar1() {
        sum(0..1M);
        barInstance1 = this;
    }
    
    test
    shared void bar2() {
        sum(0..1M);
        barInstance2 = this;
    }

}

shared class BarExtended() extends Bar() {

    test
    shared void bar3() {}

}

ignore
shared class BarWithIgnore() {

    test
    shared void bar1() {}

    test
    shared void bar2() {}

}

shared class BarWithInheritedIgnore() extends BarWithIgnore() {

    test
    shared void bar3() {}

}

testSuite({`function foo`, `class Bar`})
shared void bazSuite() {}

testSuite({`function bazSuite`})
shared void bazSuiteNested() {}

// XXX workaround: following code should be in bugs.ceylon, but due error in metamodel can't

shared interface BugInterface {
    test shared default void f() {}     
}

testSuite({`interface BugInterface`})
shared void bugTestSuiteWithInterface() {
}

testSuite({`package test.ceylon.test.stubs.empty`})
shared void bugTestSuiteWithEmptyPackage() {
}