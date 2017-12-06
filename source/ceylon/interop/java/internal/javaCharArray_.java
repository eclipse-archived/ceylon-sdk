package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.CharArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;

@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaCharArray_ {
	
    @Ignore
    private javaCharArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;java.lang.Character&gt;</code> to a Java 
     * <code>CharArray</code>, that is, to <code>char[]</code>, preserving 
     * the identity of the given array. 
     * 
     * @see CharArray
     */
    public static char[] javaCharArray(@Name("array") Array<java.lang.Character> array){
        if(array.toArray() instanceof char[]){
            return (char[]) array.toArray();
        }
        throw new AssertionError("Invalid source array type: "+array.toArray());
    }

}
