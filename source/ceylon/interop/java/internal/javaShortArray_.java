package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.ShortArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;

@Ceylon(major = 8)
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
        throw new AssertionError("Invalid source array type: "+array.toArray());
    }

}
