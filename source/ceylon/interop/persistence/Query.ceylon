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
    CeylonStringMap,
    CeylonMap,
    CeylonSet,
    CeylonList
}
import ceylon.interop.persistence.util {
    Util {
        javaClass
    },
    toJava,
    toCeylon
}
import ceylon.language.meta.model {
    Class
}

import java.util {
    Calendar,
    Date,
    JList=List
}

import javax.persistence {
    JQuery=Query,
    JTypedQuery=TypedQuery,
    FlushModeType,
    Parameter,
    LockModeType,
    TemporalType,
    ParameterMode,
    StoredProcedureQuery,
    NoResultException
}

shared class Query(JQuery query)
        => TypedQuery<>.withoutResultClass(query);

"Used to control query execution. Based closely on
 [[javax.persistence.TypedQuery|javax.persistence::TypedQuery]],
 but automatically manages conversions between Ceylon types
 and corresponding Java types, without the need for JPA
 `AttributeConverter`s."
shared class TypedQuery<out Result=Object>
        given Result satisfies Object {

    shared JQuery query;

    shared new (JTypedQuery<Result> query)  {
        this.query = query;
    }

    shared new withResultClass(Class<Result> resultClass, JQuery query) {
        this.query = query;
    }

    shared new withoutResultClass(JQuery query) {
        this.query = query;
    }

    "Execute a query that returns a single result, returning
     the result, or `null` if there are no results."
    shared Result? getSingleResult() {
        try {
            assert (is Result? result = query.singleResult);
            return result;
        }
        catch (NoResultException nre) {
            return null;
        }
    }

    "Execute a query and return the query results as a
     [[List]]."
    shared List<Result> getResults()
            => CeylonList(getResultList());

    "Execute a query and return the query results as a
     [[Java `List`|JList]]."
    suppressWarnings("uncheckedTypeArguments")
    shared JList<out Result> getResultList() {
        assert (is JList<out Result> resultList
                = query.resultList);
        return resultList;
    }

    "Execute an update or delete statement. Returns the
     number of affected rows."
    shared Integer executeUpdate() => query.executeUpdate();

    "Execute a stored procedure or SQL DML query, returning
     the outcome as a `QueryResults`."
    shared QueryResults execute() {
        Boolean hasResults;
        Integer updateCount;
        if (is StoredProcedureQuery query) {
            hasResults = query.execute();
            updateCount = -1;
        }
        else {
            updateCount = query.executeUpdate();
            hasResults = false;
        }
        return QueryResults {
            query = query;
            hasResults = hasResults;
            count = updateCount;
        };
    }

    "The maximum number of results to retrieve."
    shared Integer maxResults => query.maxResults;
//    assign maxResults => setMaxResults(maxResults);

    "Set the maximum number of results to retrieve."
    shared TypedQuery<Result> setMaxResults(Integer maxResults) {
        query.setMaxResults(maxResults);
        return this;
    }

    "The position of the first result to retrieve."
    shared Integer firstResult => query.firstResult;
//    assign firstResult => setFirstResult(firstResult);

    "Set the position of the first result to retrieve."
    shared TypedQuery<Result> setFirstResult(Integer startPosition) {
        query.setFirstResult(startPosition);
        return this;
    }

    "The lock mode type to be used for the query execution."
    shared LockModeType lockMode => query.lockMode;
//    assign lockMode => setLockMode(lockMode);

    "Set the lock mode type to be used for the query execution."
    shared TypedQuery<Result> setLockMode(LockModeType lockMode) {
        query.setLockMode(lockMode);
        return this;
    }

    "The flush mode type to be used for the query execution.
     The flush mode type applies to the query regardless of
     the flush mode type in use for the entity manager."
    shared FlushModeType flushMode => query.flushMode;
//    assign flushMode => setFlushMode(flushMode);

    "Set the flush mode type to be used for the query
     execution. The flush mode type applies to the query
     regardless of the flush mode type in use for the entity
     manager."
    shared TypedQuery<Result> setFlushMode(FlushModeType flushMode) {
        query.setFlushMode(flushMode);
        return this;
    }

    "Get the properties and hints and associated values that
     are in effect for the query instance."
    shared Properties hints
            => CeylonStringMap(CeylonMap(query.hints));

    "Set a query property or hint."
    shared TypedQuery<Result> setHint(String hintName, Object? hintValue) {
        query.setHint(hintName, toJava(hintValue));
        return this;
    }

    "Get the parameter object corresponding to the declared
     positional or named parameter with the given position
     or name. This method is not required to be supported
     for native queries."
    shared Parameter<out Object> getParameter(Integer|String parameter)
            => switch(parameter)
            case (Integer) query.getParameter(parameter)
            case (String) query.getParameter(parameter);

    "Get the parameter object corresponding to the declared
     parameter of the given name and type. This method is
     required to be supported for criteria queries only."
    shared Parameter<Argument> getTypedParameter<Argument>(
        Integer|String parameter, Class<Argument> type)
            given Argument satisfies Object {
        value javaClass = Util.javaClass(type);
        return
            switch (parameter)
            case (Integer)
                query.getParameter(parameter, javaClass)
            case (String)
                query.getParameter(parameter, javaClass);
    }

    "Return the argument bound to the given parameter."
    shared Argument? getTypedParameterArgument<Argument>(
        Parameter<Argument> parameter)
            given Argument satisfies Object {
        assert (is Argument argument
                = toCeylon(query.getParameterValue(parameter)));
        return argument;
    }

    "Return the argument bound to the given positional or
     named parameter."
    shared Object? getParameterArgument(Integer|String parameter)
            => switch (parameter)
            case (Integer)
                toCeylon(query.getParameterValue(parameter))
            case (String)
                toCeylon(query.getParameterValue(parameter));

    "Get the parameter objects corresponding to the declared
     parameters of the query. Returns an empty set if the
     query has no parameters. This method is not required to
     be supported for native queries."
    shared Set<Parameter<out Object>> parameters
            => CeylonSet(query.parameters);

    "Determine whether an argument has been bound to the
     given parameter."
    shared Boolean isBound(Parameter<out Object> parameter)
            => query.isBound(parameter);

    "Bind an argument to the given parameter."
    shared TypedQuery<Result> setTypedParameter<Argument>(
        Parameter<Argument> parameter, Argument? argument)
            given Argument satisfies Object {
        if (exists name = parameter.name) {
            query.setParameter(name, toJava(argument));
        }
        else if (exists pos = parameter.position) {
            query.setParameter(pos.longValue(), toJava(argument));
        }
        return this;
    }

    "Bind an argument to the given positional or named
     parameter."
    shared TypedQuery<Result> setParameter(
        String|Integer parameter, Object? argument) {
        switch (parameter)
        case (String) {
            query.setParameter(parameter, toJava(argument));
        }
        case (Integer) {
            query.setParameter(parameter, toJava(argument));
        }
        return this;
    }

    //TODO: handle ceylon.time types!!!

    "Bind an argument to the given parameter of temporal
     type."
    suppressWarnings("uncheckedTypeArguments")
    shared TypedQuery<Result> setTemporalTypedParameter<Type>(
        Parameter<Type> parameter, Type argument,
        TemporalType temporalType)
            given Type of Calendar|Date {
        switch(argument)
        case (Date) {
            assert (is Parameter<Date> parameter);
            query.setParameter(parameter, argument, temporalType);
        }
        case (Calendar) {
            assert (is Parameter<Calendar> parameter);
            query.setParameter(parameter, argument, temporalType);
        }
        return this;
    }

    "Bind an argument to the given positional or named
     parameter of temporal type."
    shared TypedQuery<Result> setTemporalParameter(
        Integer|String parameter, Date|Calendar argument,
        TemporalType temporalType) {
        switch(argument)
        case (Date) {
            switch (parameter)
            case (Integer) {
                query.setParameter(parameter, argument, temporalType);
            }
            case (String) {
                query.setParameter(parameter, argument, temporalType);
            }
        }
        case (Calendar) {
            switch (parameter)
            case (Integer) {
                query.setParameter(parameter, argument, temporalType);
            }
            case (String) {
                query.setParameter(parameter, argument, temporalType);
            }
        }
        return this;
    }

    "Bind arguments to all positional parameters."
    shared TypedQuery<Result> setPositionalArguments(Object* arguments) {
        for (index->arg in arguments.indexed) {
            setParameter(index+1, arg);
        }
        return this;
    }

    "Bind arguments to all named parameters."
    shared TypedQuery<Result> setNamedArguments(<String->Object>* arguments) {
        for (param->arg in arguments) {
            setParameter(param, arg);
        }
        return this;
    }

    "Register a named or positional parameter for a stored
     procedure call."
    shared TypedQuery<Result> registerParameter(
        Integer|String parameter, Class<Object> type,
        ParameterMode mode) {
        assert (is StoredProcedureQuery query);
        switch (parameter)
        case (Integer) {
            query.registerStoredProcedureParameter(parameter,
                    javaClass(type), mode);
        }
        case (String) {
            query.registerStoredProcedureParameter(parameter,
                    javaClass(type), mode);
        }
        return this;
    }

}

