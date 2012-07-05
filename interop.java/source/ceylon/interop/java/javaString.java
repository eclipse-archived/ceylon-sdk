package ceylon.interop.java;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 2)
@Method
public final class javaString {

    private javaString() {}

    @TypeInfo("java.lang.String")
    public static java.lang.String javaString(
    @Name("string")
    @TypeInfo("ceylon.language.String")
    final java.lang.String string) {
        return string;
    }
    
}
