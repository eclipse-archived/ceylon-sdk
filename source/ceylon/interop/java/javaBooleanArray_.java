package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.BooleanArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 6)
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
    Array array){
        // simplest is same underlying type
        if(array.toArray() instanceof boolean[]){
            boolean[] src = (boolean[]) array.toArray();
            return src;
        }
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }

}
