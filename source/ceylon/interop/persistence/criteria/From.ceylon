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
    Attribute
}

import java.util {
    Map,
    List,
    Set,
    Collection
}

import javax.persistence.criteria {
    CriteriaRoot=Root,
    CriteriaJoinType=JoinType,
    CriteriaFrom=From,
    CriteriaJoin=Join,
    CriteriaMapJoin=MapJoin,
    CriteriaListJoin=ListJoin,
    CriteriaSetJoin=SetJoin,
    CriteriaFetch=Fetch,
    CriteriaFetchParent=FetchParent,
    CriteriaBuilder
}

//joins and products, fetching

shared class JoinType {
    shared CriteriaJoinType type;
    shared new inner {
        type => CriteriaJoinType.inner;
    }
    shared new left {
        type => CriteriaJoinType.left;
    }
    shared new right {
        type => CriteriaJoinType.right;
    }
}

shared abstract class FetchParent<out T>(criteriaFetchParent)
        of From<T>
         | Fetch<Anything,T>
        given T satisfies Object {

    shared CriteriaFetchParent<out Anything,out T> criteriaFetchParent;

    shared Fetch<T,S> fetch<S>(Attribute<T,S> attribute, JoinType type=JoinType.inner)
            given S satisfies Object
            => Fetch(criteriaFetchParent.fetch<T,S>(attribute.declaration.name, type.type));

    shared Fetch<T,S> fetchCollection<S>(Attribute<T,Collection<S>> attribute, JoinType type=JoinType.inner)
            given S satisfies Object
            => Fetch(criteriaFetchParent.fetch<T,S>(attribute.declaration.name, type.type));

}

shared abstract class From<out T>(criteriaFrom)
        of Root<T>
         | Join<Object,T>
        extends FetchParent<T>(criteriaFrom)
        satisfies Selection<T>
        given T satisfies Object {

    shared CriteriaFrom<out Anything,out T> criteriaFrom;

    shared Join<T,S> join<S>(Attribute<T,S> attribute, JoinType type=JoinType.inner)
            given S satisfies Object
            => Join(criteriaFrom.join<T,S>(attribute.declaration.name, type.type));

    shared Join<T,S> joinCollection<S>(Attribute<T,Collection<S>> attribute, JoinType type=JoinType.inner)
            given S satisfies Object
            => Join(criteriaFrom.joinCollection<T,S>(attribute.declaration.name, type.type));

    shared MapJoin<T,K,V> joinMap<K,V>(Attribute<T,Map<K,V>> attribute, JoinType type=JoinType.inner)
            given K satisfies Object
            given V satisfies Object
            => MapJoin(criteriaFrom.joinMap<T,K,V>(attribute.declaration.name, type.type));

    shared SetJoin<T,V> joinSet<V>(Attribute<T,Set<V>> attribute, JoinType type=JoinType.inner)
            given V satisfies Object
            => SetJoin(criteriaFrom.joinSet<T,V>(attribute.declaration.name, type.type));

    shared ListJoin<T,V> joinList<V>(Attribute<T,List<V>> attribute, JoinType type=JoinType.inner)
            given V satisfies Object
            => ListJoin(criteriaFrom.joinList<T,V>(attribute.declaration.name, type.type));

    shared Expression<S> get<S>(Attribute<T,S> attribute)
            => object satisfies Expression<S> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaFrom.get(attribute.declaration.name);
    };

    criteriaSelection(CriteriaBuilder builder)
            => criteriaFrom;
}

shared sealed class Root<out T>(criteriaRoot)
        extends From<T>(criteriaRoot)
        given T satisfies Object {
    CriteriaRoot<T> criteriaRoot;
}

shared sealed class Join<out E,out T>(criteriaJoin)
        extends From<T>(criteriaJoin)
        given E satisfies Object
        given T satisfies Object {
    CriteriaJoin<E,T> criteriaJoin;
}

shared sealed class MapJoin<out E,out K,out V>(criteriaJoin)
        extends Join<E,V>(criteriaJoin)
        given E satisfies Object
        given K satisfies Object
        given V satisfies Object {
    CriteriaMapJoin<E,K,V> criteriaJoin;
    shared Expression<out K> key
            => object satisfies Expression<K> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaJoin.key();
    };
    shared Expression<out V> item
            => object satisfies Expression<V> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaJoin.\ivalue();
    };
    shared Expression<out Map.Entry<out K,out V>> entry
            => object satisfies Expression<Map.Entry<K,V>> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaJoin.entry();
    };
}

shared sealed class ListJoin<out E,out T>(criteriaJoin)
        extends Join<E,T>(criteriaJoin)
        given E satisfies Object
        given T satisfies Object {
    CriteriaListJoin<E,T> criteriaJoin;
    shared Expression<Integer> index
            => object satisfies Expression<Integer> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaJoin.index();
    };
}

shared sealed class SetJoin<out E,out T>(criteriaJoin)
        extends Join<E,T>(criteriaJoin)
        given E satisfies Object
        given T satisfies Object {
    CriteriaSetJoin<E,T> criteriaJoin;
}

shared sealed class Fetch<out E,out T>(criteriaJoin)
        extends FetchParent<T>(criteriaJoin)
        given T satisfies Object {
    CriteriaFetch<E,T> criteriaJoin;
}
