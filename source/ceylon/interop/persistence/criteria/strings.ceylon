import java.lang {
    JString=String
}
import javax.persistence.criteria {
    CriteriaPredicate=Predicate,
    CriteriaExpression=Expression,
    CriteriaBuilder
}

//String functions:

alias StringExpression => CriteriaExpression<JString>;

shared Predicate like(Expression<String> expression, String pattern, Character? escape=null)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        if (exists escape) {
            return builder.like(x, pattern, escape);
        }
        else {
            return builder.like(x, pattern);
        }
    }
};

shared Predicate notLike(Expression<String> expression, String pattern, Character? escape=null)
        => object satisfies Predicate {
    shared actual CriteriaPredicate criteriaExpression(
            CriteriaBuilder builder) {
        assert (is StringExpression x
                = expression.criteriaExpression(builder));
        if (exists escape) {
            return builder.notLike(x, pattern, escape);
        }
        else {
            return builder.notLike(x, pattern);
        }
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
