package ceylon.interop.java.internal;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;
import com.redhat.ceylon.compiler.java.runtime.model.ReifiedType;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

@Ceylon(major = 7) 
@com.redhat.ceylon.compiler.java.metadata.Class
(extendsType="ceylon.language::Object", basic = false, identifiable = false)
public final class Util implements ReifiedType {
    
    @TypeInfo("java.lang::String")
    public java.lang.String javaString(
            @Name("string")
            @TypeInfo("ceylon.language::String")
            final java.lang.String string) {
        return string;
    }
    
    @SuppressWarnings("unchecked")
    @TypeParameters(@TypeParameter("T"))
    @TypeInfo("java.lang::Class<T>")
    public <T> java.lang.Class<T> 
    javaClass(@Ignore final TypeDescriptor $reifiedT) {
        if ($reifiedT instanceof TypeDescriptor.Class) {
            TypeDescriptor.Class klass = (TypeDescriptor.Class) $reifiedT;
            if (klass.getTypeArguments().length > 0)
                throw new RuntimeException("given type has type arguments");
            return (java.lang.Class<T>) klass.getKlass();
        }
        throw new RuntimeException("unsupported type");
    }

    @SuppressWarnings("unchecked")
    @TypeParameters(@TypeParameter(value="T", 
            satisfies="ceylon.language::Object"))
    @TypeInfo("java.lang::Class<out T>")
    public <T> java.lang.Class<? extends T> 
    javaClassFromInstance(@Ignore final TypeDescriptor $reifiedT,
            @Name("instance") @TypeInfo("T")
            T instance) {
        return (Class<? extends T>) instance.getClass();
    }
    
    @Override @Ignore
    public TypeDescriptor $getType$() {
        return TypeDescriptor.klass(Util.class);
    }

}
