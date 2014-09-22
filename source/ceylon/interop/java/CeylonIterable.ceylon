import java.lang {
    JIterable=Iterable
}

"A Ceylon [[Iterable]] that adapts an instance of Java's 
 [[java.lang::Iterable]], allowing its elements to be 
 iterated using a `for` loop.
     
     IntArray ints = ... ;
     for (int in CeylonIterable(Arrays.asList(*ints.array))) {
         ...
     }"
shared class CeylonIterable<T>(JIterable<out T> iterable) 
        satisfies Iterable<T> {
    iterator() => CeylonIterator(iterable.iterator());    
}
