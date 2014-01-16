package ceylon.interop.java;

import ceylon.language.DocAnnotation$annotation$;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor.Class;

@Ceylon(major = 6)
@Method
@DocAnnotation$annotation$(description = "Returns a Java [[java.lang::Class]] object representing the given [[type argument|T]].")
@SharedAnnotation$annotation$
@Annotations({@Annotation(value = "doc", arguments = {"Returns a Java [[java.lang::Class]] object representing the given [[type argument|T]]."}), @Annotation("shared")})
public final class javaClass_ {

    private javaClass_() {}

    public static <T> java.lang.Class<T> javaClass(@Ignore TypeDescriptor $reifiedT) {
        if($reifiedT instanceof TypeDescriptor.Class){
            TypeDescriptor.Class klass = (Class) $reifiedT;
            if(klass.getTypeArguments().length > 0)
                throw new RuntimeException("Type has type arguments");
            return (java.lang.Class<T>) klass.getKlass();
        }
        throw new RuntimeException("Unsupported type");
    }
}
