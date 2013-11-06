package com.redhat.ceylon.test.eclipse;

import java.io.Serializable;

public class TestEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    public static enum Type {

        TEST_RUN_STARTED,
        TEST_RUN_FINISHED,
        TEST_STARTED,
        TEST_FINISHED

    }

    private Type type;
    private TestElement testElement;

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public TestElement getTestElement() {
        return testElement;
    }

    public void setTestElement(TestElement testElement) {
        this.testElement = testElement;
    }
    
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("TestRunnerEvent");
        builder.append("[");
        builder.append("type=").append(type).append(", ");
        builder.append("testElement=").append(testElement);
        builder.append("]");
        return builder.toString();
    }

}
