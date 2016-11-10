package ceylon.interop.persistence;

import ceylon.language.meta.model.Class;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

import javax.persistence.EntityGraph;
import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.TypedQuery;
import java.util.List;
import java.util.Map;
import ceylon.interop.java.internal.Util;
import com.redhat.ceylon.compiler.java.runtime.metamodel.decl.ClassOrInterfaceDeclarationImpl;
import com.redhat.ceylon.compiler.java.runtime.model.TypeDescriptor;

/**
 * Created by gavin on 11/10/16.
 */
public interface CeylonicEntityManager extends EntityManager {

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

    <T> T find(@TypeInfo("ceylon.language.meta.model::Class<T>") Class entityClass, Object primaryKey);


    <T> T find(@TypeInfo("ceylon.language.meta.model::Class<T>") Class entityClass, Object primaryKey, Map<String, Object> properties);


    <T> T find(@TypeInfo("ceylon.language.meta.model::Class<T>") Class entityClass, Object primaryKey, LockModeType lockMode);


    <T> T find(@TypeInfo("ceylon.language.meta.model::Class<T>") Class entityClass, Object primaryKey, LockModeType lockMode, Map<String, Object> properties);

    <T> T getReference(@TypeInfo("ceylon.language.meta.model::Class<T>") Class entityClass, Object primaryKey);

    <T> TypedQuery<T> createQuery(String qlString, @TypeInfo("ceylon.language.meta.model::Class<T>") Class resultClass);

    <T> TypedQuery<T> createNamedQuery(String name, @TypeInfo("ceylon.language.meta.model::Class<T>") Class resultClass);

    <T> EntityGraph<T> createEntityGraph(@TypeInfo("ceylon.language.meta.model::Class<T>") Class rootType);

    <T> List<EntityGraph<? super T>> getEntityGraphs(@TypeInfo("ceylon.language.meta.model::Class<T>") Class entityClass);
}
