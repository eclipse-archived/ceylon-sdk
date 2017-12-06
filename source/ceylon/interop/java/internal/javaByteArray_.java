package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.ByteArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaByteArray_ {
        
    @Ignore
    private javaByteArray_() {}

    /**
     * Cast a Ceylon <code>Array&lt;ceylon.language.Byte&gt;</code> 
     * or <code>Array&lt;java.lang.Byte&gt;</code> to a Java 
     * <code>ByteArray</code>, that is, to <code>byte[]</code>, 
     * preserving the identity of the given array.
     * 
     * @see ByteArray
     */
    public static byte[] javaByteArray(@Name("array") 
    @TypeInfo("ceylon.language::Array<ceylon.language::Byte>|ceylon.language::Array<java.lang::Byte>") 
    Object array){
        @SuppressWarnings("rawtypes")
        Object a = ((Array) array).toArray();
        if (a instanceof byte[]){
            return (byte[]) a;
        }
        throw new AssertionError("Invalid source array type: "+a);
    }

}
