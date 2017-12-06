package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.FloatArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;


@Ceylon(major = 8)
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
        throw new AssertionError("Invalid source array type: "+array.toArray());
    }
    
}
