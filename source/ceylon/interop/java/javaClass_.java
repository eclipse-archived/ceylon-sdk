package ceylon.interop.java;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor.Class;

@Ceylon(major = 5)
@Method
public final class javaClass_ {

    private javaClass_() {}

    public static <T> java.lang.Class<T> javaClass(@Ignore TypeDescriptor $reifiedT) {
        if($reifiedT instanceof TypeDescriptor.Class){
            TypeDescriptor.Class klass = (Class) $reifiedT;
            if(klass.getTypeArguments().length > 0)
                throw new RuntimeException("Type has type arguments");
            return (java.lang.Class<T>) klass.getKlass();
        }
        throw new RuntimeException("Unsupported type");
    }
}
