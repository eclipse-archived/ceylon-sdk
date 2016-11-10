import java.lang {
    Class,
    JString=String
}
import java.util {
    Map,
    Set,
    List,
    Calendar,
    Date
}

import javax.persistence {
    JQuery=Query,
    JTypedQuery=TypedQuery,
    FlushModeType,
    Parameter,
    LockModeType,
    TemporalType
}

shared class Query(JQuery query)
        satisfies JQuery {

    shared actual Integer executeUpdate() => query.executeUpdate();

    shared actual Integer firstResult => query.firstResult;

    shared actual FlushModeType flushMode => query.flushMode;

    shared actual Parameter<out Object> getParameter(String name)
            => query.getParameter(name);

    shared actual Parameter<Argument> getParameter<Argument>(String name, Class<Argument> type)
            given Argument satisfies Object
            => query.getParameter(name, type);

    shared actual Parameter<out Object> getParameter(Integer position)
            => query.getParameter(position);

    shared actual Parameter<Argument> getParameter<Argument>(Integer position, Class<Argument> type)
            given Argument satisfies Object
            => query.getParameter(position, type);

    shared actual Argument? getParameterValue<Argument>(Parameter<Argument> param)
            given Argument satisfies Object
            => query.getParameterValue(param); //TODO: type conversion!

    shared actual Object? getParameterValue(String name)
            => toCeylon(query.getParameterValue(name));

    shared actual Object? getParameterValue(Integer position)
            => toCeylon(query.getParameterValue(position));

    shared actual Map<JString,Object> hints => query.hints;

    shared actual Boolean isBound(Parameter<out Object> param)
            => query.isBound(param);

    shared actual LockModeType lockMode => query.lockMode;

    shared actual Integer maxResults => query.maxResults;

    shared actual Set<Parameter<out Object>> parameters => query.parameters;

    shared actual default List<out Object> resultList => query.resultList;

    shared actual default Object singleResult => query.singleResult;

    shared actual default Query setFirstResult(Integer startPosition) {
        query.setFirstResult(startPosition);
        return this;
    }

    shared actual default Query setFlushMode(FlushModeType? flushMode) {
        query.setFlushMode(flushMode);
        return this;
    }

    shared actual default Query setHint(String hintName, Object? hintValue) {
        query.setHint(hintName, toJava(hintValue));
        return this;
    }

    shared actual default Query setLockMode(LockModeType? lockMode) {
        query.setLockMode(lockMode);
        return this;
    }

    shared actual default Query setMaxResults(Integer maxResults) {
        query.setMaxResults(maxResults);
        return this;
    }

    shared actual default Query setParameter<Argument>(Parameter<Argument> param, Argument? arg)
            given Argument satisfies Object {
        query.setParameter(param.name, toJava(arg));
        return this;
    }

    shared actual default Query setParameter(Parameter<Calendar> param, Calendar? arg, TemporalType temporalType) {
        query.setParameter(param, arg, temporalType);
        return this;
    }

    shared actual default Query setParameter(Parameter<Date> param, Date? arg, TemporalType temporalType) {
        query.setParameter(param, arg, temporalType);
        return this;
    }

    shared actual default Query setParameter(String name, Object? arg) {
        query.setParameter(name, toJava(arg));
        return this;
    }

    shared actual default Query setParameter(String name, Calendar? arg, TemporalType temporalType) {
        query.setParameter(name, arg, temporalType);
        return this;
    }

    shared actual default Query setParameter(String name, Date? arg, TemporalType temporalType) {
        query.setParameter(name, arg, temporalType);
        return this;
    }

    shared actual default Query setParameter(Integer position, Object? arg) {
        query.setParameter(position, toJava(arg));
        return this;
    }

    shared actual default Query setParameter(Integer position, Calendar? arg, TemporalType temporalType) {
        query.setParameter(position, arg, temporalType);
        return this;
    }

    shared actual default Query setParameter(Integer position, Date? arg, TemporalType temporalType) {
        query.setParameter(position, arg, temporalType);
        return this;
    }

    shared actual Delegate unwrap<Delegate>(Class<Delegate> delegateClass)
            given Delegate satisfies Object
            => query.unwrap(delegateClass);

}

shared class TypedQuery<Result>(JTypedQuery<Result> query)
        extends Query(query)
        satisfies JTypedQuery<Result>
        given Result satisfies Object {

    shared actual List<Result> resultList => query.resultList;

    shared actual TypedQuery<Result> setFirstResult(Integer startPosition) {
        query.setFirstResult(startPosition);
        return this;
    }

    shared actual TypedQuery<Result> setFlushMode(FlushModeType? flushMode) {
        query.setFlushMode(flushMode);
        return this;
    }

    shared actual TypedQuery<Result> setHint(String hintName, Object? hintValue) {
        query.setHint(hintName, hintValue);
        return this;
    }

    shared actual TypedQuery<Result> setLockMode(LockModeType? lockMode) {
        query.setLockMode(lockMode);
        return this;
    }

    shared actual TypedQuery<Result> setMaxResults(Integer maxResults) {
        query.setMaxResults(maxResults);
        return this;
    }

    shared actual Result singleResult => query.singleResult;

    shared actual TypedQuery<Result> setParameter<Argument>(Parameter<Argument> param, Argument? arg)
            given Argument satisfies Object {
        query.setParameter(param.name, toJava(arg));
        return this;
    }

    shared actual TypedQuery<Result> setParameter(Parameter<Calendar> param, Calendar? arg, TemporalType temporalType) {
        query.setParameter(param, arg, temporalType);
        return this;
    }

    shared actual TypedQuery<Result> setParameter(Parameter<Date> param, Date? arg, TemporalType temporalType) {
        query.setParameter(param, arg, temporalType);
        return this;
    }

    shared actual TypedQuery<Result> setParameter(String name, Object? arg) {
        query.setParameter(name, toJava(arg));
        return this;
    }

    shared actual TypedQuery<Result> setParameter(String name, Calendar? arg, TemporalType temporalType) {
        query.setParameter(name, arg, temporalType);
        return this;
    }

    shared actual TypedQuery<Result> setParameter(String name, Date? arg, TemporalType temporalType) {
        query.setParameter(name, arg, temporalType);
        return this;
    }

    shared actual TypedQuery<Result> setParameter(Integer position, Object? arg) {
        query.setParameter(position, toJava(arg));
        return this;
    }

    shared actual TypedQuery<Result> setParameter(Integer position, Calendar? arg, TemporalType temporalType) {
        query.setParameter(position, arg, temporalType);
        return this;
    }

    shared actual TypedQuery<Result> setParameter(Integer position, Date? arg, TemporalType temporalType) {
        query.setParameter(position, arg, temporalType);
        return this;
    }

}