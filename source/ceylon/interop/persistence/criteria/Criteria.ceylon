/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.persistence {
    TypedQuery
}
import ceylon.interop.persistence.util {
    toJavaNotNull
}
import ceylon.language.meta.model {
    Class
}

import java.lang {
    JLong=Long,
    JDouble=Double,
    JString=String,
    JBoolean=Boolean
}
import java.util {
    ArrayList
}

import javax.persistence {
    EntityManager
}
import javax.persistence.criteria {
    CriteriaBuilder,
    ParameterExpression
}

shared class Criteria(shared EntityManager manager) {

    value parameterArguments
            = ArrayList<ParameterExpression<Object>->Object>();

    value builder = manager.criteriaBuilder;
    value criteriaQuery = builder.createQuery();

    variable Predicate? whereClause = null;
    variable Grouping? groupByClause = null;
    variable Predicate? havingClause = null;
    variable Order? orderByClause = null;

    shared Root<T> from<T>(Class<T> entity)
            given T satisfies Object
            => Root(criteriaQuery.from(entity));

    shared Criteria where(Predicate+ where) {
        whereClause
                = if (where.rest nonempty)
                then and(*where)
                else where[0];
        return this;
    }

    shared Criteria groupBy(Predicate+ groupBy) {
        groupByClause
                = if (groupBy.rest nonempty)
                then group(*groupBy)
                else groupBy[0];
        return this;
    }

    shared Criteria having(Predicate+ having) {
        havingClause
                = if (having.rest nonempty)
                then and(*having)
                else having[0];
        return this;
    }

    shared Criteria orderBy(Order+ orderBy) {
        orderByClause
                = if (orderBy.rest nonempty)
                then order(*orderBy)
                else orderBy[0];
        return this;
    }

    shared TypedQuery<R> select<R>(select)
            given R satisfies Object {

        Selection<R> select;

        criteriaQuery.select(select.criteriaSelection(builder));
        criteriaQuery.distinct(select.distinct);
        if (exists where=whereClause) {
            criteriaQuery.where(where.criteriaExpression(builder));
        }
        if (exists groupBy=groupByClause) {
            criteriaQuery.groupBy(*groupBy.criteriaExpressions(builder));
        }
        if (exists having=havingClause) {
            criteriaQuery.where(having.criteriaExpression(builder));
        }
        if (exists orderBy=orderByClause) {
            criteriaQuery.orderBy(*orderBy.criteriaOrder(builder));
        }

        value query = manager.createQuery(criteriaQuery);
        for (parameter->argument in parameterArguments) {
            query.setParameter(parameter, argument);
        }
        return TypedQuery<R>.withoutResultClass(query);
    }

    shared Expression<T> parameter<T>(T argument)
            given T of Integer | Float | String | Boolean
                    satisfies Object {

        value parameter
                = switch (argument)
                case (Integer)
                    builder.parameter<Object>(`JLong`)
                case (Float)
                    builder.parameter<Object>(`JDouble`)
                case (String)
                    builder.parameter<Object>(`JString`)
                case (Boolean)
                    builder.parameter<Object>(`JBoolean`);

        parameterArguments.add(parameter->toJavaNotNull(argument));

        return object satisfies Expression<T> {
            criteriaExpression(CriteriaBuilder builder)
                    => parameter;
        };
    }


}
