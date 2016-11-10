import ceylon.language.meta.model {
    Class
}

import java.lang {
    JClass=Class,
    JString=String
}
import java.util {
    Map,
    List
}

import javax.persistence {
    JEntityManager=EntityManager,
    LockModeType,
    FlushModeType,
    EntityTransaction,
    EntityGraph,
    StoredProcedureQuery,
    EntityManagerFactory
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

shared alias Properties => Map<JString,Object>;

shared class EntityManager(entityManager)
        satisfies CeylonicEntityManager {

    shared JEntityManager entityManager;

    shared actual Boolean contains(Object entity)
            => entityManager.contains(entity);

    shared actual void clear() => entityManager.clear();

    shared actual void close() => entityManager.close();

    shared actual EntityGraph<Entity> createEntityGraph<Entity>(Class<Entity> rootType)
            given Entity satisfies Object
            => entityManager.createEntityGraph(javaClass(rootType));

    shared actual EntityGraph<Entity> createEntityGraph<Entity>(JClass<Entity> rootType)
            given Entity satisfies Object
            => entityManager.createEntityGraph(rootType);

    shared actual EntityGraph<out Object> createEntityGraph(String graphName)
            => entityManager.createEntityGraph(graphName);

    shared actual Query createNamedQuery(String name)
            => Query(entityManager.createNamedQuery(name));

    shared actual TypedQuery<Result> createNamedQuery<Result>(String name, Class<Result> resultClass)
            given Result satisfies Object
            => newTypedQuery(javaClass(resultClass), entityManager.createNamedQuery(name, javaClass(resultClass)));

    shared actual TypedQuery<Result> createNamedQuery<Result>(String name, JClass<Result> resultClass)
            given Result satisfies Object
            => newTypedQuery(resultClass, entityManager.createNamedQuery(name, resultClass));

    shared actual StoredProcedureQuery createNamedStoredProcedureQuery(String name)
            //TODO: WRAP IT!
            => entityManager.createNamedStoredProcedureQuery(name);

    shared actual Query createNativeQuery(String sqlString)
            => Query(entityManager.createNativeQuery(sqlString));

    shared actual Query createNativeQuery(String sqlString, JClass<out Object> resultClass)
            => Query(entityManager.createNativeQuery(sqlString, resultClass));

    shared actual Query createNativeQuery(String sqlString, String resultSetMapping)
            => Query(entityManager.createNativeQuery(sqlString, resultSetMapping));

    shared actual Query createQuery(String qlString)
            => Query(entityManager.createQuery(qlString));

    shared actual TypedQuery<Result> createQuery<Result>(CriteriaQuery<Result> criteriaQuery)
            given Result satisfies Object
            => newTypedQuery(criteriaQuery.resultType, entityManager.createQuery(criteriaQuery));

    shared actual Query createQuery(CriteriaUpdate<out Object> updateQuery)
            => Query(entityManager.createQuery(updateQuery));

    shared actual Query createQuery(CriteriaDelete<out Object> deleteQuery)
            => Query(entityManager.createQuery(deleteQuery));

    shared actual TypedQuery<Result> createQuery<Result>(String qlString, Class<Result> resultClass)
            given Result satisfies Object
            => newTypedQuery(javaClass(resultClass), entityManager.createQuery(qlString, javaClass(resultClass)));

    shared actual TypedQuery<Result> createQuery<Result>(String qlString, JClass<Result> resultClass)
            given Result satisfies Object
            => newTypedQuery(resultClass, entityManager.createQuery(qlString, resultClass));

    shared actual StoredProcedureQuery createStoredProcedureQuery(String procedureName)
            => entityManager.createStoredProcedureQuery(procedureName);

    shared actual StoredProcedureQuery createStoredProcedureQuery(String procedureName, String?* resultSetMappings)
            => entityManager.createStoredProcedureQuery(procedureName, *resultSetMappings);

    shared actual StoredProcedureQuery createStoredProcedureQuery(String procedureName, JClass<out Object>?* resultClasses)
            => entityManager.createStoredProcedureQuery(procedureName, *resultClasses);

    shared actual CriteriaBuilder criteriaBuilder => entityManager.criteriaBuilder;

    shared actual Object delegate => entityManager.delegate;

    shared actual void detach(Object entity) => entityManager.detach(entity);

    shared actual EntityManagerFactory entityManagerFactory => entityManager.entityManagerFactory;

    shared actual Entity find<Entity>(Class<Entity> entityClass, Object primaryKey)
            given Entity satisfies Object
            => entityManager.find<Entity>(javaClass(entityClass), toJava(primaryKey));

    shared actual Entity find<Entity>(Class<Entity> entityClass, Object primaryKey, Properties properties)
            given Entity satisfies Object
            => entityManager.find<Entity>(javaClass(entityClass), toJava(primaryKey), properties);

    shared actual Entity find<Entity>(Class<Entity> entityClass, Object primaryKey, LockModeType lockMode)
            given Entity satisfies Object
            => entityManager.find<Entity>(javaClass(entityClass), toJava(primaryKey), lockMode);

    shared actual Entity find<Entity>(Class<Entity> entityClass, Object primaryKey, LockModeType lockMode, Properties properties)
            given Entity satisfies Object
            => entityManager.find<Entity>(javaClass(entityClass), toJava(primaryKey), lockMode, properties);

    shared actual Entity find<Entity>(JClass<Entity> entityClass, Object primaryKey)
            given Entity satisfies Object
            => entityManager.find<Entity>(entityClass, toJava(primaryKey));

    shared actual Entity find<Entity>(JClass<Entity> entityClass, Object primaryKey, Properties properties)
            given Entity satisfies Object
            => entityManager.find<Entity>(entityClass, toJava(primaryKey), properties);

    shared actual Entity find<Entity>(JClass<Entity> entityClass, Object primaryKey, LockModeType lockMode)
            given Entity satisfies Object
            => entityManager.find<Entity>(entityClass, toJava(primaryKey), lockMode);

    shared actual Entity find<Entity>(JClass<Entity> entityClass, Object primaryKey, LockModeType lockMode, Properties properties)
            given Entity satisfies Object
            => entityManager.find<Entity>(entityClass, toJava(primaryKey), lockMode, properties);

    shared actual void flush() => entityManager.flush();

    shared actual variable FlushModeType flushMode = entityManager.flushMode;

    shared actual EntityGraph<out Object> getEntityGraph(String graphName)
            => entityManager.getEntityGraph(graphName);

    shared actual List<EntityGraph<in Entity>> getEntityGraphs<Entity>(Class<Entity> entityClass)
            given Entity satisfies Object
            => entityManager.getEntityGraphs(javaClass(entityClass));

    shared actual List<EntityGraph<in Entity>> getEntityGraphs<Entity>(JClass<Entity> entityClass)
            given Entity satisfies Object
            => entityManager.getEntityGraphs(entityClass);

    shared actual LockModeType getLockMode(Object entity)
            => entityManager.getLockMode(entity);

    shared actual Entity getReference<Entity>(Class<Entity> entityClass, Object primaryKey)
            given Entity satisfies Object
            => entityManager.getReference(javaClass(entityClass), toJava(primaryKey));

    shared actual Entity getReference<Entity>(JClass<Entity> entityClass, Object primaryKey)
            given Entity satisfies Object
            => entityManager.getReference(entityClass, toJava(primaryKey));

    shared actual void joinTransaction() => entityManager.joinTransaction();

    shared actual Boolean joinedToTransaction => entityManager.joinedToTransaction;

    shared actual void lock(Object entity, LockModeType lockMode)
            => entityManager.lock(entity, lockMode);

    shared actual void lock(Object entity, LockModeType lockMode, Properties properties)
            => entityManager.lock(entity, lockMode, properties);

    shared actual Entity merge<Entity>(Entity entity)
            given Entity satisfies Object
            => entityManager.merge(entity);

    shared actual Metamodel metamodel => entityManager.metamodel;

    shared actual Boolean open => entityManager.open;

    shared actual void persist(Object entity) => entityManager.persist(entity);

    shared actual Properties properties => entityManager.properties;

    shared actual void refresh(Object entity) => entityManager.refresh(entity);

    shared actual void refresh(Object entity, Properties properties)
            => entityManager.refresh(entity);

    shared actual void refresh(Object entity, LockModeType lockMode)
            => entityManager.refresh(entity, lockMode);

    shared actual void refresh(Object entity, LockModeType lockMode, Properties properties)
            => entityManager.refresh(entity, lockMode, properties);

    shared actual void remove(Object entity) => entityManager.remove(entity);

    shared actual void setProperty(String propertyName, Object propertyValue)
            => entityManager.setProperty(propertyName, toJava(propertyValue));

    shared actual EntityTransaction transaction => entityManager.transaction;

    shared actual Delegate unwrap<Delegate>(JClass<Delegate> delegateClass)
            given Delegate satisfies Object
            => entityManager.unwrap(delegateClass);

}

