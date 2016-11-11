import ceylon.interop.java {
    CeylonStringMap,
    CeylonMap,
    CeylonSet,
    CeylonList
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
    TemporalType
}

shared alias Hints => Map<String,Object>;

shared class Query(JQuery query)
        => TypedQuery<>.withoutResultClass(query);

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

    shared Result getSingleResult() {
        assert (is Result result = query.singleResult);
        return result;
    }

    shared List<Result> getResults() => CeylonList(getResultList());

    suppressWarnings("uncheckedTypeArguments")
    shared JList<out Result> getResultList() {
        assert (is JList<out Result> resultList = query.resultList);
        return resultList;
    }

    shared Integer executeUpdate() => query.executeUpdate();

    shared Integer maxResults => query.maxResults;
//    assign maxResults => setMaxResults(maxResults);

    shared TypedQuery<Result> setMaxResults(Integer maxResults) {
        query.setMaxResults(maxResults);
        return this;
    }

    shared Integer firstResult => query.firstResult;
//    assign firstResult => setFirstResult(firstResult);

    shared TypedQuery<Result> setFirstResult(Integer startPosition) {
        query.setFirstResult(startPosition);
        return this;
    }

    shared LockModeType lockMode => query.lockMode;
//    assign lockMode => setLockMode(lockMode);

    shared TypedQuery<Result> setLockMode(LockModeType lockMode) {
        query.setLockMode(lockMode);
        return this;
    }

    shared FlushModeType flushMode => query.flushMode;
//    assign flushMode => setFlushMode(flushMode);

    shared TypedQuery<Result> setFlushMode(FlushModeType flushMode) {
        query.setFlushMode(flushMode);
        return this;
    }

    shared Hints hints => CeylonStringMap(CeylonMap(query.hints));

    shared TypedQuery<Result> setHint(String hintName, Object? hintValue) {
        query.setHint(hintName, toJava(hintValue));
        return this;
    }

    shared Parameter<out Object> getParameter(Integer|String parameter)
            => switch(parameter)
            case (is Integer) query.getParameter(parameter)
            case (is String) query.getParameter(parameter);

    shared Parameter<Argument> getTypedParameter<Argument>(
        Integer|String parameter, Class<Argument> type)
            given Argument satisfies Object {
        value javaClass = Util.javaClass(type);
        return
            switch (parameter)
            case (is Integer)
                query.getParameter(parameter, javaClass)
            case (is String)
                query.getParameter(parameter, javaClass);
    }

    shared Argument? getTypedParameterArgument<Argument>(
        Parameter<Argument> parameter)
            given Argument satisfies Object {
        assert (is Argument argument = toCeylon(query.getParameterValue(parameter)));
        return argument;
    }

    shared Object? getParameterArgument(Integer|String parameter)
            => switch (parameter)
            case (is Integer)
                toCeylon(query.getParameterValue(parameter))
            case (is String)
                toCeylon(query.getParameterValue(parameter));

    shared Set<Parameter<out Object>> parameters
            => CeylonSet(query.parameters);

    shared Boolean isBound(Parameter<out Object> parameter)
            => query.isBound(parameter);

    shared TypedQuery<Result> setTypedParameter<Argument>(
        Parameter<Argument> parameter, Argument? argument)
            given Argument satisfies Object {
        query.setParameter(parameter.name, toJava(argument));
        return this;
    }

    shared TypedQuery<Result> setParameter(
        String|Integer parameter, Object? argument) {
        switch (parameter)
        case (is String) {
            query.setParameter(parameter, toJava(argument));
        }
        case (is Integer) {
            query.setParameter(parameter, toJava(argument));

        }
        return this;
    }

    //TODO: handle ceylon.time types!!!

    suppressWarnings("uncheckedTypeArguments")
    shared TypedQuery<Result> setTemporalTypedParameter<Type>(
        Parameter<Type> parameter, Type argument,
        TemporalType temporalType)
            given Type of Calendar|Date {
        switch(argument)
        case (is Date) {
            assert (is Parameter<Date> parameter);
            query.setParameter(parameter, argument, temporalType);
        }
        case (is Calendar) {
            assert (is Parameter<Calendar> parameter);
            query.setParameter(parameter, argument, temporalType);
        }
        return this;
    }

    shared TypedQuery<Result> setTemporalParameter(
        Integer|String parameter, Date|Calendar argument,
        TemporalType temporalType) {
        switch(argument)
        case (is Date) {
            switch (parameter)
            case (is Integer) {
                query.setParameter(parameter, argument, temporalType);
            }
            case (is String) {
                query.setParameter(parameter, argument, temporalType);
            }
        }
        case (is Calendar) {
            switch (parameter)
            case (is Integer) {
                query.setParameter(parameter, argument, temporalType);
            }
            case (is String) {
                query.setParameter(parameter, argument, temporalType);
            }
        }
        return this;
    }

    shared TypedQuery<Result> setPositionalArguments(Object* arguments) {
        for (index->arg in arguments.indexed) {
            setParameter(index, arg);
        }
        return this;
    }

    shared TypedQuery<Result> setNamedArguments(<String->Object>* arguments) {
        for (param->arg in arguments) {
            setParameter(param, arg);
        }
        return this;
    }

}