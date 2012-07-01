import com.redhat.ceylon.sdk.test{...}
import ceylon.math.integer{...}

void testIntSumProduct() {
    print("Integer.sum");
    assertEquals { 
        expected = 0; 
        got = sum();
        compare = exact; 
    };
    assertEquals { 
        expected = 6; 
        got = sum(1, 2, 3);
        compare = exact; 
    };
    print("Integer.product");
    assertEquals { 
        expected = 1; 
        got = product();
        compare = exact; 
    };
    assertEquals { 
        expected = 6; 
        got = product(1, 2, 3);
        compare = exact; 
    };
}

shared void intTests() {
    testIntSumProduct();
}
