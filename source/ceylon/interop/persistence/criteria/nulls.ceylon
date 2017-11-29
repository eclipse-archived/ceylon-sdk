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

//Functions for handling null values:

shared Expression<T?> coalesce<T>(Expression<T?>+ expressions)
        => object satisfies Expression<T?> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        let ([first, *rest] = expressions);
        variable value result = first.criteriaExpression(builder);
        for (next in rest) {
            result = builder.coalesce(result,
                next.criteriaExpression(builder));
        }
        return result;
    }
};

/*shared Expression<T?> nullIf<T>(Expression<T> expression, Expression<T> val)
        given T satisfies Object
        => object satisfies Expression<T?> {
    suppressWarnings("uncheckedTypeArguments")
    shared actual function criteriaExpression(CriteriaBuilder builder) {
        assert (is CriteriaExpression<Object> x
                = expression.criteriaExpression(builder));
        assert (is CriteriaExpression<Object> y
                = val.criteriaExpression(builder));
        return builder.nullif(x,y);
    }
};*/

