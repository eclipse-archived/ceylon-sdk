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
    CriteriaOrder=Order,
    CriteriaBuilder
}

//ordering

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
