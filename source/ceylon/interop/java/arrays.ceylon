import java.lang {
    Char=Character,
    Bool=Boolean,
    Bits=Byte,
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
    ObjectArray,
    BooleanArray,
    CharArray
}

import ceylon.interop.java.internal {
    booleanArray=javaBooleanArray,
    byteArray=javaByteArray,
    charArray=javaCharArray,
    doubleArray=javaDoubleArray,
    floatArray=javaFloatArray,
    intArray=javaIntArray,
    longArray=javaLongArray,
    shortArray=javaShortArray,
    objectArray=javaObjectArray,
    stringArray=javaStringArray
}

"The Java `boolean[]` array underyling the given Ceylon 
 [[array]]."
shared BooleanArray javaBooleanArray(Array<Boolean>|Array<Bool> array)
        => booleanArray(array);

"The Java `byte[]` array underyling the given Ceylon 
 [[array]]."
shared ByteArray javaByteArray(Array<Byte>|Array<Bits> array)
        => byteArray(array);

"The Java `short[]` array underyling the given Ceylon 
 [[array]]."
shared ShortArray javaShortArray(Array<Short> array)
        => shortArray(array);

"The Java `int[]` array underyling the given Ceylon 
 [[array]]."
shared IntArray javaIntArray(Array<Character>|Array<Int> array)
        => intArray(array);

"The Java `long[]` array underyling the given Ceylon 
 [[array]]."
shared LongArray javaLongArray(Array<Integer>|Array<Long> array)
        => longArray(array);

"The Java `float[]` array underyling the given Ceylon 
 [[array]]."
shared FloatArray javaFloatArray(Array<Single> array)
        => floatArray(array);

"The Java `double[]` array underyling the given Ceylon 
 [[array]]."
shared DoubleArray javaDoubleArray(Array<Float>|Array<Double> array)
        => doubleArray(array);

"The Java `char[]` array underyling the given Ceylon 
 [[array]]."
shared CharArray javaCharArray(Array<Char> array)
        => charArray(array);

"The Java object array underyling the given Ceylon 
 [[array]]."
shared ObjectArray<Element> javaObjectArray<Element>(Array<Element?> array)
        => objectArray(array);

"The Java `String[]` array underyling the given Ceylon 
 [[array]]."
shared ObjectArray<JavaString> javaStringArray(Array<String> array)
        => stringArray(array);

"An array whose elements can be represented as an 
 `Array<Integer>`."
shared alias IntegerArrayLike 
        => Array<Short> | Array<Int> | Array<Long>
        | ShortArray   | IntArray   | LongArray;

"Create an `Array<Integer>` with the same elements as the
 given array."
shared Array<Integer> toIntegerArray(IntegerArrayLike array) {
    switch (array)
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

"An array whose elements can be represented as an 
 `Array<Byte>`."
shared alias ByteArrayLike 
        => Array<Bits> | ByteArray;

"Create an `Array<Byte>` with the same elements as the
 given array."
shared Array<Byte> toByteArray(ByteArrayLike array) {
    switch (array)
    case (is Array<Bits>) {
        value size = array.size;
        value nativeArray = javaByteArray(array);
        value result = ByteArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.byteArray;
    }
    case (is ByteArray) {
        value size = array.size;
        value result = ByteArray(size);
        array.copyTo(result);
        return result.byteArray;
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
            result.set(i, array.getFromFirst(i)?.string);
            i++;
        }
        javaArray = result;
    }
    case (is Array<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.getFromFirst(i)?.string);
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
            if (exists element = array.getFromFirst(i)) {
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
            if (exists element = array.getFromFirst(i)) {
                result.set(i, javaString(element));
            }
            i++;
        }
        return result;
    }
}

shared BooleanArray createJavaBooleanArray({Boolean*} booleans)
        => javaBooleanArray(Array(booleans));

shared LongArray createJavaLongArray({Integer*} elements)
        => javaLongArray(Array(elements));

shared IntArray createJavaIntArray({Integer*} elements)
        => javaIntArray(Array { for (i in elements) Int(i) });

shared ShortArray createJavaShortArray({Integer*} elements)
        => javaShortArray(Array { for (i in elements) Short(i) });

shared ByteArray createJavaByteArray({Byte*} elements)
        => javaByteArray(Array { for (i in elements) i });

shared FloatArray createJavaFloatArray({Float*} elements)
        => javaFloatArray(Array { for (f in elements) Single(f) });

shared DoubleArray createJavaDoubleArray({Float*} elements)
        => javaDoubleArray(Array(elements));

shared ObjectArray<JavaString> createJavaStringArray({String*} elements)
        => javaStringArray(Array(elements));

shared ObjectArray<T> createJavaObjectArray<T>({T?*} elements)
        //given T satisfies Object
        => javaObjectArray(Array(elements));
