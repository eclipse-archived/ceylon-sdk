import ceylon.language.meta.model {
    Class
}

import javax.persistence {
    EntityManager
}
import ceylon.interop.persistence {
    TypedQuery
}

shared class Criteria(shared EntityManager manager) {
    
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

        return TypedQuery<R>.withoutResultClass {
            manager.createQuery(criteriaQuery);
        };
    }
}
