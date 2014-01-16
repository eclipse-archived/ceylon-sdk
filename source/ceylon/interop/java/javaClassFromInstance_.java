package ceylon.interop.java;

import ceylon.language.DocAnnotation$annotation$;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 6)
@Method
@DocAnnotation$annotation$(description = "Returns a Java [[java.lang::Class]] object representing the runtime type of the given [[instance]].")
@SharedAnnotation$annotation$
@Annotations({@Annotation(value = "doc", arguments = {"Returns a Java [[java.lang::Class]] object representing the runtime type of the given [[instance]]."}), @Annotation("shared")})
public final class javaClassFromInstance_ {

    private javaClassFromInstance_() {}

    public static <T> java.lang.Class<T> javaClassFromInstance(
            @Ignore TypeDescriptor $reifiedT, 
            @Name("instance") @TypeInfo("ceylon.language::Object") T instance) {
        return (java.lang.Class<T>) instance.getClass();
    }
}
