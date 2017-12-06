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

@Ceylon(major = 8)
@Method
@SharedAnnotation$annotation$
public final class javaStringArray_ {
        
    @Ignore
    private javaStringArray_() {}
    
    /**
     * Cast a Ceylon <code>Array&lt;String&gt;</code> to a Java 
     * <code>ObjectArray&lt;java.lang.String&gt;</code>, that is, 
     * to <code>java.lang.String[]</code>, preserving the identity 
     * of the given array.
     * 
     * @see ObjectArray
     */
    public static java.lang.String[] javaStringArray(@Name("array") 
    @TypeInfo("ceylon.language::Array<ceylon.language::String>") 
    Array<ceylon.language.String> array){
        if(array.toArray() instanceof java.lang.String[]){
            return (java.lang.String[]) array.toArray();
        }
        throw new AssertionError("Invalid source array type: "+array.toArray());
    }
    
}
