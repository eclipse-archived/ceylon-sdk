import java.lang {
    Byte,
    Short,
    Int=Integer,
    Long,
    Single=Float,
    Double,
    JavaString=String,
    FloatArray,
    DoubleArray,
    ByteArray,
    ShortArray,
    IntArray,
    LongArray,
    ObjectArray
}

shared alias IntegerArrayLike 
        => Array<Byte>|Array<Short>|Array<Int>|Array<Long>
        |  ByteArray | ShortArray | IntArray | LongArray;

shared Array<Integer> toIntegerArray(IntegerArrayLike array) {
    switch (array)
    case (is Array<Byte>) {
        value size = array.size;
        value nativeArray = javaByteArray(array);
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
        value nativeArray = javaShortArray(array);
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
        value nativeArray = javaIntArray(array);
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
        value nativeArray = javaLongArray(array);
        value result = LongArray(size);
        nativeArray.copyTo(result);
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
        array.copyTo(result);
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
        value nativeArray = javaFloatArray(array);
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
        value nativeArray = javaDoubleArray(array);
        value result = DoubleArray(size);
        nativeArray.copyTo(result);
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
        array.copyTo(result);
        return result.floatArray;
    }
}

shared alias StringArray
        => ObjectArray<String?>|ObjectArray<String>
        |  Array<String>|Array<String?>;
shared ObjectArray<JavaString> toNativeJavaStringArray(StringArray array) {
    switch (array)
    case (is ObjectArray<String?>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            if (exists element = array.get(i)) {
                result.set(i, javaString(element));
            }
            i++;
        }
        return result;
    }
    case (is ObjectArray<String>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, javaString(array.get(i)));
            i++;
        }
        return result;
    }
    case (is Array<String?>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            if (exists element = array.get(i)) {
                result.set(i, javaString(element));
            }
            i++;
        }
        return result;
    }
    case (is Array<String>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            if (exists element = array.get(i)) {
                result.set(i, javaString(element));
            }
            i++;
        }
        return result;
    }
}

Array<JavaString?> toJavaStringArray(StringArray array)
        => toNativeJavaStringArray(array).array;

shared alias JavaStringArray 
        => ObjectArray<JavaString?>|ObjectArray<JavaString>
        |  Array<JavaString?>|Array<JavaString>;

ObjectArray<String> toNativeStringArray(JavaStringArray array) {
    switch (array)
    case (is ObjectArray<JavaString?>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        return result;
    }
    case (is ObjectArray<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        return result;
    }
    case (is Array<JavaString?>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        return result;
    }
    case (is Array<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        return result;
    }
}

shared Array<String?> toStringArray(JavaStringArray array)
        => toNativeStringArray(array).array;