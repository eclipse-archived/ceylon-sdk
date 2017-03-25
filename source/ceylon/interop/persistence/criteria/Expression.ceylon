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

    shared Predicate equalTo(T val)
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.equal(outer.criteriaExpression(builder), val);
    };

    shared Predicate notEqualTo(T val)
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.notEqual(outer.criteriaExpression(builder), val);
    };

    shared Predicate inValues(T+ values)
            => object satisfies Predicate {
        shared actual CriteriaPredicate criteriaExpression(CriteriaBuilder builder) {
            value result = builder.\iin(outer.criteriaExpression(builder));
            for (v in values) {
                result.\ivalue(v);
            }
            return result;
        }
    };

    shared Predicate null
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.isNull(outer.criteriaExpression(builder));
    };

    shared Predicate notNull
            => object satisfies Predicate {
        criteriaExpression(CriteriaBuilder builder)
                => builder.isNotNull(outer.criteriaExpression(builder));
    };

    shared Expression<T?> nullIf(T val)
            => object satisfies Expression<T?> {
        suppressWarnings("uncheckedTypeArguments")
        shared actual function criteriaExpression(CriteriaBuilder builder) {
            assert (is CriteriaExpression<Object> x
                    = outer.criteriaExpression(builder));
            return builder.nullif(x,val of Object?);
        }
    };

    shared Expression<T&Object> coalesce(T&Object val)
            => object satisfies Expression<T&Object> {
        criteriaExpression(CriteriaBuilder builder)
                => builder.coalesce(outer.criteriaExpression(builder),val);
    };

}

shared sealed interface Predicate
        satisfies Expression<Boolean> {
    shared actual formal CriteriaPredicate
    criteriaExpression(CriteriaBuilder builder);
}

