/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.interop.persistence.util {
    toJava
}

import java.lang {
    JNumber=Number,
    JBoolean=Boolean
}

import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaExpression=Expression,
    CriteriaBuilder
}

//selection

shared sealed interface Expression<T>
        satisfies Selection<T>
                & Grouping {

    shared formal CriteriaExpression<out Object>
    criteriaExpression(CriteriaBuilder builder);

    criteriaSelection(CriteriaBuilder builder)
            => criteriaExpression(builder);

    criteriaExpressions(CriteriaBuilder builder)
            => [criteriaExpression(builder)];

    shared Predicate equalTo(T val)
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.equal(outer.criteriaExpression(builder),
                    toJava(val));
    };

    shared Predicate notEqualTo(T val)
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.notEqual(outer.criteriaExpression(builder),
                    toJava(val));
    };

    shared Predicate inValues(T+ values)
            => object satisfies Predicate {
        shared actual CriteriaPredicate criteriaExpression(CriteriaBuilder builder) {
            value result = builder.\iin(outer.criteriaExpression(builder));
            for (v in values) {
                result.\ivalue(toJava(v));
            }
            return result;
        }
    };

    shared Predicate null
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.isNull(outer.criteriaExpression(builder));
    };

    shared Predicate notNull
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.isNotNull(outer.criteriaExpression(builder));
    };

    shared Expression<T?> nullIf(T val)
            => object satisfies Expression<T?> {
        suppressWarnings("uncheckedTypeArguments")
        shared actual function criteriaExpression(CriteriaBuilder builder) {
            assert (is CriteriaExpression<Object> x
                    = outer.criteriaExpression(builder));
            return builder.nullif(x,toJava(val));
        }
    };

    shared Expression<T&Object> coalesce(T&Object val)
            => object satisfies Expression<T&Object> {
        criteriaExpression(CriteriaBuilder builder)
                => builder.coalesce(outer.criteriaExpression(builder),
                    toJava(val));
    };

}

shared sealed interface Predicate
        satisfies Expression<Boolean> {
    shared actual formal CriteriaPredicate
    criteriaExpression(CriteriaBuilder builder);
}

shared Predicate predicate(Expression<Boolean> expression)
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is CriteriaExpression<JBoolean> x
                = expression.criteriaExpression(builder));
        return builder.isTrue(x);
    }
};

shared sealed interface Numeric<T>
        satisfies Expression<T>
        given T of Integer | Float
                satisfies Number<T> {
    suppressWarnings("uncheckedTypeArguments")
    function numericExpression(CriteriaBuilder builder) {
        assert (is NumericExpression result = criteriaExpression(builder));
        return result;
    }
    shared Numeric<T> plus(T t)
            => object satisfies Numeric<T> {
        shared actual function criteriaExpression(CriteriaBuilder builder) {
            assert (is JNumber y = toJava(t));
            return builder.sum(numericExpression(builder), y);
        }
    };
    shared Numeric<T> minus(T t)
            => object satisfies Numeric<T> {
        shared actual function criteriaExpression(CriteriaBuilder builder) {
            assert (is JNumber y = toJava(t));
            return builder.diff(numericExpression(builder), y);
        }
    };
    shared Numeric<T> times(T t)
            => object satisfies Numeric<T> {
        shared actual function criteriaExpression(CriteriaBuilder builder) {
            assert (is JNumber y = toJava(t));
            return builder.prod(numericExpression(builder), y);
        }
    };
    shared Numeric<T> divide(T t)
            => object satisfies Numeric<T> {
        shared actual function criteriaExpression(CriteriaBuilder builder) {
            assert (is JNumber y = toJava(t));
            return builder.quot(numericExpression(builder), y);
        }
    };
}

shared Numeric<T> numeric<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Numeric<T> {
    criteriaExpression(CriteriaBuilder builder)
            => expression.criteriaExpression(builder);
};