import ceylon.language.meta.model {
    Attribute
}

import javax.persistence.criteria {
    CriteriaRoot=Root,
    CriteriaJoinType=JoinType,
    CriteriaFrom=From,
    CriteriaJoin=Join,
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

    CriteriaFetchParent<out Anything,T> criteriaFetchParent;

    shared Fetch<T,S> fetch<S>(Attribute<T,S|Collection<S>> attribute, JoinType type=JoinType.inner)
            given S satisfies Object
            => Fetch(criteriaFetchParent.fetch<T,S>(attribute.declaration.name, type.type));
}

shared abstract class From<out T>(criteriaFrom)
        of Root<T>
         | Join<Anything,T>
        extends FetchParent<T>(criteriaFrom)
        satisfies Selection<T>
        given T satisfies Object {

    CriteriaFrom<out Anything,T> criteriaFrom;

    shared Join<T,S> join<S>(Attribute<T,S|Collection<S>> attribute, JoinType type=JoinType.inner)
            given S satisfies Object
            => Join(criteriaFrom.join<T,S>(attribute.declaration.name, type.type));

    shared Expression<S> get<S>(Attribute<T,S,Nothing> attribute)
            => object satisfies Expression<S> {
        criteriaExpression(CriteriaBuilder builder)
                => criteriaFrom.get(attribute.declaration.name);
    };

    criteriaSelection(CriteriaBuilder builder)
            => criteriaFrom;
}

shared sealed class Root<out T>(CriteriaRoot<T> criteriaRoot)
        extends From<T>(criteriaRoot)
        given T satisfies Object {}

shared sealed class Join<out E,out T>(CriteriaJoin<E,T> criteriaJoin)
        extends From<T>(criteriaJoin)
        given T satisfies Object {}

shared sealed class Fetch<out E,out T>(CriteriaFetch<E,T> criteriaJoin)
        extends FetchParent<T>(criteriaJoin)
        given T satisfies Object {}
