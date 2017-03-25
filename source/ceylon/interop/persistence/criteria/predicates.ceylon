import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
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

