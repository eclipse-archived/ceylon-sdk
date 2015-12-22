import ceylon.test {
    test,
    testExtension
}
import ceylon.test.engine.spi {
    TestExecutionContext,
    TestInstanceProvider,
    TestInstancePostProcessor
}

shared class BazInstanceProvider() satisfies TestInstanceProvider {
    
    instance(TestExecutionContext context) => bazWithInstanceProvider;
}

shared class BazInstancePostProcessor1() satisfies TestInstancePostProcessor {
    
    shared actual void postProcessInstance(TestExecutionContext context, Object instance) {
        assert (is BazWithInstanceProvider instance);
        instance.log.append("BazInstancePostProcessor1").appendNewline();
    }
}

shared class BazInstancePostProcessor2() satisfies TestInstancePostProcessor {
    
    shared actual void postProcessInstance(TestExecutionContext context, Object instance) {
        assert (is BazWithInstanceProvider instance);
        instance.log.append("BazInstancePostProcessor2").appendNewline();
    }
}

shared BazWithInstanceProvider bazWithInstanceProvider = BazWithInstanceProvider();

testExtension(`class BazInstanceProvider`)
testExtension(`class BazInstancePostProcessor1`)
shared class BazWithInstanceProvider() {
    
    shared StringBuilder log = StringBuilder();
    
    test
    shared void m1() {
        assert (this == bazWithInstanceProvider);
        log.append("BazWithInstanceProvider.m1").appendNewline();
    }
    
    test
    testExtension(`class BazInstancePostProcessor2`)
    shared void m2() {
        assert (this == bazWithInstanceProvider);
        log.append("BazWithInstanceProvider.m2").appendNewline();
    }
    
}
