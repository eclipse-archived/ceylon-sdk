import ceylon.language.meta.model {
    Class
}

import javax.persistence {
    EntityManager
}

shared class Criteria(shared EntityManager manager) {
    
    value builder = manager.criteriaBuilder;
    value criteriaQuery = builder.createQuery();

    variable Predicate? _where = null;
    variable Grouping? _groupBy = null;
    variable Predicate? _having = null;
    variable Order? _orderBy = null;

    shared Root<T> from<T>(Class<T> entity)
            given T satisfies Object
            => Root(criteriaQuery.from(entity));

    shared Criteria where(Predicate where) {
        _where = where;
        return this;
    }

    shared Criteria whereAll(Predicate+ where) {
        _where = and(*where);
        return this;
    }

    shared Criteria groupBy(Predicate groupBy) {
        _groupBy = groupBy;
        return this;
    }

    shared Criteria groupByAll(Predicate+ groupBy) {
        _groupBy = group(*groupBy);
        return this;
    }

    shared Criteria having(Predicate having) {
        _having = having;
        return this;
    }

    shared Criteria havingAll(Predicate+ having) {
        _having = and(*having);
        return this;
    }

    shared Criteria orderBy(Order orderBy) {
        _orderBy = orderBy;
        return this;
    }

    shared Criteria orderByAll(Order+ orderBy) {
        _orderBy = order(*orderBy);
        return this;
    }

    shared TypedQuery<R> select<R>(select)
            given R satisfies Object {

        Selection<R> select;

        criteriaQuery.select(select.criteriaSelection(builder));
        criteriaQuery.distinct(select.distinct);
        if (exists where=_where) {
            criteriaQuery.where(where.criteriaExpression(builder));
        }
        if (exists groupBy=_groupBy) {
            criteriaQuery.groupBy(*groupBy.criteriaExpressions(builder));
        }
        if (exists having=_having) {
            criteriaQuery.where(having.criteriaExpression(builder));
        }
        if (exists orderBy=_orderBy) {
            criteriaQuery.orderBy(*orderBy.criteriaOrder(builder));
        }

        return TypedQuery<R>.withoutResultClass {
            manager.createQuery(criteriaQuery);
        };
    }
}
