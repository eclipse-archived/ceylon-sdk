import ceylon.test { ... }
import ceylon.math.integer { ... }

void testIntSumProduct() {
    print("Integer.sum");
    assertEquals { 
        expected = 0;
        actual=sum();
    };
    assertEquals { 
        expected = 6; 
        actual=sum(1, 2, 3);
    };
    print("Integer.product");
    assertEquals { 
        expected = 1; 
        actual=product();
    };
    assertEquals { 
        expected = 6; 
        actual=product(1, 2, 3);
    };
}

shared void intTests() {
    testIntSumProduct();
}
