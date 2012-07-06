import com.redhat.ceylon.sdk.test{...}
import ceylon.math.integer{...}

void testIntSumProduct() {
    print("Integer.sum");
    assertEquals { 
        expected = 0;
        got = sum();
    };
    assertEquals { 
        expected = 6; 
        got = sum(1, 2, 3);
    };
    print("Integer.product");
    assertEquals { 
        expected = 1; 
        got = product();
    };
    assertEquals { 
        expected = 6; 
        got = product(1, 2, 3);
    };
}

shared void intTests() {
    testIntSumProduct();
}
