import ceylon.interop.java {
    CeylonMap,
    CeylonStringMap,
    CeylonList,
    javaString
}

import java.util {
    Calendar,
    Date,
    JList=List
}

import javax.persistence {
    JQuery=Query,
    FlushModeType,
    LockModeType,
    TemporalType
}

shared class BaseQuery<out Type>(query)
        satisfies Correspondence<String|Integer>
                & KeyedCorrespondenceMutator<String|Integer,Anything>
        given Type satisfies Object {

    shared JQuery query;

    shared Integer maxResults => query.maxResults;
    assign maxResults => query.setMaxResults(maxResults);

    shared Integer firstResult => query.firstResult;
    assign firstResult => query.setFirstResult(firstResult);

    shared LockModeType lockMode => query.lockMode;
    assign lockMode => query.setLockMode(lockMode);

    shared FlushModeType flushMode => query.flushMode;
    assign flushMode => query.setFlushMode(flushMode);

    shared Map<String,Object> hints
            => CeylonStringMap(CeylonMap(query.hints)
                .mapItems((_,item) => toCeylonNotNull(item)));

    shared Object? hint(String hintName)
            => toCeylon(query.hints[javaString(hintName)]);

    shared default BaseQuery<Type> setHint(String hintName, Object hintValue) {
        query.setHint(hintName, toJavaNotNull(hintValue));
        return this;
    }

    shared Type getSingleResult() {
        assert (is Type singleResult = query.singleResult);
        return singleResult;
    }

    suppressWarnings("uncheckedTypeArguments")
    shared JList<out Type> getJavaResultList() {
        assert (is JList<out Type> resultList = query.resultList);
        return resultList;
    }

    shared List<Type> getResultList() => CeylonList(getJavaResultList());

    shared Integer executeUpdate() => query.executeUpdate();

    defines(String|Integer parameter)
            => query.isBound(switch (parameter)
            case (is String) query.getParameter(parameter)
            case (is Integer) query.getParameter(parameter));

    get(String|Integer parameter)
            => argument(parameter);

    put(String|Integer parameter, Anything argument)
            => setArgument(parameter, argument);

    shared Object? argument(Integer|String parameter)
            => toCeylon(switch (parameter)
            case (is String) query.getParameterValue(parameter)
            case (is Integer) query.getParameterValue(parameter));

    shared default BaseQuery<Type> setArgument(parameter, argument) {

        Integer|String parameter;
        Anything argument;

        value arg = toJava(argument);
        switch (parameter)
        case (is Integer) {
            query.setParameter(parameter, arg);
        }
        case (is String) {
            query.setParameter(parameter, arg);
        }
        return this;
    }

    shared default BaseQuery<Type> setTemporalArgument(parameter, temporalType, argument) {

        Integer|String parameter;
        TemporalType temporalType;
        Calendar|Date argument;

        switch ([parameter, argument])
        case ([Integer position, Calendar calendar]) {
            query.setParameter(position, calendar, temporalType);
        }
        case ([Integer position, Date date]) {
            query.setParameter(position, date, temporalType);
        }
        case ([String name, Calendar calendar]) {
            query.setParameter(name, calendar, temporalType);
        }
        case ([String name, Date date]) {
            query.setParameter(name, date, temporalType);
        }
        else {
            //impossible
            assert (false);
        }
        return this;
    }

    shared default BaseQuery<Type> withArguments(Anything* arguments) {
        variable value i = 0;
        for (argument in arguments) {
            setArgument(i++, argument);
        }
        return this;
    }

    shared default BaseQuery<Type> withNamedArguments(<String->Anything>* arguments) {
        for (name -> argument in arguments) {
            setArgument(name, argument);
        }
        return this;
    }

    /*
        shared Parameter<T> getNamedParameter<T>(String name)
                given T satisfies Object
                => typedQuery.getParameter(name, javaClass<T>());

        shared Parameter<T> getParameter<T>(Integer position)
                given T satisfies Object
                => typedQuery.getParameter(position, javaClass<T>());

        shared T getParameterValue<T>(Parameter<T> param)
                given T satisfies Object
                => typedQuery.getParameterValue(param);

        shared Boolean bound(Parameter<out Object> param)
                => typedQuery.isBound(param);

        shared Set<Parameter<out Object>> parameters
                => CeylonSet(typedQuery.parameters);

    */

}
