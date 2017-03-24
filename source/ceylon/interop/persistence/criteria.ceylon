import ceylon.language.meta.model {
    Class,
    Attribute
}

import java.lang {
    JInteger=Integer,
    JString=String,
    JBoolean=Boolean,
    JComparable=Comparable,
    JNumber=Number
}

import javax.persistence {
    EntityManager
}
import javax.persistence.criteria {
    CriteriaQuery,
    CriteriaFrom=From,
    CriteriaRoot=Root,
    CriteriaJoin=Join,
    CriteriaExpression=Expression,
    CriteriaSelection=Selection,
    CriteriaBuilder,
    CriteriaPredicate=Predicate,
    CriteriaOrder=Order
}

shared sealed interface Selection<out T> {
    shared formal CriteriaSelection<out Object>
        criteriaSelection(CriteriaBuilder builder);
    shared default Boolean distinct => false;
}

shared Selection<T> construct<T,A>(Class<T,A> type, Selection<A> select)
    given T satisfies Object
    => object satisfies Selection<T> {
        criteriaSelection(CriteriaBuilder builder)
                => builder.construct(type,
                *select.criteriaSelection(builder)
                            .compoundSelectionItems);
};

shared sealed interface Grouping {
    shared formal CriteriaExpression<out Object>[]
        criteriaExpressions(CriteriaBuilder builder);
}

shared sealed interface Expression<T>
        satisfies Selection<T>
                & Grouping {

    shared formal CriteriaExpression<out Object>
        criteriaExpression(CriteriaBuilder builder);

    criteriaSelection(CriteriaBuilder builder)
            => criteriaExpression(builder);

    criteriaExpressions(CriteriaBuilder builder)
            => [criteriaExpression(builder)];

}

shared Grouping group(Grouping* groupings)
        => object satisfies Grouping {
    criteriaExpressions(CriteriaBuilder builder)
            => [for (g in groupings)
                for (cg in g.criteriaExpressions(builder))
                cg];
};

shared sealed interface Predicate
        satisfies Expression<Boolean> {
    shared actual formal CriteriaPredicate
        criteriaExpression(CriteriaBuilder builder);
}

shared sealed interface Order {
    shared formal CriteriaOrder[] criteriaOrder(CriteriaBuilder builder);
}

shared Order asc<T>(Expression<T?>|Expression<T> expression)
        given T of Integer | Float | String
                satisfies Comparable<T>
        => object satisfies Order {
    criteriaOrder(CriteriaBuilder builder)
            => [builder.asc(expression.criteriaExpression(builder))];
};

shared Order desc<T>(Expression<T?>|Expression<T> expression)
        given T of Integer | Float | String
                satisfies Comparable<T>
        => object satisfies Order {
    criteriaOrder(CriteriaBuilder builder)
            => [builder.desc(expression.criteriaExpression(builder))];
};

shared Order order(Order* orders)
        => object satisfies Order {
    criteriaOrder(CriteriaBuilder builder)
            => [for (o in orders)
                for (co in o.criteriaOrder(builder))
                co];
};

shared sealed class Enumeration<out E,out F,out R>(selections)
        satisfies Selection<Tuple<E,F,R>>
        given R satisfies Anything[] {

    Selection<E>* selections;

    criteriaSelection(CriteriaBuilder builder)
            => builder.tuple(for (s in selections)
                s.criteriaSelection(builder));

    shared Enumeration<T|E,T,Tuple<E,F,R>> with<T>(Selection<T> selection)
            => Enumeration<T|E,T,Tuple<E,F,R>>(selection, *selections);
}

shared Enumeration<T,T,[]> with<T>(Selection<T> selection)
        => Enumeration<T,T,[]>(selection);

shared abstract class From<out T>(criteriaFrom)
        of Root<T>
         | Join<Anything,T>
        satisfies Selection<T>
        given T satisfies Object {

    CriteriaFrom<out Anything,T> criteriaFrom;

    shared Join<T,S> join<S>(Attribute<T,S|Collection<S>> attribute)
            given S satisfies Object
            => Join(criteriaFrom.join<T,S>(attribute.declaration.name));

    shared Expression<S> get<S>(Attribute<T,S,Nothing> attribute)
            => object satisfies Expression<S> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaFrom.get(attribute.declaration.name);
    };

    criteriaSelection(CriteriaBuilder builder)
            => criteriaFrom;
}

shared sealed class Root<out T>(CriteriaRoot<T> criteriaRoot)
        extends From<T>(criteriaRoot)
        given T satisfies Object {}

shared sealed class Join<out E,out T>(CriteriaJoin<E, T> criteriaJoin)
        extends From<T>(criteriaJoin)
        given T satisfies Object {}

alias StringExpression => CriteriaExpression<JString>;

shared Predicate like(Expression<String> expression, String pattern)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.like(x, pattern);
    }
};

shared Expression<String> concat(Expression<String>+ expressions)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        assert (is StringExpression x
                = first.criteriaExpression(builder));
        variable value result = x;
        for (next in rest) {
            assert (is StringExpression y
                    = next.criteriaExpression(builder));
            result = builder.concat(result, y);
        }
        return result;
    }
};

alias NumericExpression => CriteriaExpression<JNumber>;

shared Expression<T> neg<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.neg(x);
    }
};

shared Expression<T> abs<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.abs(x);
    }
};

shared Expression<T> sqrt<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.sqrt(x);
    }
};

shared Expression<T> sqr<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.prod(x,x);
    }
};

