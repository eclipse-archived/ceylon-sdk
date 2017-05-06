import ceylon.interop.persistence.util {
    toJava
}

import javax.persistence.criteria {
    CriteriaBuilder
}

//Constant values:

shared Expression<T> literal<T>(T literal)
        given T of Integer | Float | String | Boolean
                satisfies Object
        => object satisfies Expression<T> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.literal(toJava(literal));
};
