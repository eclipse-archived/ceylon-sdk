import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration
}

"Marks an element as being a test. Only `shared` nullary functions 
 and classes should be annotated with `test`."
shared annotation Test test() => Test();

"Marks an element which should be run before each test in its scope.
 Only `shared` nullary functions and classes should be 
 annotated with `beforeTest`."
shared annotation BeforeTest beforeTest() => BeforeTest();

"Marks a function which will be run after each test in its scope.
 Only `shared` nullary functions and classes should be 
 annotated with `afterTest`."
shared annotation AfterTest afterTest() => AfterTest();

"Marks a test or group of tests which should not be executed."
shared annotation Ignore ignore("Reason why the test is ignored." String reason = "") 
        => Ignore(reason);

"Annotation class for [[test]]."
shared final annotation class Test() satisfies OptionalAnnotation<Test, FunctionDeclaration> {}

"Annotation class for [[beforeTest]]."
shared final annotation class BeforeTest() satisfies OptionalAnnotation<BeforeTest, FunctionDeclaration> {}

"Annotation class for [[afterTest]]."
shared final annotation class AfterTest() satisfies OptionalAnnotation<AfterTest, FunctionDeclaration> {}

"Annotation class for [[ignore]]."
shared final annotation class Ignore("Reason why the test is ignored." shared String reason) satisfies OptionalAnnotation<Ignore, FunctionDeclaration|ClassDeclaration> {}