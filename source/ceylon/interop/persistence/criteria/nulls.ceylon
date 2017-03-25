import javax.persistence.criteria {
    CriteriaBuilder
}

//Functions for handling null values:

shared Expression<T?> coalesce<T>(Expression<T?>+ expressions)
        => object satisfies Expression<T?> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        variable value result = first.criteriaExpression(builder);
        for (next in rest) {
            result = builder.coalesce(result,
                next.criteriaExpression(builder));
        }
        return result;
    }
};
