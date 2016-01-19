import java.lang {
    JString=String,
    JLong=Long,
    JInteger=Integer,
    JShort=Short,
    JDouble=Double,
    JFloat=Float,
    JByte=Byte,
    JBoolean=Boolean,
    JIterable=Iterable
}

"A Ceylon [[Iterable]]`<ceylon.language::String>` that adapts an instance of Java's 
   [[`java.lang::Iterable`|java.lang::Iterable]]`<java.lang::String>`, allowing its elements to be 
   iterated using a `for` loop."
shared class CeylonStringIterable(JIterable<out JString> iterable) 
        satisfies {String*} {
    iterator() => object satisfies Iterator<String> {
        value iterator = iterable.iterator();
        shared actual String|Finished next() { 
            if (iterator.hasNext()) {
                assert (exists next = iterator.next());
                return next.string;
            } else {
                return finished;
            }
        }
    };
}

"A Ceylon [[Iterable]]`<ceylon.language::Integer>` that adapts an instance of Java's 
 [[`java.lang::Iterable`|Iterable]]`<java.lang::Long>`, 
 `java.lang::Iterable<java.lang::Integer>` or
 `java.lang::Iterable<java.lang::Short>` allowing its elements to be 
 iterated using a `for` loop."
shared class CeylonIntegerIterable(JIterable<out JLong|JInteger|JShort> iterable) 
        satisfies {Integer*} {
    iterator() => object satisfies Iterator<Integer> {
        value iterator = iterable.iterator();
        shared actual Integer|Finished next() { 
            if (iterator.hasNext()) {
                assert (exists next = iterator.next());
                return next.longValue();
            } else {
                return finished;
            }
        }
    };
}

"A Ceylon [[Iterable]]`<ceylon.language::Float>` that adapts an instance of Java's 
 [[`java.lang::Iterable`|java.lang::Iterable]]`<java.lang::Double>` or
 `java.lang::Iterable<java.lang::Float>`, allowing its elements to be 
 iterated using a `for` loop.
 "
shared class CeylonFloatIterable(JIterable<out JDouble|JFloat> iterable) 
        satisfies {Float*} {
    iterator() => object satisfies Iterator<Float> {
        value iterator = iterable.iterator();
        shared actual Float|Finished next() { 
            if (iterator.hasNext()) {
                assert (exists next = iterator.next());
                return next.doubleValue();
            } else {
                return finished;
            }
        }
    };
}

"A Ceylon [[Iterable]]`<ceylon.language::Byte>` that adapts an instance of Java's 
 [[`java.lang::Iterable`|java.lang::Iterable]]`<java.lang::Byte>`, allowing its elements to be 
 iterated using a `for` loop.
 "
shared class CeylonByteIterable(JIterable<out JByte> iterable) 
        satisfies {Byte*} {
    iterator() => object satisfies Iterator<Byte> {
        value iterator = iterable.iterator();
        shared actual Byte|Finished next() { 
            if (iterator.hasNext()) {
                assert (exists next = iterator.next());
                return next.byteValue();
            } else {
                return finished;
            }
        }
    };
}

"A Ceylon [[Iterable]]`<ceylon.language::Boolean>` that adapts an instance of Java's 
 [[`java.lang::Iterable`|java.lang::Iterable]]`<java.lang::Boolean>`, allowing its elements to be 
 iterated using a `for` loop.
 "
shared class CeylonBooleanIterable(JIterable<out JBoolean> iterable) 
        satisfies {Boolean*} {
    iterator() => object satisfies Iterator<Boolean> {
        value iterator = iterable.iterator();
        shared actual Boolean|Finished next() { 
            if (iterator.hasNext()) {
                assert (exists next = iterator.next());
                return next.booleanValue();
            } else {
                return finished;
            }
        }
    };
}

