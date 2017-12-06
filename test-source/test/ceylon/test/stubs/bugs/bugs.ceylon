import ceylon.test {
    ...
}

test 
shared void bugFunctionWithTypeParameter<T>() { 
    assert(0 is T); 
}

test 
shared Integer bugFunctionWithReturnType() {
    return 0;
}

shared void bugFunctionWithoutTestAnnotation() {
}

shared abstract class BugAbstractClass() {
    test shared formal void f();
}

shared class BugClassWithParameter(Integer n) {
    test shared void f() {}
}

shared class BugClassWithTypeParameter<T>() {
    test shared void f() {}
    shared void useTypeParameter(T t) {}
}

shared class BugClassWithoutTestableMethods() {
    shared void f() {}
}

shared class BugClassOuter() {
    shared class BugClassInner() {
        test shared void f() {}
    }
}

shared Integer i = 0;

testSuite({`value i`})
shared void bugTestSuiteWithInvalidSource() {}

test
testSuite({`function bugFunctionWithReturnType`})
shared void bugTestSuiteWithTestAnnotation() {}

shared class BugClassWithBeforeTestRunCallback() {
    beforeTestRun shared void beforeTestRunCallback() {}
    test shared void f() {}
}

shared class BugClassWithAfterTestRunCallback() {
    afterTestRun shared void afterTestRunCallback() {}
    test shared void f() {}
}

shared class BugListenerThrowingExceptionInConstructor satisfies TestListener {
    
    shared new () {
        throw Exception("oops!");
    }
    
}

testExtension(`class BugListenerThrowingExceptionInConstructor`)
shared class BugClassWithBrokenListener() {
    test shared void f() {}     
}