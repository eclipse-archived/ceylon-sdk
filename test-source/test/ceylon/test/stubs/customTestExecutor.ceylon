import ceylon.language.meta.declaration {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared variable Integer bazTestExecutorCounter = 0;
shared variable Integer bazTestInvocationCounter = 0;

shared class BazTestExecutor(FunctionDeclaration f, ClassDeclaration? c) satisfies TestExecutor {

    bazTestExecutorCounter++;

    shared actual TestDescription description => TestDescription(f.qualifiedName, f);

    shared actual void execute(TestRunContext context) {
        context.fireTestStart(TestStartEvent(description));
        f.invoke();
        context.fireTestFinish(TestFinishEvent(TestResult(description, success)));
    }

}

test
testExecutor(`class BazTestExecutor`)
shared void bazWithCustomExecutor() {
    bazTestInvocationCounter++;
}