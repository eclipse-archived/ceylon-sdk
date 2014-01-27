package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.IntArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;


@Ceylon(major = 6)
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
    Array array){
        if(array.toArray() instanceof int[]){
            return (int[]) array.toArray();
        }
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }

}
