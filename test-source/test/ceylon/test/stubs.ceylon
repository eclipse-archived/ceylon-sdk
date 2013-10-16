import ceylon.test {
    test,
    ignore,
    afterTest,
    beforeTest
}

test
shared void methodFoo() {
    sum(1..1M);
}

test
ignore("ignored method")
shared void ignoredMethod() {
}

test 
shared void methodThrowingAssertion() { 
    assert(false); 
}

test shared void methodThrowingException() { 
    throw Exception("unexpected exception"); 
}

test shared void methodWithParameter(Integer n) {
}

test shared void methodWithParameters(Integer n)(String s) {
}

test shared void methodWithTypeParameter<T>() { 
    assert(0 is T); 
}

test shared Integer methodWithReturnType() {
    return 0;
}

shared void methodWithoutTestAnnotation() {
}

variable ClassFoo? instance1 = null;
variable ClassFoo? instance2 = null;
shared class ClassFoo() {
    test shared void methodFoo() {
        sum(1..1M);
        instance1 = this;
    }
    test shared void methodBar() {
        instance2 = this;
    }
}

shared interface InterfaceFoo {
    test shared default void methodFoo() {}     
}

shared object objectFoo {
    test shared void methodFoo() {}
}

shared abstract class ClassAbstract() {
    test shared formal void methodFoo(); 
}

shared class ClassWithParameter(Integer n) {
    test shared void methodFoo() {}
}

shared class ClassWithTypeParameter<T>() {
    test shared void methodFoo() {}
    shared void useTypeParameter(T t) {}
}

shared class ClassWithoutTestableMethods() {
    shared void methodWithoutTestAnnotation() {}
}

shared class ClassOuter() {
    shared class ClassInner() {
        test shared void methodInnerFoo() {}
    }
}

ignore("ignored class")
shared class IgnoredClass() {
    shared test void methodFoo() {}
}

StringBuilder callbackLog = StringBuilder();
variable Boolean toplevelBeforeTestThrowException = false;
variable Boolean toplevelAfterTestThrowException = false;
variable Boolean memberBeforeTestThrowException = false;
variable Boolean memberAfterTestThrowException = false;
variable ClassWithCallbacks? instanceInBefore = null;
variable ClassWithCallbacks? instanceInTest = null;
variable ClassWithCallbacks? instanceInAfter = null;

beforeTest shared void toplevelBeforeTest() {
    callbackLog.append("toplevelBeforeTest").appendNewline();
    if( toplevelBeforeTestThrowException ) {
        throw Exception("toplevelBeforeTest");
    }
}

afterTest shared void toplevelAfterTest() {
    callbackLog.append("toplevelAfterTest").appendNewline();
    if( toplevelAfterTestThrowException ) {
        throw Exception("toplevelAfterTest");
    }
}

shared abstract class AbstractClassWithCallbacks() {
    
    beforeTest shared void memberInheritedBeforeTest() => callbackLog.append("memberInheritedBeforeTest").appendNewline();
    afterTest shared void memberInheritedAfterTest() => callbackLog.append("memberInheritedAfterTest").appendNewline();
    
}


shared class ClassWithCallbacks() extends AbstractClassWithCallbacks() {
    
    beforeTest shared void memberBeforeTest() {
        instanceInBefore = this;
        callbackLog.append("memberBeforeTest").appendNewline();
        if( memberBeforeTestThrowException ) {
            throw Exception("memberBeforeTest");
        }
    }
    
    test shared void methodWithCallbacks() {
        instanceInTest = this;
        callbackLog.append("methodWithCallbacks").appendNewline();
    }
    
    afterTest shared void memberAfterTest() {
        instanceInAfter = this;
        callbackLog.append("memberAfterTest").appendNewline();
        if( memberAfterTestThrowException ) {
            throw Exception("memberAfterTest");
        }
    }
    
}

shared class ClassWithBeforeNonVoid() {
    beforeTest shared Boolean before() { return true; }
    test shared void foo() {}
}

shared class ClassWithBeforeWithParameters() {
    beforeTest shared void before(String s) {}
    test shared void foo() {}
}

shared class ClassWithBeforeWithTypeParameters() {
    beforeTest shared void before<T>() { assert(0 is T); }
    test shared void foo() {}
}

shared class ClassWithAfterNonVoid() {
    afterTest shared Boolean after() { return true; }
    test shared void foo() {}
}

shared class ClassWithAfterWithParameters() {
    afterTest shared void after(String s) {}
    test shared void foo() {}
}

shared class ClassWithAfterWithTypeParameters() {
    afterTest shared void after<T>() { assert(0 is T); }
    test shared void foo() {}
}