"Used to obtain the results of a stored procedure query."
shared class QueryResults(query, hasResults, count) {

    shared JQuery query;
    variable Boolean hasResults;
    Integer count;

    "Retrieve a value passed back from the procedure through
     an INOUT or OUT parameter. For portability, all results
     corresponding to result sets and update counts must be
     retrieved before the values of output parameters."
    shared Object? getOutputParameterValue(Integer|String parameter) {
        assert (is StoredProcedureQuery query);
        return
            switch (parameter)
            case (Integer)
                query.getOutputParameterValue(parameter)
            case (String)
                query.getOutputParameterValue(parameter);
    }

    "Return `true` if the query has multiple results, and
     the next result corresponds to a result set, and `false`
     if it is an update count or if there  are no results
     other than through INOUT and OUT parameters, if any, or
     if this is not a stored procedure query."
    shared Boolean hasMoreResults
            => if (is StoredProcedureQuery query)
            then hasResults || query.hasMoreResults()
            else false;

    "Return the update count if the query has been executed,
     or `null` if there is no pending result or if the next
     result is not an update count, or if this is not a
     stored procedure query."
    shared Integer? updateCount {
        if (is StoredProcedureQuery query) {
            value updateCount = query.updateCount;
            return updateCount>=0 then updateCount;
        }
        else {
            return count;
        }
    }

    "Return the next query results as a single result, or
     `null` if there are no more results."
    shared Anything getSingleResult() {
        if (is StoredProcedureQuery query) {
            try {
                value result = query.singleResult;
                hasResults = false;
                return result;
            }
            catch (NoResultException nre) {
                return null;
            }
        }
        else {
            return null;
        }
    }

    "Return the next query results as a [[List]], or `null`
     if there are no more results."
    shared List<>? getResults()
            => if (exists results = getResultList())
            then CeylonList(results)
            else null;

    "Return the next query results as a [[Java `List`|JList]],
     or `null` if there are no more results."
    shared JList<out Object>? getResultList() {
        if (is StoredProcedureQuery query) {
            try {
                value resultList = query.resultList;
                hasResults = false;
                return resultList;
            }
            catch (NoResultException nre) {
                return null;
            }
        }
        else {
            return null;
        }
    }

}