package ceylon.interop.java.internal;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.metamodel.decl.ClassOrInterfaceDeclarationImpl;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

import ceylon.language.meta.declaration.ClassOrInterfaceDeclaration;
import ceylon.language.meta.model.ClassOrInterface;

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
        if ($reifiedT instanceof TypeDescriptor.Class) {
            TypeDescriptor.Class klass = 
                    (TypeDescriptor.Class) $reifiedT;
            if (klass.getTypeArguments().length > 0)
                throw new RuntimeException("given type has type arguments");
            // this is already erased
            return (java.lang.Class<T>) klass.getArrayElementClass();
        } 
        else if ($reifiedT instanceof TypeDescriptor.Member) {
            TypeDescriptor.Member member = 
                    (TypeDescriptor.Member) $reifiedT;
            TypeDescriptor m = member.getMember();
            if (m instanceof TypeDescriptor.Class) {
                TypeDescriptor.Member.Class klass = 
                        (TypeDescriptor.Class) m;
                if (klass.getTypeArguments().length > 0)
                    throw new RuntimeException("given type has type arguments");
                return (java.lang.Class<T>) klass.getKlass();
            }
        }
        throw new ceylon.language.AssertionError("unsupported type");
    }
    
    @SuppressWarnings("unchecked")
    public <T extends java.lang.annotation.Annotation> Class<T>
    javaAnnotationClass(@Ignore TypeDescriptor $reifiedT) {
        if ($reifiedT instanceof TypeDescriptor.Class) {
            TypeDescriptor.Class klass = 
                    (TypeDescriptor.Class) $reifiedT;
            if (klass.getTypeArguments().length > 0)
                throw new RuntimeException("given type has type arguments");
            try {
                Class<?> c = klass.getKlass();
                String name = c.getName() + "$annotation$";
                return (Class<T>) 
                        Class.forName(name, true, c.getClassLoader());
            }
            catch (ClassNotFoundException e) {}
        } 
        throw new ceylon.language.AssertionError("unsupported type");
    }

    public java.lang.Class<? extends java.lang.Object> 
    javaClassForDeclaration(ClassOrInterfaceDeclaration decl) {
    	if(decl instanceof ClassOrInterfaceDeclarationImpl){
    		ClassOrInterfaceDeclarationImpl ci = 
    		        (ClassOrInterfaceDeclarationImpl) decl;
            return erase(ci.getJavaClass());
    	}
        throw new ceylon.language.AssertionError("Unsupported declaration type: "+decl);
    }

    @SuppressWarnings("unchecked")
	public <T> java.lang.Class<? extends T> 
    javaClassForModel(@Ignore TypeDescriptor $reifiedT,
    		ClassOrInterface<? extends T> model) {
    	ClassOrInterfaceDeclaration decl = model.getDeclaration();
    	if(decl instanceof ClassOrInterfaceDeclarationImpl){
    		ClassOrInterfaceDeclarationImpl ci = 
    				(ClassOrInterfaceDeclarationImpl) decl;
    		return (Class<? extends T>) erase(ci.getJavaClass());
    	}
    	throw new ceylon.language.AssertionError("Unsupported declaration type: "+decl);
    }

    @SuppressWarnings("unchecked")
    private <T> java.lang.Class<? extends T>
    erase(java.lang.Class<? extends T> klass){
      // dirty but keeps the logic in one place
      return (Class<? extends T>)
              TypeDescriptor.klass(klass)
                  .getArrayElementClass();
    }

    public StackTraceElement[] javaStackTrace(Throwable t) {
        return t.getStackTrace();
    }
    
}
