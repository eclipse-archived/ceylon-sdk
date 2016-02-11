"Represents a strategy for post-processing test instances."
shared interface TestInstancePostProcessor satisfies TestExtension {
    
    "Post-process given test instance."
    shared formal void postProcessInstance(TestExecutionContext context, Object instance);
    
}