
import java.lang { JIterable=Iterable }
import java.util { JIterator=Iterator }

"Takes a Ceylon `Iterable` and turns it into a Java `Iterable`"
shared class JavaIterable<T>(Iterable<T> iter) satisfies JIterable<T> {

    shared actual JIterator<T> iterator() => JavaIterator(iter.iterator());

}
