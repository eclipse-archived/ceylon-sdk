"Represents a strategy for creating new instance of test class."
shared interface TestInstanceProvider satisfies TestExtension {
    
    "Returns new instance of test class."
    shared formal Object instance(TestExecutionContext context);
    
}