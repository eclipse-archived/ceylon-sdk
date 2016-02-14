import ceylon.test {
    TestDescription
}

"Represents a strategy how to resolve test extension."
shared interface TestExtensionResolver {
    
    "Returns test extensions."
    shared formal {TestExtensionType*} resolveExtensions<TestExtensionType>(TestDescription description) 
            given TestExtensionType satisfies TestExtension;
    
}