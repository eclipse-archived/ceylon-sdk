doc "A selection of utility methods to improve Java interoperability.

    The following methods exist:

     - `javaString(String string)` - takes a Ceylon String and turns it into a Java String
     - `createByteArray(Integer size)` - creates a `byte` array of the given size
     - `createShortArray(Integer size)` - creates a `short` array of the given size
     - `createIntArray(Integer size)` - creates an `int` array of the given size
     - `createFloatArray(Integer size)` - creates a `float` array of the given size
     - `createCharArray(Integer size)` - creates a `char` array of the given size
"
by "The Ceylon Team"
module ceylon.interop.java '0.5' {
    import ceylon.language '0.5';
}
