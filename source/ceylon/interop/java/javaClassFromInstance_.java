package ceylon.interop.java;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 5)
@Method
public final class javaClassFromInstance_ {

    private javaClassFromInstance_() {}

    public static <T> java.lang.Class<T> javaClassFromInstance(
            @Ignore TypeDescriptor $reifiedT, 
            @Name("instance") @TypeInfo("ceylon.language::Object") T instance) {
        return (java.lang.Class<T>) instance.getClass();
    }
}