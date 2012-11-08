import java.util { List, LinkedList, JIterator = Iterator }
import java.lang { JIterable = Iterable }

by "Stéphane Épardaud"
doc "Wraps a Java Iterator into a Ceylon Iterator"
shared class JavaIterator<T>(JIterator<T> iter) satisfies Iterator<T>{
    shared actual T|Finished next() {
        if(iter.hasNext()){
            return iter.next();
        } else {
            return exhausted;
        }
    }

}

by "Stéphane Épardaud"
doc "Wraps a Java Iterable into a Ceylon Iterable"
shared class JavaIterable<T>(JIterable<T> iterable) satisfies Iterable<T>{
    shared actual Boolean empty = iterable.iterator().hasNext();
    shared actual Iterator<T> iterator {
        return JavaIterator(iterable.iterator());
    }
}

by "Stéphane Épardaud"
doc "Creates a Ceylon Iterable from a Java Iterable"
shared Iterable<T> toIterable<T>(JIterable<T> iterable){
    return JavaIterable<T>(iterable);
}
