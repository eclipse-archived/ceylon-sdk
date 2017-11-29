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

//aggregation

shared sealed interface Grouping {
    shared formal CriteriaExpression<out Object>[]
    criteriaExpressions(CriteriaBuilder builder);
}

shared Grouping group(Grouping* groupings)
        => object satisfies Grouping {
    criteriaExpressions(CriteriaBuilder builder)
            => [for (g in groupings)
                for (cg in g.criteriaExpressions(builder))
                cg];
};