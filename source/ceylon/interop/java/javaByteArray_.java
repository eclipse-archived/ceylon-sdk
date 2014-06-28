package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.ByteArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;

@Ceylon(major = 7)
@Method
@SharedAnnotation$annotation$
public final class javaByteArray_ {
        
    @Ignore
    private javaByteArray_() {}

    /**
     * Cast a Ceylon <code>Array&lt;java.lang.Byte&gt;</code> to a Java 
     * <code>ByteArray</code>, that is, to <code>byte[]</code>, preserving 
     * the identity of the given array.
     * 
     * @see ByteArray
     */
    public static byte[] javaByteArray(@Name("array") Array<java.lang.Byte> array){
        if(array.toArray() instanceof byte[]){
            return (byte[]) array.toArray();
        }
        throw new AssertionError("Invalid source array type: "+array.toArray());
    }

}
