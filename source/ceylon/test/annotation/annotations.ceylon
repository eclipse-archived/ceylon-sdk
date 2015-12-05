import ceylon.language.meta.declaration {
    ClassDeclaration,
    Package,
    Declaration,
    Module,
    FunctionDeclaration
}
import ceylon.test {
    TestDescription,
    TestCondition
}


"Annotation class for [[ceylon.test::test]]."
shared final annotation class TestAnnotation()
        satisfies OptionalAnnotation<TestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::testSuite]]"
shared final annotation class TestSuiteAnnotation(
    "The program elements from which tests will be executed."
    shared {Declaration+} sources)
        satisfies OptionalAnnotation<TestSuiteAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::testExecutor]]."
shared final annotation class TestExecutorAnnotation(
    "The class declaration of [[ceylon.test::TestExecutor]]."
    shared ClassDeclaration executor)
        satisfies OptionalAnnotation<TestExecutorAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[ceylon.test::testListeners]]."
shared final annotation class TestListenersAnnotation(
    "The class declarations of [[ceylon.test::TestListener]]s"
    shared {ClassDeclaration+} listeners)
        satisfies OptionalAnnotation<TestListenersAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[ceylon.test::beforeTest]]."
shared final annotation class BeforeTestAnnotation()
        satisfies OptionalAnnotation<BeforeTestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::afterTest]]."
shared final annotation class AfterTestAnnotation()
        satisfies OptionalAnnotation<AfterTestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::ignore]]."
shared final annotation class IgnoreAnnotation(
    "Reason why the test is ignored."
    shared String reason)
        satisfies OptionalAnnotation<IgnoreAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> & TestCondition {
    
    shared actual Result evaluate(TestDescription description) => Result(false, reason);
    
}


"Annotation class for [[ceylon.test::tag]]."
shared final annotation class TagAnnotation(
    "One or more tags associated with the test."
    shared {String+} tags)
        satisfies OptionalAnnotation<TagAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}