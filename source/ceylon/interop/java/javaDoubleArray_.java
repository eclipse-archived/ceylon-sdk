package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.DoubleArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;


@Ceylon(major = 6)
@Method
@SharedAnnotation$annotation$
public final class javaDoubleArray_ {
        
    @Ignore
    private javaDoubleArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;Float&gt;</code> or
     * <code>Array&lt;java.lang.Double&gt;</code> to a Java 
     * <code>DoubleArray</code>, that is, to <code>double[]</code>, 
     * preserving the identity of the given array.
     * 
     * @see DoubleArray
     */
    public static double[] javaDoubleArray(@Name("array") 
    @TypeInfo("ceylon.language::Array<ceylon.language::Float>|ceylon.language::Array<java.lang::Double>") 
    Array array){
        if(array.toArray() instanceof double[]){
            return (double[]) array.toArray();
        }
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }

}
