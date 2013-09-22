"A selection of utility methods to improve Java interoperability.
 
 The following methods and types exist:
 
 - `javaString(String string)` - takes a Ceylon String and turns it into a Java String
 - `JavaIterator<T>(Iterator<T> iter)` - takes a Ceylon Iterator and turns it into a Java Iterator
 - `JavaIterable<T>(Iterable<T> iter)` - takes a Ceylon Iterable and turns it into a Java Iterable
 - `CeylonIterator<T>(JIterator<T> iter)` - takes a Java Iterator and turns it into a Ceylon Iterator
 - `CeylonIterable<T>(JIterable<T> iter)` - takes a Java Iterable and turns it into a Ceylon Iterable
 - `JavaCollection({T*} items)` - takes a Ceylon list of items and turns them into a Java Collection
 - `javaClass<T>()` - returns the Java Class reference for type T
 - `javaClass(Object obj)` - takes a class instance and returns a Java Class reference for its type
 "
by("The Ceylon Team")
module ceylon.interop.java '0.6.1' {
    import ceylon.language '0.6.1';
    shared import java.base '7';
}
