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