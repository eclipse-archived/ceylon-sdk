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

