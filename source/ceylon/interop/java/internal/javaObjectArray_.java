package ceylon.interop.java.internal;

import ceylon.language.Array;
import ceylon.language.AssertionError;
import ceylon.language.SharedAnnotation$annotation$;

import org.eclipse.ceylon.compiler.java.language.ObjectArray;
import org.eclipse.ceylon.compiler.java.metadata.Ceylon;
import org.eclipse.ceylon.compiler.java.metadata.Ignore;
import org.eclipse.ceylon.compiler.java.metadata.Method;
import org.eclipse.ceylon.compiler.java.metadata.Name;
import org.eclipse.ceylon.compiler.java.metadata.TypeInfo;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameter;
import org.eclipse.ceylon.compiler.java.metadata.TypeParameters;
import org.eclipse.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaObjectArray_ {
        
    @Ignore
    private javaObjectArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;T?&gt;</code> to a Java 
     * <code>ObjectArray&lt;T&gt;</code>, that is, to <code>T[]</code>, 
     * preserving the identity of the given array. 
     * 
     * @throws AssertionError if the given array does not 
     *         use a Java object array to store its elements
     * @see ObjectArray
     */
    @SuppressWarnings("unchecked")
    @TypeParameters(@TypeParameter(value="T", satisfies="ceylon.language::Object"))
    public static <T> T[] javaObjectArray(@Ignore TypeDescriptor $reifiedT, 
            @TypeInfo("ceylon.language::Array<T|ceylon.language::Null>") 
            @Name("array") Array<T> array){
        TypeDescriptor t = $reifiedT;
        while (t instanceof TypeDescriptor.Member) {
            t = ((TypeDescriptor.Member) t).getMember();
        }
        if (!(t instanceof TypeDescriptor.Class)) {
            throw new AssertionError("Invalid array element type: " + t.toString());
        }
        Object result = array.toArray();
        if (!(result instanceof java.lang.Object[])) {
            throw new AssertionError("Invalid source array type: " + result);
        }
        return (T[]) result;
    }

}
