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
@DocAnnotation$annotation$(description = javaClassFromInstance_.DOC)
@SharedAnnotation$annotation$
@Annotations({@Annotation(value = "doc", arguments = {javaClassFromInstance_.DOC}), @Annotation("shared")})
public final class javaClassFromInstance_ {
	
	@Ignore
	protected static final String DOC = "Returns a Java [[java.lang::Class]] object representing the runtime type of the given [[instance]].";

    private javaClassFromInstance_() {}

    public static <T> java.lang.Class<T> javaClassFromInstance(
            @Ignore TypeDescriptor $reifiedT, 
            @Name("instance") @TypeInfo("ceylon.language::Object") T instance) {
        //NOTE: this looks like an unsound cast, but in fact
        //      since java.lang.Class is actually covariant,
        //      and since Java generics aren't reified, it's
        //      acceptable.
        return (java.lang.Class<T>) instance.getClass();
    }
}
