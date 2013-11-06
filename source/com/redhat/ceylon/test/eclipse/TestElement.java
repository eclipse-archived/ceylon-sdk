package com.redhat.ceylon.test.eclipse;

import java.io.Serializable;

public class TestElement implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum State {

        UNDEFINED,
        RUNNING,
        SUCCESS,
        FAILURE,
        ERROR,
        IGNORED;

        public boolean isFinished() {
            return this == SUCCESS || this == FAILURE || this == ERROR || this == IGNORED;
        }

        public boolean isFailureOrError() {
            return this == FAILURE || this == ERROR;
        }

    }

    private String shortName;
    private String packageName;
    private String qualifiedName;
    private State state;
    private String exception;
    private String expectedValue;
    private String actualValue;
    private long elapsedTimeInMilis;
    private TestElement[] children;

    public String getShortName() {
        return shortName;
    }

    public String getPackageName() {
        return packageName;
    }

    public String getQualifiedName() {
        return qualifiedName;
    }

    public void setQualifiedName(String qualifiedName) {
        this.qualifiedName = qualifiedName;

        int packageSeparatorIndex = qualifiedName.indexOf("::");
        if (packageSeparatorIndex != -1) {
            String tmp = qualifiedName.substring(packageSeparatorIndex + 2);
            int memberSeparatorIndex = tmp.lastIndexOf(".");
            if (memberSeparatorIndex != -1) {
                shortName = tmp.substring(memberSeparatorIndex + 1);
            } else {
                shortName = tmp;
            }
            packageName = qualifiedName.substring(0, packageSeparatorIndex);
        } else {
            shortName = qualifiedName;
            packageName = "";
        }
    }

    public State getState() {
        return state;
    }

    public void setState(State state) {
        this.state = state;
    }

    public String getException() {
        return exception;
    }

    public void setException(String exception) {
        this.exception = exception;
    }

    public String getExpectedValue() {
        return expectedValue;
    }

    public void setExpectedValue(String expectedValue) {
        this.expectedValue = expectedValue;
    }

    public String getActualValue() {
        return actualValue;
    }

    public void setActualValue(String actualValue) {
        this.actualValue = actualValue;
    }

    public long getElapsedTimeInMilis() {
        return elapsedTimeInMilis;
    }

    public void setElapsedTimeInMilis(long elapsedTimeInMilis) {
        this.elapsedTimeInMilis = elapsedTimeInMilis;
    }
    
    public TestElement[] getChildren() {
        return children;
    }
    
    public void setChildren(TestElement[] children) {
        this.children = children;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (qualifiedName != null && obj instanceof TestElement) {
            return qualifiedName.equals(((TestElement) obj).qualifiedName);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return qualifiedName != null ? qualifiedName.hashCode() : 0;
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("TestElement");
        builder.append("[");
        builder.append("name=").append(qualifiedName).append(", ");
        builder.append("state=").append(state);
        builder.append("]");
        return builder.toString();
    }

}