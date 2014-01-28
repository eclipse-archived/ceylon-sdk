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

"An array whose elements can be represented as an 
 `Array<Integer>`."
shared alias IntegerArrayLike 
        => Array<Byte> | Array<Short> | Array<Int> | Array<Long>
        |  ByteArray   | ShortArray   | IntArray   | LongArray;

"Create an `Array<Integer>` with the same elements as the
 given array."
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

"An array whose elements can be represented as an 
 `Array<Float>`."
shared alias FloatArrayLike 
        => Array<Single> | Array<Double>
        |  FloatArray    | DoubleArray;

"Create an `Array<Float>` with the same elements as the
 given array."
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


//Array<JavaString?> toJavaStringCeylonArray(StringArrayLike array)
//        => toJavaStringArray(array).array;

"An array whose elements can be represented as an 
 `Array<String?>`."
shared alias StringArrayLike 
        => ObjectArray<JavaString?> | ObjectArray<JavaString>
        |  Array<JavaString?>       | Array<JavaString>;

"Create an `Array<String?>` with the same elements as the
 given array."
shared Array<String?> toStringArray(StringArrayLike array) {
    ObjectArray<String> javaArray;
    switch (array)
    case (is ObjectArray<JavaString?>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        javaArray = result;
    }
    case (is ObjectArray<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        javaArray = result;
    }
    case (is Array<JavaString?>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        javaArray = result;
    }
    case (is Array<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        javaArray = result;
    }
    return javaArray.array;
}

"An array whose elements can be represented as an 
 `ObjectArray<JavaString>`."
shared alias JavaStringArrayLike
        => ObjectArray<String?> | ObjectArray<String>
        |  Array<String>        | Array<String?>;

"Create an `ObjectArray<JavaString>` with the same elements 
 as the given array."
shared ObjectArray<JavaString> toJavaStringArray(JavaStringArrayLike array) {
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
