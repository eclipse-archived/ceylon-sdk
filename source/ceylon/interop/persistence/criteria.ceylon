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
    CriteriaPredicate=Predicate
}

shared sealed interface Selection<out T> {
    shared formal CriteriaSelection<out Object>
        criteriaSelection(CriteriaBuilder builder);
}

shared Selection<T> construct<T,A>(Class<T,A> type, Selection<A> select)
    given T satisfies Object
    => object satisfies Selection<T> {
        criteriaSelection(CriteriaBuilder builder)
                => builder.construct(type,
                *select.criteriaSelection(builder)
                            .compoundSelectionItems);
};

shared sealed interface Expression<T> satisfies Selection<T> {
    shared formal CriteriaExpression<out Object> criteriaExpression(
            CriteriaBuilder builder);
    criteriaSelection(CriteriaBuilder builder)
            => criteriaExpression(builder);
}

shared sealed interface Predicate
        satisfies Expression<Boolean> {
    shared actual formal CriteriaPredicate
        criteriaExpression(CriteriaBuilder builder);
}

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

    shared Expression<S> att<S>(Attribute<T,S,Nothing> attribute)
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

shared Expression<String> concat(Expression<String> left, Expression<String> right)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = left.criteriaExpression(builder));
        assert (is StringExpression y
                = right.criteriaExpression(builder));
        return builder.concat(x, y);
    }
};

alias NumericExpression => CriteriaExpression<JNumber>;

shared Expression<T> neg<T>(Expression<T> expression)
        given T of Integer | Float
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
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.sqrt(x);
    }
};

shared Expression<T> sum<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.sum(x, y);
    }
};

shared Expression<T> prod<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.prod(x, y);
    }
};

shared Expression<T> diff<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
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

shared Expression<T> quot<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
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

shared Predicate not<T>(Predicate expression)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.not(expression.criteriaExpression(builder));
};

shared Predicate or<T>(Predicate left, Predicate right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.or(
                left.criteriaExpression(builder),
                right.criteriaExpression(builder));
};

shared Predicate and<T>(Predicate left, Predicate right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.or(
                left.criteriaExpression(builder),
                right.criteriaExpression(builder));
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

shared Predicate isNull<T>(Expression<T?> expression)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.isNull(expression.criteriaExpression(builder));
};

shared Predicate isNotNull<T>(Expression<T?> expression)
        given T satisfies Object
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
        given T of Integer|Float|String //TODO: |Date
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
        given T of Integer|Float|String //TODO: |Date
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
        given T of Integer|Float|String //TODO: |Date
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
        given T of Integer|Float|String //TODO: |Date
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
        given T of Integer|Float|String|Boolean
                satisfies Object
        => object satisfies Expression<T> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.literal(toJava(literal));
};

shared Expression<T> param<T>(Class<T> type, String? name = null)
        given T of Integer|Float|String|Boolean
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

shared class Criteria(manager) {
    
    EntityManager manager;
    CriteriaBuilder builder = manager.criteriaBuilder;
    CriteriaQuery<Object> criteriaQuery = builder.createQuery();

    shared Root<T> root<T>(Class<T> entity)
            given T satisfies Object
            => Root(criteriaQuery.from(entity));

    suppressWarnings("uncheckedTypeArguments")
    shared TypedQuery<R> query<R>(select, distinct=true, where = null)
            given R satisfies Object {

        Selection<R> select;
        Boolean distinct;
        Predicate? where;

        assert (is CriteriaSelection<R> s
                = select.criteriaSelection(builder));
        criteriaQuery.select(s);
        criteriaQuery.distinct(distinct);
        if (exists where) {
            criteriaQuery.where(where.criteriaExpression(builder));
        }

        return TypedQuery<R>.withoutResultClass {
            manager.createQuery(criteriaQuery);
        };
    }
}
