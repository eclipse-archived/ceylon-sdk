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
