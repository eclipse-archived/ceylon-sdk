package ceylon.interop.java;

import ceylon.language.DocAnnotation$annotation$;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 7)
@Method
@DocAnnotation$annotation$(description = "Returns a Java [[java.lang::Class]] object representing the given [[type argument|T]].")
@SharedAnnotation$annotation$
@Annotations({@Annotation(value = "doc", 
                  arguments = {"Returns a Java [[java.lang::Class]] object representing the given [[type argument|T]]."}), 
              @Annotation("shared")})
public final class javaClass_ {

    private javaClass_() {}

    @TypeInfo("java.lang::Class<out ceylon.language::Object>")
    public static <T> java.lang.Class<?> javaClass(@Ignore TypeDescriptor $reifiedT) {
        if ($reifiedT instanceof TypeDescriptor.Class){
            TypeDescriptor.Class klass = (TypeDescriptor.Class) $reifiedT;
            if (klass.getTypeArguments().length > 0)
                throw new RuntimeException("Type has type arguments");
            return klass.getKlass();
        }
        throw new RuntimeException("Unsupported type");
    }
}
