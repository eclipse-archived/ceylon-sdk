package ceylon.interop.java.internal;

import ceylon.language.DocAnnotation$annotation$;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 7)
@Method
@DocAnnotation$annotation$(description = "Returns a Java [[java.lang::Class]] object representing the runtime type of the given [[instance]].")
@SharedAnnotation$annotation$
@Annotations({@Annotation(value = "doc", 
                  arguments = {"Returns a Java [[java.lang::Class]] object representing the runtime type of the given [[instance]]."}), 
              @Annotation("shared")})
public final class javaClassFromInstance_ {

    private javaClassFromInstance_() {}
    
    @TypeInfo("java.lang::Class<out ceylon.language::Object>") 
    public static java.lang.Class<?> javaClassFromInstance(
            @Name("instance") 
            @TypeInfo("ceylon.language::Object") 
            java.lang.Object instance) {
        return instance.getClass();
    }
}
