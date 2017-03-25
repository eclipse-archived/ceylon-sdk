import java.lang {
    JBoolean=Boolean
}

import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaExpression=Expression,
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

//Predicates:

alias BooleanExpression => CriteriaExpression<JBoolean>;

shared Predicate isTrue(Expression<Boolean> expression)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is BooleanExpression x
                = expression.criteriaExpression(builder));
        return builder.isTrue(x);
    }
};

shared Predicate isFalse(Expression<Boolean> expression)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is BooleanExpression x
                = expression.criteriaExpression(builder));
        return builder.isFalse(x);
    }
};
