import ceylon.language.meta.model {
    Class
}
import javax.persistence.criteria {
    CriteriaSelection=Selection,
    CriteriaBuilder
}

//projection

shared sealed interface Selection<out T> {
    shared formal CriteriaSelection<out Object>
    criteriaSelection(CriteriaBuilder builder);
    shared default Boolean distinct => false;
}

shared Selection<T> construct<T,A>(Class<T,A> type, Selection<A> select)
        given T satisfies Object
        => object satisfies Selection<T> {
    criteriaSelection(CriteriaBuilder builder)
            => builder.construct(type,
                *select.criteriaSelection(builder)
                                .compoundSelectionItems);
};

shared sealed class Enumeration<out E,out F,out R>(selections)
        satisfies Selection<Tuple<E,F,R>>
        given R satisfies Anything[] {

    Selection<E>* selections;

    criteriaSelection(CriteriaBuilder builder)
            => builder.tuple(for (s in selections)
                    s.criteriaSelection(builder));

    shared Enumeration<T|E,T,Tuple<E,F,R>> with<T>(Selection<T> selection)
            => Enumeration<T|E,T,Tuple<E,F,R>>(selection, *selections);
}

shared Enumeration<T,T,[]> with<T>(Selection<T> selection)
        => Enumeration<T,T,[]>(selection);

shared Selection<R> distinct<R>(Selection<R> selection)
        => object satisfies Selection<R> {
    criteriaSelection = selection.criteriaSelection;
    distinct => true;
};
