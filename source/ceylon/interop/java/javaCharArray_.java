package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.CharArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;

@Ceylon(major = 6)
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
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }

}
