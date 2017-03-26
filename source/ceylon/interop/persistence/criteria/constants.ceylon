import ceylon.language.meta.model {
    Class
}

import javax.persistence.criteria {
    CriteriaBuilder
}
import ceylon.interop.persistence.util {
    toJava,
    Util
}

//Constant values:

shared Expression<T> literal<T>(T literal)
        given T of Integer | Float | String | Boolean
                satisfies Object
        => object satisfies Expression<T> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.literal(toJava(literal));
};

shared Expression<T> parameter<T>(Class<T> type, String? name = null)
        given T of Integer | Float | String | Boolean
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(CriteriaBuilder builder) {
        value paramClass = Util.javaClass(type);
        if (exists name) {
            return builder.parameter(paramClass,name);
        }
        else {
            return builder.parameter(paramClass);
        }
    }
};
