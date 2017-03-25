import java.lang {
    JComparable=Comparable,
    JBoolean=Boolean
}
import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaExpression=Expression,
    CriteriaBuilder
}

//Logical operators:

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

//Predicates:

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

//Equality:

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

//Comparison functions:

alias ComparableExpression => CriteriaExpression<JComparable<in Object>>;

shared Predicate between<T>(Expression<T> expression, Expression<T> lowerBound, Expression<T> upperBound)
        given T of Integer | Float | String
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is ComparableExpression x
                = expression.criteriaExpression(builder),
            is ComparableExpression l
                    = lowerBound.criteriaExpression(builder),
            is ComparableExpression u
                    = upperBound.criteriaExpression(builder));
        return builder.between(x,l, u);
    }
};

shared Predicate lt<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String
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
        given T of Integer | Float | String
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
        given T of Integer | Float | String
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
        given T of Integer | Float | String
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