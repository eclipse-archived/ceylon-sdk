package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.BooleanArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaBooleanArray_ {
	
    @Ignore
    private javaBooleanArray_() {}

    /**
     * Cast a Ceylon <code>Array&lt;Boolean&gt;</code> or 
     * <code>Array&lt;java.lang.Boolean&gt;</code> to a Java 
     * <code>BooleanArray</code>, that is, to <code>boolean[]</code>, 
     * preserving the identity of the given array. 
     * 
     * @see BooleanArray
     */
    public static boolean[] javaBooleanArray(@Name("array")
    @TypeInfo("ceylon.language::Array<ceylon.language::Boolean>|ceylon.language::Array<java.lang::Boolean>")
    Object array){
        @SuppressWarnings("rawtypes")
        Object a = ((Array) array).toArray();
        if(a instanceof boolean[]){
            return (boolean[]) a;
        }
        throw new AssertionError("Invalid source array type: "+ a);
    }

}
