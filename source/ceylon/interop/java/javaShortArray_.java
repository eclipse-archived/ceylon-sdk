package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.ShortArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;

@Ceylon(major = 6)
@Method
@SharedAnnotation$annotation$
public final class javaShortArray_ {
        
    @Ignore
    private javaShortArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;java.lang.Short&gt;</code> 
     * to a Java <code>ShortArray</code>, that is, to <code>short[]</code>, 
     * preserving the identity of the given array.
     * 
     * @see ShortArray
     */
    public static short[] javaShortArray(@Name("array") Array<java.lang.Short> array){
        if(array.toArray() instanceof short[]){
            return (short[]) array.toArray();
        }
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }

}
