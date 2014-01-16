import java.lang {
    Byte,
    Short,
    Int=Integer,
    Long,
    Single=Float,
    Double,
    System {
        arraycopy
    },
    arrays,
    FloatArray,
    DoubleArray,
    ByteArray,
    ShortArray,
    IntArray,
    LongArray
}

shared alias IntegerArrayLike 
        => Array<Byte>|Array<Short>|Array<Int>|Array<Long>
        |  ByteArray | ShortArray | IntArray | LongArray;
shared Array<Integer> toIntegerArray(IntegerArrayLike array) {
    switch (array)
    case (is Array<Byte>) {
        value size = array.size;
        value nativeArray = arrays.asByteArray(array);
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is Array<Short>) {
        value size = array.size;
        value nativeArray = arrays.asShortArray(array);
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is Array<Int>) {
        value size = array.size;
        value nativeArray = arrays.asIntArray(array);
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is Array<Long>) {
        value size = array.size;
        value nativeArray = arrays.asLongArray(array);
        value result = LongArray(size);
        arraycopy(nativeArray, 0, result, 0, size);
        return result.integerArray;
    }
    case (is ByteArray) {
        value size = array.size;
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is ShortArray) {
        value size = array.size;
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is IntArray) {
        value size = array.size;
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is LongArray) {
        value size = array.size;
        value result = LongArray(size);
        arraycopy(array, 0, result, 0, size);
        return result.integerArray;
    }
}

shared alias FloatArrayLike 
        => Array<Single>|Array<Double>
        |  FloatArray|DoubleArray;
shared Array<Float> toFloatArray(FloatArrayLike array) {
    switch (array)
    case (is Array<Single>) {
        value size = array.size;
        value nativeArray = arrays.asFloatArray(array);
        value result = DoubleArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.floatArray;
    }
    case (is Array<Double>) {
        value size = array.size;
        value nativeArray = arrays.asDoubleArray(array);
        value result = DoubleArray(size);
        arraycopy(nativeArray, 0, result, 0, size);
        return result.floatArray;
    }
    case (is FloatArray) {
        value size = array.size;
        value result = DoubleArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.floatArray;
    }
    case (is DoubleArray) {
        value size = array.size;
        value result = DoubleArray(size);
        arraycopy(array, 0, result, 0, size);
        return result.floatArray;
    }
}