shared Expression<T> scale<T>(T factor, Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        assert (is NumericExpression y
                = lit(factor).criteriaExpression(builder));
        return builder.prod(y,x);
    }
};
shared Expression<T> max<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.max(x);
    }
};

shared Expression<T> min<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.max(x);
    }
};

shared Expression<T> avg<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.avg(x);
    }
};

shared Expression<T> sum<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.sum(x);
    }
};

shared Expression<T> add<T>(Expression<T>+ expressions)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        assert (is NumericExpression x
                = first.criteriaExpression(builder));
        variable value result = x;
        for (next in rest) {
            assert (is NumericExpression y
                    = next.criteriaExpression(builder));
            result = builder.sum(result, y);
        }
        return result;
    }
};

shared Expression<T> mult<T>(Expression<T>+ expressions)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        assert (is NumericExpression x
                = first.criteriaExpression(builder));
        variable value result = x;
        for (next in rest) {
            assert (is NumericExpression y
                    = next.criteriaExpression(builder));
            result = builder.prod(result, y);
        }
        return result;
    }
};

shared Expression<T> diff<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.diff(x, y);
    }
};

shared Expression<T> div<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.quot(x, y);
    }
};

alias IntegerExpression => CriteriaExpression<JInteger>;

shared Expression<Integer> mod(Expression<Integer> left, Expression<Integer> right)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is IntegerExpression x
                = left.criteriaExpression(builder));
        assert (is IntegerExpression y
                = right.criteriaExpression(builder));
        return builder.mod(x, y);
    }
};

shared Predicate not(Predicate expression)
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.not(expression.criteriaExpression(builder));
};

shared Predicate or(Predicate+ predicates)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = predicates;
        variable value result
                = first.criteriaExpression(builder);
        for (next in rest) {
            return builder.or(result,
                next.criteriaExpression(builder));
        }
        return result;
    }
};

shared Predicate and(Predicate+ predicates)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = predicates;
        variable value result
                = first.criteriaExpression(builder);
        for (next in rest) {
            return builder.and(result,
                next.criteriaExpression(builder));
        }
        return result;
    }
};

alias BooleanExpression => CriteriaExpression<JBoolean>;

shared Predicate isTrue(Expression<Boolean> expression)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is BooleanExpression x
            = expression.criteriaExpression(builder));
        return builder.isTrue(x);
    }
};

shared Predicate isFalse(Expression<Boolean> expression)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is BooleanExpression x
                = expression.criteriaExpression(builder));
        return builder.isFalse(x);
    }
};

shared Predicate isNull(Expression<out Anything> expression)
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.isNull(expression.criteriaExpression(builder));
};

shared Predicate isNotNull(Expression<out Anything> expression)
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.isNotNull(expression.criteriaExpression(builder));
};

shared Predicate eq<T>(Expression<T> left, Expression<T> right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.equal(
            left.criteriaExpression(builder),
            right.criteriaExpression(builder));
};

shared Predicate ne<T>(Expression<T> left, Expression<T> right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.notEqual(
        left.criteriaExpression(builder),
        right.criteriaExpression(builder));
};

alias ComparableExpression
        => CriteriaExpression<JComparable<in Object>>;

shared Predicate lt<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String //TODO: |Date
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.lessThan(x,y);
    }
};

shared Predicate le<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String //TODO: |Date
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.lessThanOrEqualTo(x,y);
    }
};

shared Predicate gt<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String //TODO: |Date
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.greaterThan(x,y);
    }
};

shared Predicate ge<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String //TODO: |Date
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.greaterThanOrEqualTo(x,y);
    }
};

shared Expression<T> lit<T>(T literal)
        given T of Integer | Float | String | Boolean
                satisfies Object
        => object satisfies Expression<T> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.literal(toJava(literal));
};

shared Expression<T> param<T>(Class<T> type, String? name = null)
        given T of Integer | Float | String | Boolean
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(CriteriaBuilder builder) {
        value paramClass = Util.javaClass(type);
        if (exists name) {
            return builder.parameter(paramClass,name);
        }
        else {
            return builder.parameter(paramClass);
        }
    }
};

shared Selection<R> distinct<R>(Selection<R> selection)
        => object satisfies Selection<R> {
    criteriaSelection = selection.criteriaSelection;
    distinct => true;
};

shared class Criteria(manager) {
    
    EntityManager manager;
    CriteriaBuilder builder = manager.criteriaBuilder;
    CriteriaQuery<Object> criteriaQuery = builder.createQuery();

    shared Root<T> root<T>(Class<T> entity)
            given T satisfies Object
            => Root(criteriaQuery.from(entity));

    suppressWarnings("uncheckedTypeArguments")
    shared TypedQuery<R> query<R>(select, where=null, groupBy=null, having=null, orderBy=null)
            given R satisfies Object {

        Selection<R> select;
        Predicate? where;
        Grouping? groupBy;
        Predicate? having;
        Order? orderBy;

        assert (is CriteriaSelection<R> s
                = select.criteriaSelection(builder));
        criteriaQuery.select(s);
        criteriaQuery.distinct(select.distinct);
        if (exists where) {
            criteriaQuery.where(where.criteriaExpression(builder));
        }
        if (exists groupBy) {
            criteriaQuery.groupBy(*groupBy.criteriaExpressions(builder));
        }
        if (exists having) {
            criteriaQuery.where(having.criteriaExpression(builder));
        }
        if (exists orderBy) {
            criteriaQuery.orderBy(*orderBy.criteriaOrder(builder));
        }

        return TypedQuery<R>.withoutResultClass {
            manager.createQuery(criteriaQuery);
        };
    }
}
