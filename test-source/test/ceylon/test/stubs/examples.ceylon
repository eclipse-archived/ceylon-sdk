import ceylon.test {
    ...
}
import ceylon.test.core {
    TestSkippedException
}

test
shared void foo() {
    await(10);
}

test
shared void fooThrowingAssertion() {
    throw AssertionError("assertion failed");
}

test
shared void fooThrowingException() {
    throw Exception("unexpected exception");
}

test
shared void fooThrowingIgnoreException() {
    throw TestSkippedException("ignore it!");
}

test
ignore("ignore function foo")
shared void fooWithIgnore() {}

test
shared void fooWithAssumption() {
    assumeTrue(false);
}

shared void fooWithoutTestAnnotation() {}

shared variable Bar? barInstance1 = null;
shared variable Bar? barInstance2 = null;

shared class Bar() {

    test
    shared void bar1() {
        await(10);
        barInstance1 = this;
    }
    
    test
    shared void bar2() {
        await(10);
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

shared object bar {
    
    test
    shared void bar1() {}
    
}

shared class Qux {

    shared new () {}

    test
    shared void qux1() {}

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

void await(Integer miliseconds) {
    value end = system.milliseconds + miliseconds;
    while(system.milliseconds < end) {
    }
}