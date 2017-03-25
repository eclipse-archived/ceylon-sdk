import java.lang {
    JComparable=Comparable,
    JInteger=Integer,
    JBoolean=Boolean,
    JNumber=Number,
    JString=String
}
import java.sql {
    Time,
    Date,
    Timestamp
}
import java.util {
    JDate=Date
}

import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaExpression=Expression,
    CriteriaBuilder
}
import ceylon.language.meta.model {
    Class
}

//Constant values:

shared Expression<T> lit<T>(T literal)
        given T of Integer | Float | String | Boolean
                satisfies Object
        => object satisfies Expression<T> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.literal(toJava(literal));
};

shared Expression<T> param<T>(Class<T> type, String? name = null)
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

//String functions:

alias StringExpression => CriteriaExpression<JString>;

shared Predicate like(Expression<String> expression, String pattern)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.like(x, pattern);
    }
};

shared Predicate notLike(Expression<String> expression, String pattern)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.notLike(x, pattern);
    }
};

shared Expression<Integer> locate(Expression<String> expression, String pattern, Integer position=0)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return position>0
        then builder.locate(x, pattern, position)
        else builder.locate(x, pattern);
    }
};

shared Expression<Integer> trim(Expression<String> expression, Character? character=null)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return if (exists character)
            then builder.trim(character,x)
            else builder.trim(x);
    }
};

shared Expression<Integer> trimLeading(Expression<String> expression, Character? character=null)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return if (exists character)
        then builder.trim(CriteriaBuilder.Trimspec.leading,character,x)
        else builder.trim(CriteriaBuilder.Trimspec.leading,x);
    }
};

shared Expression<Integer> trimTrailing(Expression<String> expression, Character? character=null)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return if (exists character)
        then builder.trim(CriteriaBuilder.Trimspec.trailing,character,x)
        else builder.trim(CriteriaBuilder.Trimspec.trailing,x);
    }
};

shared Expression<Integer> length(Expression<String> expression)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.length(x);
    }
};

shared Expression<String> upper(Expression<String> expression)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.upper(x);
    }
};

shared Expression<String> lower(Expression<String> expression)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.lower(x);
    }
};

shared Expression<String> concat(Expression<String>+ expressions)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        assert (is StringExpression x
                = first.criteriaExpression(builder));
        variable value result = x;
        for (next in rest) {
            assert (is StringExpression y
                    = next.criteriaExpression(builder));
            result = builder.concat(result, y);
        }
        return result;
    }
};

//Numeric functions:

alias NumericExpression => CriteriaExpression<JNumber>;
alias IntegerExpression => CriteriaExpression<JInteger>;

shared Expression<T> neg<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.neg(x);
    }
};

shared Expression<T> abs<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.abs(x);
    }
};

shared Expression<T> sqrt<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.sqrt(x);
    }
};

shared Expression<T> sqr<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.prod(x,x);
    }
};

shared Expression<T> scale<T>(T factor, Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        assert (is NumericExpression y
                = lit(factor).criteriaExpression(builder));
        return builder.prod(y,x);
    }
};

shared Expression<T> add<T>(Expression<T>+ expressions)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        assert (is NumericExpression x
                = first.criteriaExpression(builder));
        variable value result = x;
        for (next in rest) {
            assert (is NumericExpression y
                    = next.criteriaExpression(builder));
            result = builder.sum(result, y);
        }
        return result;
    }
};

shared Expression<T> mult<T>(Expression<T>+ expressions)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        value [first, *rest] = expressions;
        assert (is NumericExpression x
                = first.criteriaExpression(builder));
        variable value result = x;
        for (next in rest) {
            assert (is NumericExpression y
                    = next.criteriaExpression(builder));
            result = builder.prod(result, y);
        }
        return result;
    }
};

shared Expression<T> diff<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.diff(x, y);
    }
};

shared Expression<T> div<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = left.criteriaExpression(builder));
        assert (is NumericExpression y
                = right.criteriaExpression(builder));
        return builder.quot(x, y);
    }
};

