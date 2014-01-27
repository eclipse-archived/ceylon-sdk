package ceylon.interop.java;

import ceylon.language.Array;
import ceylon.language.AssertionException;
import ceylon.language.SharedAnnotation$annotation$;

import com.redhat.ceylon.compiler.java.language.ObjectArray;
import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 6)
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
        throw new AssertionException("Invalid source array type: "+array.toArray());
    }
    
}
