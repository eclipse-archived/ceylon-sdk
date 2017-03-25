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

}

shared sealed interface Predicate
        satisfies Expression<Boolean> {
    shared actual formal CriteriaPredicate
    criteriaExpression(CriteriaBuilder builder);
}

