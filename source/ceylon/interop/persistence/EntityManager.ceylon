import ceylon.interop.java {
    javaClassFromModel,
    JavaMap,
    JavaStringMap,
    CeylonStringMap,
    CeylonMap,
    CeylonList
}
import ceylon.interop.persistence {
    Util {
        javaClass
    }
}
import ceylon.language.meta.model {
    Class
}

import javax.persistence {
    JEntityManager=EntityManager,
    LockModeType,
    FlushModeType,
    EntityTransaction,
    EntityGraph,
    StoredProcedureQuery
}
import javax.persistence.criteria {
    CriteriaQuery,
    CriteriaUpdate,
    CriteriaDelete,
    CriteriaBuilder
}
import javax.persistence.metamodel {
    Metamodel
}

shared alias Properties => Map<String,Object>;

shared class EntityManager(entityManager)
        satisfies Category<> {

    shared JEntityManager entityManager;

    shared Boolean open => entityManager.open;

    shared void close() => entityManager.close();

    shared actual Boolean contains(Object entity)
            => entityManager.contains(entity);

    shared void clear() => entityManager.clear();

    shared variable FlushModeType flushMode = entityManager.flushMode;

    shared void flush() => entityManager.flush();

    shared EntityTransaction transaction => entityManager.transaction;

    shared void joinTransaction() => entityManager.joinTransaction();

    shared Boolean joinedToTransaction => entityManager.joinedToTransaction;

    shared Metamodel metamodel => entityManager.metamodel;

    shared Properties properties
            => CeylonStringMap(CeylonMap(entityManager.properties));

    shared void setProperty(String propertyName, Object propertyValue)
            => entityManager.setProperty(propertyName, toJava(propertyValue));

    shared Query createQuery(String query)
            => Query(entityManager.createQuery(query));

    shared TypedQuery<Result> createTypedQuery<Result>(String query,
        Class<Result> resultClass)
            given Result satisfies Object
            => TypedQuery(entityManager.createQuery(query,
                    javaClass(resultClass)));

    shared Query createNamedQuery(String name)
            => Query(entityManager.createNamedQuery(name));

    shared TypedQuery<Result> createNamedTypedQuery<Result>(String name,
        Class<Result> resultClass)
            given Result satisfies Object
            => TypedQuery(entityManager.createNamedQuery(name,
                    javaClass(resultClass)));

    shared Query createNativeQuery(String sqlQuery)
            => Query(entityManager.createNativeQuery(sqlQuery));

    shared Query createNativeMappedQuery(String sqlQuery, String resultSetMapping)
            => Query(entityManager.createNativeQuery(sqlQuery, resultSetMapping));

    shared TypedQuery<Result> createNativeTypedQuery<Result>(String sqlQuery,
        Class<Result> resultClass)
            given Result satisfies Object
            => TypedQuery.withResultClass(resultClass,
                    entityManager.createNativeQuery(sqlQuery,
                    javaClass(resultClass)));

    shared CriteriaBuilder criteriaBuilder => entityManager.criteriaBuilder;

    shared TypedQuery<Result> createCriteriaQuery<Result>(
        CriteriaQuery<Result> criteriaQuery)
            given Result satisfies Object
            => TypedQuery(entityManager.createQuery(criteriaQuery));

    shared Query createUpdateQuery(CriteriaUpdate<out Object> updateQuery)
            => Query(entityManager.createQuery(updateQuery));

    shared Query createDeleteQuery(CriteriaDelete<out Object> deleteQuery)
            => Query(entityManager.createQuery(deleteQuery));

    //TODO: wrapper for StoredProcedureQuery!!!!

    shared StoredProcedureQuery createNamedStoredProcedureQuery(String name)
            => entityManager.createNamedStoredProcedureQuery(name);

    shared StoredProcedureQuery createStoredProcedureMappedQuery(
        String procedureName, String* resultSetMappings)
            => entityManager.createStoredProcedureQuery(procedureName,
                    *resultSetMappings);

    shared StoredProcedureQuery createStoredProcedureQuery(
        String procedureName, Class<Object>* resultClasses)
            => entityManager.createStoredProcedureQuery(procedureName,
                    for (rc in resultClasses)
                    javaClassFromModel(rc));

    shared Entity find<Entity>(Class<Entity> entityClass, Object primaryKey,
                LockModeType lockMode = LockModeType.none,
                Properties properties = emptyMap)
            given Entity satisfies Object
            => entityManager.find(javaClass(entityClass), toJava(primaryKey),
                    lockMode, JavaMap(JavaStringMap(properties)));

    shared Entity getReference<Entity>(Class<Entity> entityClass, Object primaryKey)
            given Entity satisfies Object
            => entityManager.getReference(javaClass(entityClass), toJava(primaryKey));

    shared void detach(Object entity) => entityManager.detach(entity);

    shared void persist(Object entity) => entityManager.persist(entity);

    shared Entity merge<Entity>(Entity entity)
            given Entity satisfies Object
            => entityManager.merge(entity);

    shared void remove(Object entity) => entityManager.remove(entity);

    shared void refresh(Object entity,
                LockModeType lockMode = LockModeType.none,
                Properties properties = emptyMap)
            => entityManager.refresh(entity, lockMode,
                    JavaMap(JavaStringMap(properties)));

    shared void lock(Object entity,
                LockModeType lockMode,
                Properties properties = emptyMap)
            => entityManager.lock(entity, lockMode,
                    JavaMap(JavaStringMap(properties)));

    shared LockModeType getLockMode(Object entity)
            => entityManager.getLockMode(entity);

    shared EntityGraph<out Object> getEntityGraph(String graphName)
            => entityManager.getEntityGraph(graphName);

    shared List<EntityGraph<in Entity>> getEntityGraphs<Entity>(Class<Entity> entityClass)
            given Entity satisfies Object
            => CeylonList(entityManager.getEntityGraphs(javaClass(entityClass)));

    shared EntityGraph<Entity> createEntityGraph<Entity>(Class<Entity> rootType)
            given Entity satisfies Object
            => entityManager.createEntityGraph(javaClass(rootType));

    shared EntityGraph<out Object> createNamedEntityGraph(String graphName)
            => entityManager.createEntityGraph(graphName);

}

