package ceylon.interop.java;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 4)
@Method
public final class createBooleanArray_ {

    private createBooleanArray_() {}

    @TypeInfo("ceylon.language::Array<ceylon.language::Boolean>")
    public static boolean[] createBooleanArray(
            @Name("size")
            @TypeInfo("ceylon.language::Integer")
            final long size) {
        return new boolean[(int)size];
    }
    
}
