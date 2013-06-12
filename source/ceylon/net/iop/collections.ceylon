import java.util { JIterator = Iterator }
import java.lang { JIterable = Iterable }

"Wraps a Java Iterator into a Ceylon Iterator"
by("Stéphane Épardaud")
shared class JavaIterator<T>(JIterator<T> iter) satisfies Iterator<T>{
    shared actual T|Finished next() {
        if(iter.hasNext()){
            return iter.next();
        } else {
            return finished;
        }
    }

}

"Wraps a Java Iterable into a Ceylon Iterable"
by("Stéphane Épardaud")
shared class JavaIterable<T>(JIterable<T> iterable) satisfies Iterable<T>{
    shared actual Boolean empty = iterable.iterator().hasNext();
    shared actual Iterator<T> iterator() {
        return JavaIterator(iterable.iterator());
    }
}

"Creates a Ceylon Iterable from a Java Iterable"
by("Stéphane Épardaud")
shared Iterable<T> toIterable<T>(JIterable<T> iterable){
    return JavaIterable<T>(iterable);
}
