import ceylon.interop.java {
    javaClass,
    CeylonStringMap,
    CeylonMap
}
import ceylon.language.meta.model {
    Class
}

import java.util {
    Calendar,
    Date
}

import javax.persistence {
    JEntityManager=EntityManager,
    JQuery=Query,
    LockModeType,
    FlushModeType,
    EntityTransaction,
    TemporalType
}

shared class EntityManager(entityManager)
        satisfies Category<> {

    shared JEntityManager entityManager;

    shared Boolean open => entityManager.open;

    shared void close() => entityManager.close();

    shared void clear() => entityManager.clear();

    shared actual Boolean contains(Object entity)
            => entityManager.contains(entity);

    shared LockModeType lockMode(Object entity)
            => entityManager.getLockMode(false);

    shared void detach(Object entity)
            => entityManager.detach(entity);

    shared void flush() => entityManager.flush();

    shared FlushModeType flushMode => entityManager.flushMode;
    assign flushMode => entityManager.flushMode = flushMode;

    shared Entity? find<Entity>(Class<Entity> entity, Object primaryKey, LockModeType? lockMode = null)
            given Entity satisfies Object
            => let (pk = toJava(primaryKey))
            if (exists lockMode)
            then entityManager.find(javaClass<Entity>(), pk, lockMode)
            else entityManager.find(javaClass<Entity>(), pk);

    shared Entity reference<Entity>(Class<Entity> entity, Object primaryKey)
            given Entity satisfies Object
            => entityManager.getReference(javaClass<Entity>(),
                                          toJava(primaryKey));

    shared void lock(Object entity, LockModeType lockMode)
            => entityManager.lock(entity, lockMode);

    shared Entity merge<Entity>(Entity entity)
            given Entity satisfies Object
            => entityManager.merge(entity);

    shared void persist(Object entity)
            => entityManager.persist(entity);

    shared void refresh(Object entity, LockModeType? lockMode = null) {
        if (exists lockMode) {
            entityManager.refresh(entity, lockMode);
        }
        else {
            entityManager.refresh(entity);
        }
    }

    shared void remove(Object entity)
            => entityManager.remove(entity);

    shared void setProperty(String propertyName, Object propertyValue)
            => entityManager.setProperty(propertyName,
                                         toJava(propertyValue));

    shared Map<String,Object> properties
            => CeylonStringMap(CeylonMap(entityManager.properties)
                    .mapItems((_,item) => toCeylonNotNull(item)));

    shared EntityTransaction transaction
            => entityManager.transaction;

    shared void joinTransaction()
            => entityManager.joinTransaction();

    shared Boolean joinedToTransaction
            => entityManager.joinedToTransaction;

    T setup<T>(T query,
            Integer? maxResults, Integer? firstResult,
            LockModeType? lockMode, FlushModeType? flushMode)
            given T satisfies JQuery {
        if (exists maxResults) {
            query.setMaxResults(maxResults);
        }
        if (exists firstResult) {
            query.setFirstResult(firstResult);
        }
        if (exists lockMode) {
            query.setLockMode(lockMode);
        }
        if (exists flushMode) {
            query.setFlushMode(flushMode);
        }
        return query;
    }

    shared class Query<Type>
            (Class<Type> resultType, String query,
                maxResults = null, firstResult = null,
                lockMode = null, flushMode = null)
            extends BaseQuery<Type>
                (setup(entityManager.createQuery(query, javaClass<Type>()),
                        //TODO: use javaClassFromModel(entity) when #6682 is fixed
                    maxResults, firstResult, lockMode, flushMode))
            given Type satisfies Object {

        Integer? maxResults;
        Integer? firstResult;
        LockModeType? lockMode;
        FlushModeType? flushMode;

        shared actual Query<Type> setHint(String hintName, Object hintValue) {
            super.setHint(hintName, hintValue);
            return this;
        }
        shared actual Query<Type> setArgument(parameter, argument) {
            Integer|String parameter;
            Anything argument;

            super.setArgument(parameter, argument);
            return this;
        }
        shared actual Query<Type> setTemporalArgument(parameter, temporalType, argument) {
            Integer|String parameter;
            TemporalType temporalType;
            Calendar|Date argument;

            super.setTemporalArgument(parameter, temporalType, argument);
            return this;
        }
        shared actual Query<Type> withArguments(Anything* arguments) {
            super.withArguments(*arguments);
            return this;
        }
        shared actual Query<Type> withNamedArguments(<String->Anything>* arguments) {
            super.withNamedArguments(*arguments);
            return this;
        }

    }

    shared class NamedQuery<Type>
            (Class<Type> resultType, String name,
                maxResults = null, firstResult = null,
                lockMode = null, flushMode = null)
            extends BaseQuery<Type>
                (setup(entityManager.createNamedQuery(name, javaClass<Type>()),
                    maxResults, firstResult, lockMode, flushMode))
            given Type satisfies Object {

        Integer? maxResults;
        Integer? firstResult;
        LockModeType? lockMode;
        FlushModeType? flushMode;

        shared actual NamedQuery<Type> setHint(String hintName, Object hintValue) {
            super.setHint(hintName, hintValue);
            return this;
        }
        shared actual NamedQuery<Type> setArgument(parameter, argument) {
            Integer|String parameter;
            Anything argument;
            super.setArgument(parameter, argument);
            return this;
        }
        shared actual NamedQuery<Type> setTemporalArgument(parameter, temporalType, argument) {
            Integer|String parameter;
            TemporalType temporalType;
            Calendar|Date argument;

            super.setTemporalArgument(parameter, temporalType, argument);
            return this;
        }
        shared actual NamedQuery<Type> withArguments(Anything* arguments) {
            super.withArguments(*arguments);
            return this;
        }
        shared actual NamedQuery<Type> withNamedArguments(<String->Anything>* arguments) {
            super.withNamedArguments(*arguments);
            return this;
        }

    }

    shared class NativeQuery<Type>
            (Class<Type> resultType, String sqlQuery,
                String? resultSetMapping = null,
                maxResults = null, firstResult = null,
                lockMode = null, flushMode = null)
            extends BaseQuery<Type>
                (setup(if (exists resultSetMapping)
                        then entityManager.createNativeQuery(sqlQuery, resultSetMapping)
                        else entityManager.createNativeQuery(sqlQuery, javaClass<Type>()),
                    maxResults, firstResult, lockMode, flushMode))
            given Type satisfies Object {

        Integer? maxResults;
        Integer? firstResult;
        LockModeType? lockMode;
        FlushModeType? flushMode;

        shared actual NativeQuery<Type> setHint(String hintName, Object hintValue) {
            super.setHint(hintName, hintValue);
            return this;
        }
        shared actual NativeQuery<Type> setArgument(parameter, argument) {
            Integer|String parameter;
            Anything argument;

            super.setArgument(parameter, argument);
            return this;
        }
        shared actual NativeQuery<Type> setTemporalArgument(parameter, temporalType, argument) {
            Integer|String parameter;
            TemporalType temporalType;
            Calendar|Date argument;

            super.setTemporalArgument(parameter, temporalType, argument);
            return this;
        }
        shared actual NativeQuery<Type> withArguments(Anything* arguments) {
            super.withArguments(*arguments);
            return this;
        }
        shared actual NativeQuery<Type> withNamedArguments(<String->Anything>* arguments) {
            super.withNamedArguments(*arguments);
            return this;
        }

    }

    /*
        shared EntityGraph<out Object> entityGraph(String graphName)
                => entityManager.getEntityGraph(graphName);

        shared List<EntityGraph<in Type>> entityGraphs<Type>()
                given Type satisfies Object
                => CeylonList(entityManager.getEntityGraphs(javaClass<Type>()));

        shared EntityGraph<Type> createEntityGraph<Type>()
                given Type satisfies Object
                => entityManager.createEntityGraph(javaClass<Type>());

        shared EntityGraph<out Object> createNamedEntityGraph(String graphName)
                => entityManager.createEntityGraph(graphName);

    */

    //    shared Metamodel metamodel => entityManager.metamodel;

    //    shared TypedQuery<Type> createQuery<Type>(CriteriaQuery<Type>? criteriaQuery)
    //            given Type satisfies Object => nothing;
    //
    //    shared Query createQuery(CriteriaUpdate<out Object>? updateQuery) => nothing;
    //
    //    shared Query createQuery(CriteriaDelete<out Object>? deleteQuery) => nothing;

    //    shared StoredProcedureQuery createStoredProcedureQuery(String? procedureName) => nothing;
    //
    //    shared StoredProcedureQuery createStoredProcedureQuery(String? procedureName, String?* resultSetMappings) => nothing;

    //    shared CriteriaBuilder criteriaBuilder => entityManager.criteriaBuilder;
}
