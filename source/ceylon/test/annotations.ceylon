import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration
}

"Annotation to mark function like a test."
shared annotation Test test() => Test();

"Annotation to mark function which will be run before each tests in its scope."
shared annotation BeforeTest beforeTest() => BeforeTest();

"Annotation to mark function which will be run after each tests in its scope."
shared annotation AfterTest afterTest() => AfterTest();

"Annotation to mark test or group of tests like ignored."
shared annotation Ignore ignore("Reason why the test is ignored." String reason = "") => Ignore(reason);

"Annotation class for [[test]]."
shared final annotation class Test() satisfies OptionalAnnotation<Test, FunctionDeclaration> {}

"Annotation class for [[beforeTest]]."
shared final annotation class BeforeTest() satisfies OptionalAnnotation<BeforeTest, FunctionDeclaration> {}

"Annotation class for [[afterTest]]."
shared final annotation class AfterTest() satisfies OptionalAnnotation<AfterTest, FunctionDeclaration> {}

"Annotation class for [[ignore]]."
shared final annotation class Ignore("Reason why the test is ignored." shared String reason) satisfies OptionalAnnotation<Ignore, FunctionDeclaration|ClassDeclaration> {}