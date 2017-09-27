package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.DoubleArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;


@Ceylon(major = 8)
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
    Object array){
        @SuppressWarnings("rawtypes")
        Object a = ((Array) array).toArray();
        if(a instanceof double[]){
            return (double[]) a;
        }
        throw new AssertionError("Invalid source array type: "+a);
    }

}
