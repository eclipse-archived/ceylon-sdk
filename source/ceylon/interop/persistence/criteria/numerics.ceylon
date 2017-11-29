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
    CriteriaExpression=Expression,
    CriteriaBuilder
}
import java.lang {
    JInteger=Integer,
    JNumber=Number
}

//Numeric functions:

alias NumericExpression => CriteriaExpression<JNumber>;
alias IntegerExpression => CriteriaExpression<JInteger>;

shared Expression<T> negative<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
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
    suppressWarnings("uncheckedTypeArguments")
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
    suppressWarnings("uncheckedTypeArguments")
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
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.prod(x,x);
    }
};

//shared Expression<T> scale<T>(T factor, Expression<T> expression)
//        given T of Integer | Float
//                satisfies Object
//        => object satisfies Expression<T> {
//    shared actual function criteriaExpression(
//            CriteriaBuilder builder) {
//        assert (is NumericExpression x
//                = expression.criteriaExpression(builder));
//        assert (is NumericExpression y
//                = lit(factor).criteriaExpression(builder));
//        return builder.prod(y,x);
//    }
//};

shared Expression<T> add<T>(Expression<T>+ expressions)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        let ([first, *rest] = expressions);
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

shared Expression<T> multiply<T>(Expression<T>+ expressions)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        let ([first, *rest] = expressions);
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

shared Expression<T> subtract<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.diff(x, y);
    }
};

shared Expression<T> divide<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.quot(x, y);
    }
};

shared Expression<Integer> remainder(Expression<Integer> left, Expression<Integer> right)
        => object satisfies Expression<Integer> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is IntegerExpression x
                = left.criteriaExpression(builder));
        assert (is IntegerExpression y
                = right.criteriaExpression(builder));
        return builder.mod(x, y);
    }
};