shared Expression<Integer> mod(Expression<Integer> left, Expression<Integer> right)
        => object satisfies Expression<Integer> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is IntegerExpression x
                = left.criteriaExpression(builder));
        assert (is IntegerExpression y
                = right.criteriaExpression(builder));
        return builder.mod(x, y);
    }
};

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

shared Predicate isNull(Expression<out Anything> expression)
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.isNull(expression.criteriaExpression(builder));
};

shared Predicate isNotNull(Expression<out Anything> expression)
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.isNotNull(expression.criteriaExpression(builder));
};

//Equality:

shared Predicate eq<T>(Expression<T> left, Expression<T> right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.equal(
        left.criteriaExpression(builder),
        right.criteriaExpression(builder));
};

shared Predicate ne<T>(Expression<T> left, Expression<T> right)
        given T satisfies Object
        => object satisfies Predicate {
    criteriaExpression(CriteriaBuilder builder)
            => builder.notEqual(
        left.criteriaExpression(builder),
        right.criteriaExpression(builder));
};

//Comparison functions:

alias ComparableExpression => CriteriaExpression<JComparable<in Object>>;

shared Predicate between<T>(Expression<T> expression, Expression<T> lowerBound, Expression<T> upperBound)
        given T of Integer | Float | String
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is ComparableExpression x
                = expression.criteriaExpression(builder),
            is ComparableExpression l
                    = lowerBound.criteriaExpression(builder),
            is ComparableExpression u
                    = upperBound.criteriaExpression(builder));
        return builder.between(x,l, u);
    }
};

shared Predicate lt<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String
                satisfies Comparable<T>
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

shared Predicate le<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.lessThanOrEqualTo(x,y);
    }
};

shared Predicate gt<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String
                satisfies Comparable<T>
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

shared Predicate ge<T>(Expression<T> left, Expression<T> right)
        given T of Integer | Float | String
                satisfies Comparable<T>
        => object satisfies Predicate {
    suppressWarnings("uncheckedTypeArguments")
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (
            is ComparableExpression x
                    = left.criteriaExpression(builder),
            is ComparableExpression y
                    = right.criteriaExpression(builder));
        return builder.greaterThanOrEqualTo(x,y);
    }
};

//Dates and times:

shared Expression<Date> currentDate
        => object satisfies Expression<Date> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.currentDate();
};
shared Expression<Time> currentTime
        => object satisfies Expression<Time> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.currentTime();
};
shared Expression<Timestamp> currentTimestamp
        => object satisfies Expression<Timestamp> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.currentTimestamp();
};

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

//Aggregate functions:

shared Expression<Integer> count(Expression<out Anything> expression)
        => object satisfies Expression<Integer> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.count(expression.criteriaExpression(builder));
};

shared Expression<Integer> countDistinct(Expression<out Anything> expression)
        => object satisfies Expression<Integer> {
    criteriaExpression(CriteriaBuilder builder)
            => builder.countDistinct(expression.criteriaExpression(builder));
};

shared Expression<T> max<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.max(x);
    }
};

shared Expression<T> min<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.max(x);
    }
};

shared Expression<T> sum<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Object
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.sum(x);
    }
};

shared Expression<T> avg<T>(Expression<T> expression)
        given T of Integer | Float
                satisfies Number<T>
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is NumericExpression x
                = expression.criteriaExpression(builder));
        return builder.avg(x);
    }
};

shared Expression<String> greatest(Expression<String> expression)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.greatest(x);
    }
};

shared Expression<String> least(Expression<String> expression)
        => object satisfies Expression<String> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        return builder.greatest(x);
    }
};

shared Expression<T> latest<T>(Expression<T> expression)
        given T of Date | Time | Timestamp
                satisfies JDate
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is ComparableExpression x
                = expression.criteriaExpression(builder));
        return builder.greatest(x);
    }
};

shared Expression<T> earliest<T>(Expression<T> expression)
        given T of Date | Time | Timestamp
                satisfies JDate
        => object satisfies Expression<T> {
    shared actual function criteriaExpression(
            CriteriaBuilder builder) {
        assert (is ComparableExpression x
                = expression.criteriaExpression(builder));
        return builder.least(x);
    }
};
