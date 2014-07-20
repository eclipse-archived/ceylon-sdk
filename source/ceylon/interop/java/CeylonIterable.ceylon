import java.lang {
    JIterable=Iterable
}

"Adapts an instance of Java's `Iterable` to Ceylon's `Iterable`,
 allowing its elements to be iterated using `for`.
 
     for (int in CeylonIterable(Arrays.asList(ints))) {
         ...
     }"
shared class CeylonIterable<T>(JIterable<out T> iterable) 
        satisfies Iterable<T> {

    shared actual Iterator<T> iterator() {
        return CeylonIterator(iterable.iterator());
    }
    
}
