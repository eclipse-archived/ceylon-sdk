/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
            => builder.tuple(*selections
                    *.criteriaSelection(builder));

    shared Enumeration<T|E,T,Tuple<E,F,R>> with<T>(Selection<T> selection)
            => Enumeration<T|E,T,Tuple<E,F,R>>(selection, *selections);
}

shared Enumeration<T,T,[]> with<T>(Selection<T> selection)
        => Enumeration<T,T,[]>(selection);

shared Selection<[A,B]> with2<A,B>(Selection<A> first, Selection<B> second)
        => with(second).with(first);

shared Selection<[A,B,C]> with3<A,B,C>(Selection<A> first, Selection<B> second, Selection<C> third)
        => with(third).with(second).with(first);

shared Selection<[A,B,C,D]> with4<A,B,C,D>(Selection<A> first, Selection<B> second, Selection<C> third, Selection<D> fourth)
        => with(fourth).with(third).with(second).with(first);

shared Selection<[A,B,C,D,E]> with5<A,B,C,D,E>(Selection<A> first, Selection<B> second, Selection<C> third, Selection<D> fourth, Selection<E> fifth)
        => with(fifth).with(fourth).with(third).with(second).with(first);

shared Selection<[A,B,C,D,E,F]> with6<A,B,C,D,E,F>(Selection<A> first, Selection<B> second, Selection<C> third, Selection<D> fourth, Selection<E> fifth, Selection<F> sixth)
        => with(sixth).with(fifth).with(fourth).with(third).with(second).with(first);

shared Selection<R> distinct<R>(Selection<R> selection)
        => object satisfies Selection<R> {
    criteriaSelection = selection.criteriaSelection;
    distinct => true;
};
