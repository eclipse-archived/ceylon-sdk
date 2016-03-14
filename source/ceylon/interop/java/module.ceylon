"A set of adaptors for types belonging to the Java language
 or Java SDK. Includes:
 
 - a set of functions for converting between Ceylon's 
   [[Array]] class and Java array types, for example,
   [[javaIntArray]], [[javaFloatArray]], [[javaByteArray]],
   [[javaBooleanArray]], [[javaObjectArray]], and
   [[javaStringArray]],
 - classes adapting Java collection types to Ceylon 
   collection interfaces: [[CeylonList]], [[CeylonSet]], 
   [[CeylonMap]],
 - classes adapting Ceylon collection types to Java 
   collection interfaces: [[JavaList]], [[JavaSet]],
   [[JavaMap]], and
 - [[CeylonIterable]] and [[JavaIterable]] which adapt 
   between Java's [[java.lang::Iterable]] interface and 
   Ceylon's [[Iterable]] interface,
 - [[CeylonStringIterable]], [[CeylonIntegerIterable]],
   [[CeylonFloatIterable]], [[CeylonByteIterable]], and
   [[CeylonBooleanIterable]], which adapt Java 
   [[java.lang::Iterable]]s of primitive types, 
 - [[JavaRunnable]] and [[JavaThread]] which adapt Ceylon
   functions to Java's [[java.lang::Runnable]] and 
   [[java.lang::Thread]], and
 - [[JavaCloseable]] and [[CeylonDestroyable]] which adapt
   between [[java.lang::AutoCloseable]] and [[Destroyable]].
   
 In addition, the functions [[javaClass]] and 
 [[javaClassFromInstance]] allow Ceylon programs to obtain
 an instance of [[java.lang::Class]]."
by("The Ceylon Team")
native("jvm")
module ceylon.interop.java "1.2.3" {
    shared import java.base "7";
    shared import ceylon.collection "1.2.3";
}
