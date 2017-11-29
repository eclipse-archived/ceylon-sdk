/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import javax.persistence.criteria {
    CriteriaBuilder
}
import java.util {
    JDate=Date
}
import java.sql {
    Time,
    Date,
    Timestamp
}

//Aggregate functions:

shared Expression<Integer> count(Expression<out Anything> expression)
        => object satisfies Expression<Integer> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.count(expression.criteriaExpression(builder));
};

shared Expression<Integer> countDistinct(Expression<out Anything> expression)
        => object satisfies Expression<Integer> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.countDistinct(expression.criteriaExpression(builder));
};

shared Expression<T> max<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.max(x);
    }
};

shared Expression<T> min<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.max(x);
    }
};

shared Expression<T> sum<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.sum(x);
    }
};

shared Expression<T> average<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.avg(x);
    }
};

shared Expression<String> greatest(Expression<String> expression)
        => object satisfies Expression<String> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.greatest(x);
    }
};

shared Expression<String> least(Expression<String> expression)
        => object satisfies Expression<String> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.greatest(x);
    }
};

shared Expression<T> latest<T>(Expression<T> expression)
        given T of Date | Time | Timestamp
                satisfies JDate
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is ComparableExpression x
                = expression.criteriaExpression(builder));
        return builder.greatest(x);
    }
};

shared Expression<T> earliest<T>(Expression<T> expression)
        given T of Date | Time | Timestamp
                satisfies JDate
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is ComparableExpression x
                = expression.criteriaExpression(builder));
        return builder.least(x);
    }
};
