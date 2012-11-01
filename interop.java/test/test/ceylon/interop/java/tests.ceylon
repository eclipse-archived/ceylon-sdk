import ceylon.interop.java { ... }
import java.lang { System { getSystemProperty=getProperty } }

shared void run() {
    value val = javaString(getSystemProperty("user.home"));
    print(val);
    
    testArray(createByteArray(10), "Byte", 1);
    testArray(createShortArray(10), "Short", 1);
    testArray(createIntArray(10), "Int", 1);
    testArray(createFloatArray(10), "Float", 1.0);
    testArray(createCharArray(10), "Char", `c`);
    testArray(createBooleanArray(10), "Boolean", true);
}

void testArray<T>(Array<T> array, String typename, T val) {
    process.write("Testing create" typename "Array() ");
    for (T item in array) {
        if (!exists item) {
            print("FAILED");
        }
    }
    for (i in 0..array.size-1) {
        if (!exists array[i]) {
            print("FAILED");
        }
    }
    if (is Object val) {
        for (i in 0..array.size-1) {
            array.setItem(i, val);
        }
        for (T item in array) {
            if (exists item, item != val) {
                print("FAILED");
            }
        }
        for (i in 0..array.size-1) {
            if (exists item=array[i], item != val) {
                print("FAILED");
            }
        }
        print("Okay");
    } else {
        print("Hmmm?");
    }
}