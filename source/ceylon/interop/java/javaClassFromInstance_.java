package ceylon.interop.java;

import ceylon.language.Doc$annotation;
import ceylon.language.Shared$annotation;

import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 5)
@Method
@Doc$annotation(description = "Takes a class instance and returns a Java `Class` reference for its type")
@Shared$annotation
@Annotations({@Annotation(value = "doc", arguments = {"Takes a class instance and returns a Java `Class` reference for its type"}), @Annotation("shared")})
public final class javaClassFromInstance_ {

    private javaClassFromInstance_() {}

    public static <T> java.lang.Class<T> javaClassFromInstance(
            @Ignore TypeDescriptor $reifiedT, 
            @Name("instance") @TypeInfo("ceylon.language::Object") T instance) {
        return (java.lang.Class<T>) instance.getClass();
    }
}