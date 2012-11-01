package ceylon.interop.java;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 3)
@Method
public final class createFloatArray_ {

    private createFloatArray_() {}

    @TypeInfo("ceylon.language::Array<ceylon.language::Float>")
    public static float[] createFloatArray(
            @Name("size")
            @TypeInfo("ceylon.language::Integer")
            final long size) {
        return new float[(int)size];
    }
    
}
