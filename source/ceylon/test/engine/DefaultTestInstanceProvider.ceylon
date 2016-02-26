import ceylon.language.meta.model {
    Class
}
import ceylon.test.engine.spi {
    TestInstanceProvider,
    TestExecutionContext
}

"Default implementation of [[TestInstanceProvider]]."
shared class DefaultTestInstanceProvider() satisfies TestInstanceProvider {
    
    shared actual Object instance(TestExecutionContext context) {
        assert (exists c = context.description.classDeclaration);
        if (c.anonymous) {
            assert (exists objectInstance = c.objectValue?.get());
            return objectInstance;
        } else {
            assert (is Class<Object,[]> classModel = c.apply<Object>());
            return classModel();
        }
    }
    
}
