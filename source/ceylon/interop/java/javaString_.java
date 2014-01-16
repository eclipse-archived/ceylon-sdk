package ceylon.interop.java;

import ceylon.language.DocAnnotation$annotation$;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 6)
@Method
@DocAnnotation$annotation$(description = "Cast the given Ceylon [[String]] to a Java [[java.lang::String]] without losing the identity of the original string.")
@SharedAnnotation$annotation$
@Annotations({@Annotation(value = "doc", arguments = {"Cast the given Ceylon [[String]] to a Java [[java.lang::String]] without losing the identity of the original string."}), @Annotation("shared")})
public final class javaString_ {

    private javaString_() {}

    @TypeInfo("java.lang::String")
    public static java.lang.String javaString(
            @Name("string")
            @TypeInfo("ceylon.language::String")
            final java.lang.String string) {
        return string;
    }
    
}
