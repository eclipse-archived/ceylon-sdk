import java.lang {
    JIterable=Iterable
}

"A Ceylon [[Iterable]] that adapts an instance of Java's 
 [[java.lang::Iterable]], allowing its elements to be 
 iterated using a `for` loop.
     
     IntArray ints = ... ;
     for (int in CeylonIterable(Arrays.asList(*ints.array))) {
         ...
     }
     
 **Note**: Since Ceylon 1.2.1 it is possible to use 
 [[java.lang::Iterable]] directly in a Ceylon `for` statement:
 
     JavaIterable<Foo> iterable = ... ;
     for (foo in iterable) {
         ...
     }
 "
shared class CeylonIterable<T>(JIterable<out T> iterable) 
        satisfies Iterable<T> {
    iterator() => CeylonIterator(iterable.iterator());    
}
