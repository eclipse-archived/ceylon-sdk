package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.FloatArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;


@Ceylon(major = 6)
@Method
@SharedAnnotation$annotation$
public final class javaFloatArray_ {
        
    @Ignore
    private javaFloatArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;java.lang.Float&gt;</code> 
     * to a Java <code>FloatArray</code>, that is, to <code>float[]</code>, 
     * preserving the identity of the given array. 
     * 
     * @see FloatArray
     */
    public static float[] javaFloatArray(@Name("array") Array<java.lang.Float> array){
        if(array.toArray() instanceof float[]){
            return (float[]) array.toArray();
        }
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }
    
}
