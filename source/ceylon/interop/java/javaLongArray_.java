package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.LongArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 6)
@Method
@SharedAnnotation$annotation$
public final class javaLongArray_ {
        
    @Ignore
    private javaLongArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;Integer&gt;</code> or
     * <code>Array&lt;java.lang.Long&gt;</code> to a Java 
     * <code>LongArray</code>, that is, to <code>long[]</code>, 
     * preserving the identity of the given array.
     * 
     * @see LongArray
     */
    public static long[] javaLongArray(@Name("array")
    @TypeInfo("ceylon.language::Array<ceylon.language::Integer>|ceylon.language::Array<java.lang::Long>") 
    Array array){
        if(array.toArray() instanceof long[]){
            return (long[]) array.toArray();
        }
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }

}
