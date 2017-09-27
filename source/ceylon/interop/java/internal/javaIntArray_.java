package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.IntArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;


@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaIntArray_ {
        
    @Ignore
    private javaIntArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;Character&gt;</code> or
     * <code>Array&lt;java.lang.Integer&gt;</code> to a Java 
     * <code>IntArray</code>, that is, to <code>int[]</code>, 
     * preserving the identity of the given array.
     * 
     * @see IntArray
     */
    public static int[] javaIntArray(@Name("array") 
    @TypeInfo("ceylon.language::Array<ceylon.language::Character>|ceylon.language::Array<java.lang::Integer>") 
    Object array){
        @SuppressWarnings("rawtypes")
        Object a = ((Array) array).toArray();
        if(a instanceof int[]){
            return (int[]) a;
        }
        throw new AssertionError("Invalid source array type: "+a);
    }

}
