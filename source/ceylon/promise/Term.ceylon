"A term allows a [[Completable]] to be combined with a 
 promise to form a new term."
by("Julien Viet")
shared interface Term<out Element, out T>
        satisfies Completable<T>
            given T satisfies Element[] {
    
    "Combine the current term with a provided promise and 
     return a new term object that
     
     - fulfills when both the current term and the other 
       promise are fulfilled, and
     - rejects when either the current term or the other 
       promise is rejected.
     
     The `Term`'s promise will be
     
     - fulfilled with a tuple of values of the original 
       promise (it is important to notice that tuple 
       elements are in reverse order of the and chain), or
     - rejected with the reason of the rejected promise.
    
     The `Term` object allows for promise chaining as a 
     fluent API:
     
         Promise<String> p1 = ...
         Promise<Integer> p2 = ...
         Promise<Boolean> p3 = ...
         p1.and(p2, p3)
           .compose((Boolean b, Integer i, String s) 
                     => doSomething(b, i, s));"
    shared formal Term<Element|Other, Tuple<Element|Other, Other, T>> and<Other>(Promise<Other> other);

}