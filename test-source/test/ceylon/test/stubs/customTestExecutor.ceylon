import ceylon.language.meta.declaration {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.test.engine.spi {
    TestExecutor,
    TestExecutionContext
}

shared variable Integer bazTestExecutorCounter = 0;
shared variable Integer bazTestInvocationCounter = 0;

shared class BazTestExecutor(FunctionDeclaration f, ClassDeclaration? c) satisfies TestExecutor {

    bazTestExecutorCounter++;

    shared actual TestDescription description => TestDescription(f.qualifiedName, f);

    shared actual void execute(TestExecutionContext context) {
        context.fire().testStarted(TestStartedEvent(description));
        f.invoke();
        context.fire().testFinished(TestFinishedEvent(TestResult(description, TestState.success)));
    }

}

test
testExecutor(`class BazTestExecutor`)
shared void bazWithCustomExecutor() {
    bazTestInvocationCounter++;
}