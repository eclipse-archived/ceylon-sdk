package ceylon.interop.persistence;

import ceylon.language.meta.model.Class;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.runtime.metamodel.decl.ClassOrInterfaceDeclarationImpl;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

import javax.persistence.TypedQuery;

public class Util {

    //TODO: use javaClassFromModel(entity) when #6682 is fixed
    static <Type> java.lang.Class<Type> javaClass(@TypeInfo("ceylon.language.meta.model::Class<Type>") Class type) {
        return (java.lang.Class<Type>)
                ((ClassOrInterfaceDeclarationImpl) type.getDeclaration())
                        .getJavaClass();
    }

    //TODO: add a createWithJavaClass() function to ceylon.interop.java
    @TypeInfo("ceylon.interop.persistence::TypedQuery<Type>")
    static <Type> ceylon.interop.persistence.TypedQuery<Type> newTypedQuery(java.lang.Class<Type> type,
                                                                            TypedQuery<Type> query) {
        return new ceylon.interop.persistence.TypedQuery<Type>(TypeDescriptor.klass(type), query);
    }

}
