import java.util {
    JDate=Date
}
import java.sql {
    Time,
    Date,
    Timestamp
}
import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaBuilder
}

//Dates and times:

shared object current {

    shared Expression<Date> date
            => object satisfies Expression<Date> {
        criteriaExpression(CriteriaBuilder builder)
                => builder.currentDate();
    };

    shared Expression<Time> time
            => object satisfies Expression<Time> {
        criteriaExpression(CriteriaBuilder builder)
                => builder.currentTime();
    };

    shared Expression<Timestamp> timestamp
            => object satisfies Expression<Timestamp> {
        criteriaExpression(CriteriaBuilder builder)
                => builder.currentTimestamp();
    };
}

shared Predicate after<T>(Expression<T> left, Expression<T> right)
        given T of Date | Time | Timestamp
                satisfies JDate
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.greaterThan(x,y);
    }
};

shared Predicate before<T>(Expression<T> left, Expression<T> right)
        given T of Date | Time | Timestamp
                satisfies JDate
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.lessThan(x,y);
    }
};
