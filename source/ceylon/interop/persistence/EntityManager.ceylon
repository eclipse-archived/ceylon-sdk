/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.java {
    JavaMap,
    JavaStringMap,
    CeylonStringMap,
    CeylonMap,
    CeylonList
}
import ceylon.interop.persistence.criteria {
    Criteria
}
import ceylon.interop.persistence.util {
    Util {
        javaClass
    },
    toJava
}
import ceylon.language.meta.model {
    Class
}

import java.lang {
    Types {
        classForModel
    }
}

import javax.persistence {
    JEntityManager=EntityManager,
    LockModeType,
    FlushModeType,
    EntityTransaction,
    EntityGraph,
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

"A [[Map]] associating string keys with items."
shared alias Properties => Map<String,Object>;

"Used to interact with a persistence context. Based closely on
 [[javax.persistence.EntityManager|javax.persistence::EntityManager]],
 but automatically manages conversions between Ceylon types
 and corresponding Java types, without the need for JPA
 `AttributeConverter`s.

 An `EntityManager` instance is associated with a persistence
 context. A persistence context is a set of entity instances
 in which for any persistent entity identity there is a unique
 entity instance. Within the persistence context, the entity
 instances and their lifecycle are managed. The `EntityManager`
 API is used to create and remove persistent entity instances,
 to find entities by their primary key, and to query over
 entities.

 The set of entities that can be managed by a given
 `EntityManager` instance is defined by a persistence unit.
 A persistence unit defines the set of all classes that are
 related or grouped by the application, and which must be
 colocated in their mapping to a single database."
shared class EntityManager
        satisfies Category<> & Destroyable {

    "The underlying JPA entity manager."
    shared JEntityManager entityManager;

    shared new (JEntityManager entityManager) {
        this.entityManager = entityManager;
    }

    shared new create(EntityManagerFactory entityManagerFactory,
            Properties properties = emptyMap) {
        entityManager =
                properties.empty
                then entityManagerFactory.createEntityManager()
                else entityManagerFactory.createEntityManager(
                        JavaMap(JavaStringMap(properties)));
    }

    "Determine whether the entity manager is open, returning
     `true` unless the entity manager has already been closed."
    shared Boolean open => entityManager.open;

    "Close an application-managed entity manager. After the
     close method has been invoked, all methods on the
     `EntityManager` instance and any `TypedQuery` objects
     obtained from it will throw the `IllegalStateException`
     except for [[properties]], [[transaction]], and [[open]]
     (which will return false). If this method is called
     when the entity manager is associated with an active
     transaction, the persistence context remains managed
     until the transaction completes."
    shared void close() => entityManager.close();

    shared actual void destroy(Throwable? error) => close();

    "Check if the instance is a managed entity instance
     belonging to the current persistence context."
    shared actual Boolean contains(Object entity)
            => entityManager.contains(entity);

    "Clear the persistence context, causing all managed
     entities to become detached. Changes made to entities
     that have not been flushed to the database will not be
     persisted."
    shared void clear() => entityManager.clear();

    "The flush mode that applies to all objects contained in
     the persistence context."
    shared FlushModeType flushMode => entityManager.flushMode;
    assign flushMode => entityManager.flushMode = flushMode;

    "Synchronize the persistence context to the underlying
     database, by actually executing SQL DML statements."
    shared void flush() => entityManager.flush();

    "Return the resource-level `EntityTransaction` object.
     The `EntityTransaction` instance may be used serially
     to begin and commit multiple transactions.."
    shared EntityTransaction transaction
            => entityManager.transaction;

    "Indicate to the entity manager that a JTA transaction
     is active. This method should be called on a JTA
     application managed entity manager that was created
     outside the scope of the active transaction to associate
     it with the current JTA transaction."
    shared void joinTransaction()
            => entityManager.joinTransaction();

    "Determine whether the entity manager is joined to the
     current transaction. Returns `false` if the entity
     manager is not joined to the current transaction or if
     no transaction is active."
    shared Boolean joinedToTransaction
            => entityManager.joinedToTransaction;

    "Return an instance of the `Metamodel` interface for
     access to the metamodel of the persistence unit."
    shared Metamodel metamodel => entityManager.metamodel;

    "Get the properties and hints and associated values that
     are in effect for this entity manager."
    shared Properties properties
            => CeylonStringMap(CeylonMap(
                    entityManager.properties));

    "Set an entity manager property or hint."
    shared void setProperty(String propertyName,
        Object propertyValue)
            => entityManager.setProperty(propertyName,
                    toJava(propertyValue));

    "Create an instance of [[Query]] for executing a Java
     Persistence query language statement."
    shared Query createQuery(String query)
            => Query(entityManager.createQuery(query));

    "Create an instance of [[TypedQuery]] for executing a
     Java Persistence query language statement. The select
     list of the query must contain exactly one item, which
     must be assignable to the type specified by the
     [[resultClass]] argument."
    shared TypedQuery<Result> createTypedQuery<Result>(
        String query, Class<Result> resultClass)
            given Result satisfies Object
            => TypedQuery(entityManager.createQuery(query,
                    javaClass(resultClass)));

    "Create an instance of [[Query]] for executing a named
     query (in the Java Persistence query language or in
     native SQL)."
    shared Query createNamedQuery(String name)
            => Query(entityManager.createNamedQuery(name));

    "Create an instance of [[TypedQuery]] for executing a
     Java Persistence query language named query. The select
     list of the query must contain exactly one item, which
     must be assignable to the type specified by the
     [[resultClass]] argument."
    shared TypedQuery<Result> createNamedTypedQuery<Result>(
        String name, Class<Result> resultClass)
            given Result satisfies Object
            => TypedQuery(entityManager.createNamedQuery(name,
                    javaClass(resultClass)));

    "Create an instance of [[Query]] for executing a native
     SQL DML statement, that is, an insert, update, or delete."
    shared Query createNativeQuery(String sqlQuery)
            => Query(entityManager.createNativeQuery(sqlQuery));

    "Create an instance of [[Query]] for executing a native
     SQL query."
    shared Query createNativeMappedQuery(String sqlQuery,
        String resultSetMapping)
            => Query(entityManager.createNativeQuery(sqlQuery,
                    resultSetMapping));

    "Create an instance of [[TypedQuery]] for executing a
     native SQL query."
    shared TypedQuery<Result> createNativeTypedQuery<Result>(
        String sqlQuery, Class<Result> resultClass)
            given Result satisfies Object
            => TypedQuery.withResultClass(resultClass,
                    entityManager.createNativeQuery(sqlQuery,
                        javaClass(resultClass)));

    "An instance of [[Criteria]] for creating and executing
     criteria queries."
    shared Criteria createCriteria() => Criteria(entityManager);

    "An instance of `CriteriaBuilder` for the creating
     `CriteriaQuery` objects."
    shared CriteriaBuilder criteriaBuilder
            => entityManager.criteriaBuilder;

    "Create an instance of [[TypedQuery]] for executing a
     criteria query."
    shared TypedQuery<Result> createCriteriaQuery<Result>(
        CriteriaQuery<Result> criteriaQuery)
            given Result satisfies Object
            => TypedQuery(entityManager.createQuery(criteriaQuery));

    "Create an instance of [[Query]] for executing a criteria
     update query."
    shared Query createUpdateQuery(
        CriteriaUpdate<out Object> updateQuery)
            => Query(entityManager.createQuery(updateQuery));

    "Create an instance of [[Query]] for executing a criteria
     delete query."
    shared Query createDeleteQuery(
        CriteriaDelete<out Object> deleteQuery)
            => Query(entityManager.createQuery(deleteQuery));

    "Create an instance of [[Query]] for executing a stored
     procedure in the database."
    shared Query createNamedStoredProcedureQuery(
        String name)
            => Query(entityManager.createNamedStoredProcedureQuery(name));

    "Create an instance of [[Query]] for executing a stored
     procedure in the database. Parameters must be registered
     before the stored procedure can be executed. The
     [[resultSetMappings]] arguments must be specified in the
     order in which the result sets will be returned by the
     stored procedure invocation."
    shared Query createStoredProcedureMappedQuery(
        String procedureName, String* resultSetMappings)
            => Query(entityManager.createStoredProcedureQuery(
                    procedureName, *resultSetMappings));

    "Create an instance of [[Query]] for executing a stored
     procedure in the database. Parameters must be registered
     before the stored procedure can be executed. The
     [[resultClasses]] arguments must be specified in the
     order in which the result sets will be returned by the
     stored procedure invocation."
    shared Query createStoredProcedureQuery(
    String procedureName, Class<Object>* resultClasses)
            => Query(entityManager.createStoredProcedureQuery(
                    procedureName,
                    for (rc in resultClasses)
                        classForModel(rc)));

    "Find by [[primary key|primaryKey]], with the given
     [[lock mode|lockMode]], using the specified
     [[properties]]. Search for an entity of the specified
     [[class|entityClass]] and primary key and lock it with
     respect to the specified lock type. If the entity
     instance is contained in the persistence context, it is
     returned from there.

     If the entity is found within the persistence context
     and the lock mode type is pessimistic and the entity
     has a version attribute, the persistence provider must
     perform optimistic version checks when obtaining the
     database lock. If these checks fail, the
     `OptimisticLockException` will be thrown.

     If the lock mode type is pessimistic and the entity
     instance is found but cannot be locked:

     - the `PessimisticLockException` will be thrown if the
       database locking failure causes transaction-level
       rollback,
     - the `LockTimeoutException` will be thrown if the
       database locking failure causes only statement-level
       rollback."
    shared Entity? find<Entity>(Class<Entity> entityClass,
        Object primaryKey,
        LockModeType lockMode = LockModeType.none,
        Properties properties = emptyMap)
            given Entity satisfies Object
            => entityManager.find(javaClass(entityClass),
                    toJava(primaryKey), lockMode,
                    JavaMap(JavaStringMap(properties)));

    "Get an instance, whose state may be lazily fetched. If
     the requested instance does not exist in the database,
     the `EntityNotFoundException` is thrown when the
     instance state is first accessed. (The persistence
     provider runtime is permitted to throw the
     `EntityNotFoundException` when `getReference()` is
     called.) The application should not expect that the
     instance state will be available upon detachment,
     unless it was accessed by the application while the
     entity manager was open."
    shared Entity getReference<Entity>(
        Class<Entity> entityClass, Object primaryKey)
            given Entity satisfies Object
            => entityManager.getReference(
                    javaClass(entityClass),
                    toJava(primaryKey));

    "Remove the given entity from the persistence context,
     causing a managed entity to become detached. Unflushed
     changes made to the entity if any (including removal of
     the entity), will not be synchronized to the database.
     Entities which previously referenced the detached entity
     will continue to reference it."
    shared void detach(Object entity)
            => entityManager.detach(entity);

    "Make an instance managed and persistent."
    shared void persist(Object entity)
            => entityManager.persist(entity);

    "Merge the state of the given entity into the current
     persistence context."
    shared Entity merge<Entity>(Entity entity)
            given Entity satisfies Object
            => entityManager.merge(entity);

    "Remove the entity instance."
    shared void remove(Object entity)
            => entityManager.remove(entity);

    "Refresh the state of the instance from the database,
     overwriting changes made to the entity, if any, and
     lock it with respect to given lock mode type and with
     specified properties.

     If the lock mode type is pessimistic and the entity
     instance is found but cannot be locked:

     - the `PessimisticLockException` will be thrown if the
       database locking failure causes transaction-level
       rollback,
     - the `LockTimeoutException` will be thrown if the
       database locking failure causes only statement-level
       rollback."
    shared void refresh(Object entity,
        LockModeType lockMode = LockModeType.none,
        Properties properties = emptyMap)
            => entityManager.refresh(entity, lockMode,
                    JavaMap(JavaStringMap(properties)));

    "Lock an entity instance that is contained in the
     persistence context with the specified lock mode type
     and with specified properties.

     If a pessimistic lock mode type is specified and the
     entity contains a version attribute, the persistence
     provider must also perform optimistic version checks
     when obtaining the database lock. If these checks fail,
     the `OptimisticLockException` will be thrown.

     If the lock mode type is pessimistic and the entity
     instance is found but cannot be locked:

     - the `PessimisticLockException` will be thrown if the
       database locking failure causes transaction-level
       rollback,
     - the `LockTimeoutException` will be thrown if the
       database locking failure causes only statement-level
       rollback."
    shared void lock(Object entity,
        LockModeType lockMode,
        Properties properties = emptyMap)
            => entityManager.lock(entity, lockMode,
                    JavaMap(JavaStringMap(properties)));
    "Get the current lock mode for the entity instance."
    shared LockModeType getLockMode(Object entity)
            => entityManager.getLockMode(entity);

    "Return a named `EntityGraph`. The returned `EntityGraph`
     should be considered immutable."
    shared EntityGraph<out Object> getEntityGraph(
        String graphName)
            => entityManager.getEntityGraph(graphName);

    "Return all named `EntityGraph`s that have been defined
     for the provided class type."
    shared List<EntityGraph<in Entity>> getEntityGraphs<Entity>(
        Class<Entity> entityClass)
            given Entity satisfies Object
            => CeylonList(entityManager.getEntityGraphs(
                    javaClass(entityClass)));

    "Return a mutable `EntityGraph` that can be used to
     dynamically create an `EntityGraph`."
    shared EntityGraph<Entity> createEntityGraph<Entity>(
        Class<Entity> rootType)
            given Entity satisfies Object
            => entityManager.createEntityGraph(
                    javaClass(rootType));

    "Return a mutable copy of the named `EntityGraph`. If
     there is no entity graph with the specified name, `null`
     is returned."
    shared EntityGraph<out Object>? createNamedEntityGraph(
        String graphName)
            => entityManager.createEntityGraph(graphName);

}

