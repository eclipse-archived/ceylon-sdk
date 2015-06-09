package ceylon.interop.java.internal;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 8) 
@com.redhat.ceylon.compiler.java.metadata.Class
public final class Util {

    @TypeInfo("java.lang::String")
    public java.lang.String javaString(
            @Name("string")
            @TypeInfo("ceylon.language::String")
            final java.lang.String string) {
        return string;
    }
    
    @SuppressWarnings("unchecked")
    public <T> java.lang.Class<? extends T> 
    javaClassFromInstance(@Ignore TypeDescriptor $reifiedT,
            @Name("instance")
            T instance) {
        return (Class<? extends T>) instance.getClass();
    }
    
    @SuppressWarnings("unchecked")
    public <T> java.lang.Class<T> 
    javaClass(@Ignore TypeDescriptor $reifiedT) {
        if ($reifiedT instanceof TypeDescriptor.Class){
            TypeDescriptor.Class klass = (TypeDescriptor.Class) $reifiedT;
            if (klass.getTypeArguments().length > 0)
                throw new RuntimeException("given type has type arguments");
            return (java.lang.Class<T>) klass.getKlass();
        } 
        else if($reifiedT instanceof TypeDescriptor.Member 
                && ((TypeDescriptor.Member)$reifiedT).getMember() instanceof TypeDescriptor.Class) {
            TypeDescriptor.Member.Class klass =  (TypeDescriptor.Class)((TypeDescriptor.Member)$reifiedT).getMember();
            if (klass.getTypeArguments().length > 0)
                throw new RuntimeException("given type has type arguments");
            return (java.lang.Class<T>) klass.getKlass();
        }
        throw new RuntimeException("unsupported type");
    }

}
