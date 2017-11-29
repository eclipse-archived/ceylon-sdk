/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.lang {
    JComparable=Comparable
}
import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaExpression=Expression,
    CriteriaBuilder
}

//Equality:

shared Predicate equal<T>(Expression<T> left, Expression<T> right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.equal(
        left.criteriaExpression(builder),
        right.criteriaExpression(builder));
};

shared Predicate notEqual<T>(Expression<T> left, Expression<T> right)
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

shared Predicate less<T>(Expression<T> left, Expression<T> right)
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

shared Predicate lessOrEqual<T>(Expression<T> left, Expression<T> right)
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

shared Predicate greater<T>(Expression<T> left, Expression<T> right)
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

shared Predicate greaterOrEqual<T>(Expression<T> left, Expression<T> right)
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