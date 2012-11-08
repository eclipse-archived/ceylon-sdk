import com.redhat.ceylon.sdk.test{...}
import ceylon.math.float{...}

Float undefined = 0.0/0.0;

Boolean approx(Object? expect, Object? got) {
    if(exists expect){
        if(exists got){
            if (is Float expect) {
                if (is Float got) {
                    if (expect != expect
                        && got != got) { // consider undefined as equal
                        return true;
                    }
                    // TODO Use MPL to parameterize the tolerance
                    return (expect - got).magnitude < 1.0E-10;
                }
            }
        }
        return false;
    }
    return !got exists;
}

Boolean exact(Object? expect, Object? got) {
    if(exists expect){
        if(exists got){
            if (is Float expect) {
                if (is Float got) {
                    if (expect != expect
                        && got != got) { // consider undefined as equal
                        return true;
                    } else if (expect == 0.0
                        && got == 0.0
                        && expect.strictlyPositive != got.strictlyPositive) { // consider 0.0 and -0.0 as different
                        return false;
                    }
                    return expect == got;
                }
            }
        }
        return false;
    }
    return !got exists;
}

void testExp() {
    print("Float.exp");
    assertEquals{
        expected=1.0;
        got=exp(0.0);
        compare=exact;
    };
    
    assertEquals{
        expected=+0.0;
        got=exp(-infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=infinity;
        got=exp(infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=undefined;
        got=exp(undefined);
        compare=exact;
    };
}

void testLog() {
    print("Float.log");
    assertEquals{
        expected=undefined;
        got=log(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        got=log(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        got=log(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=log(e);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=log(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=log(undefined);
        compare=exact;
    };
}

void testLog10() {
    print("Float.log10");
    assertEquals{
        expected=undefined;
        got=log10(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        got=log10(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        got=log10(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=log10(10.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=log10(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=log10(undefined);
        compare=exact;
    };
}

void testSin() {
    print("Float.sin");
    assertEquals{
        expected=undefined;
        got=sin(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=sin(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        got=sin(0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=sin(pi/2);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        got=sin(pi);
        compare=approx;
    };
    assertEquals{
        expected=-1.0;
        got=sin(pi*1.5);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        got=sin(2*pi);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        got=sin(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=sin(undefined);
        compare=exact;
    };
}

void testCos() {
    print("Float.cos");
    assertEquals{
        expected=undefined;
        got=cos(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=cos(0.0);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        got=cos(pi/2);
        compare=approx;
    };
    assertEquals{
        expected=-1.0;
        got=cos(pi);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        got=cos(pi*1.5);
        compare=approx;
    };
    assertEquals{
        expected=1.0;
        got=cos(2*pi);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        got=cos(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=cos(undefined);
        compare=exact;
    };
}

void testTan() {
    print("Float.tan");
    assertEquals{
        expected=undefined;
        got=tan(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=tan(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        got=tan(0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=tan(pi/4);
        compare=approx;
    };
    assertEquals{
        expected=-1.0;
        got=tan(0.75*pi);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        got=tan(pi);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        got=tan(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=tan(undefined);
        compare=exact;
    };
}

void testAsin() {
    print("Float.asin");
    assertEquals{
        expected=undefined;
        got=asin(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=asin(-2.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=asin(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=asin(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=asin(2.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=asin(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=asin(undefined);
        compare=exact;
    };
}

void testAcos() {
    print("Float.acos");
    assertEquals{
        expected=undefined;
        got=acos(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=acos(-2.0);
        compare=exact;
    };
    assertEquals{
        expected=pi/2;
        got=acos(+0.0);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        got=acos(2.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=acos(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=acos(undefined);
        compare=exact;
    };
}

void testAtan() {
    print("Float.atan");
    assertEquals{
        expected=-0.0;
        got=atan(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=atan(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=atan(undefined);
        compare=exact;
    };
}

void testAtan2() {
    print("Float.atan2");
    assertEquals{
        expected=undefined;
        got=atan2(undefined, 0.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=atan2(0.0, undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=+0.0;
        got=atan2(+0.0, 1.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=atan2(1.0, +infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=-0.0;
        got=atan2(-0.0, 1.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=atan2(-1.0, +infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=pi;
        got=atan2(+0.0, -1.0);
        compare=exact;
    };
    assertEquals{
        expected=pi;
        got=atan2(1.0, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=-pi;
        got=atan2(-0.0, -1.0);
        compare=exact;
    };
    assertEquals{
        expected=-pi;
        got=atan2(-1.0, -infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=pi/2;
        got=atan2(1.0, +0.0);
        compare=exact;
    };
    assertEquals{
        expected=pi/2;
        got=atan2(1.0, -0.0);
        compare=exact;
    };
    assertEquals{
        expected=pi/2;
        got=atan2(infinity, 1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=-pi/2;
        got=atan2(-1.0, +0.0);
        compare=exact;
    };
    assertEquals{
        expected=-pi/2;
        got=atan2(-1.0, -0.0);
        compare=exact;
    };
    assertEquals{
        expected=-pi/2;
        got=atan2(-infinity, 1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=pi/4;
        got=atan2(+infinity, +infinity);
        compare=exact;
    };
    assertEquals{
        expected=3*pi/4;
        got=atan2(+infinity, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=-pi/4;
        got=atan2(-infinity, +infinity);
        compare=exact;
    };
    assertEquals{
        expected=-3*pi/4;
        got=atan2(-infinity, -infinity);
        compare=exact;
    };
}

void testHypot() {
    print("Float.hypot");
    assertEquals{
        expected=0.0;
        got=hypot(0.0, 0.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(0.0, infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(0.0, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(infinity, 0.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(-infinity, 0.0);
        compare=exact;
    };
    
    assertEquals{
        expected=infinity;
        got=hypot(undefined, infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(undefined, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(infinity, undefined);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        got=hypot(-infinity, undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=undefined;
        got=hypot(0.0, undefined);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=hypot(undefined, 0.0);
        compare=exact;
    };
}

void testSqrt() {
    print("Float.sqrt");
    assertEquals{
        expected=undefined;
        got=sqrt(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=sqrt(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=sqrt(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=sqrt(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=sqrt(1.0);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        got=sqrt(4.0);
        compare=approx;
    };
    assertEquals{
        expected=infinity;
        got=sqrt(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=sqrt(undefined);
        compare=exact;
    };
}

void testCbrt() {
    print("Float.cbrt");
    assertEquals{
        expected=-infinity;
        got=cbrt(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        got=cbrt(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=cbrt(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=cbrt(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=cbrt(1.0);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        got=cbrt(8.0);
        compare=approx;
    };
    assertEquals{
        expected=infinity;
        got=cbrt(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=cbrt(undefined);
        compare=exact;
    };
}

void testRandom() {
    print("Float.cbrt");
    for (Integer ii in 0..1000) {
        Float r = random();
        assertTrue(r >= +0.0, "random() returned " r " (must be >= +0)");
        assertTrue(r < 1.0,  "random() returned " r " (must be < 1)");
    }
}

void testFloor() {
    print("Float.floor");
    assertEquals{
        expected=-infinity;
        got=floor(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=floor(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=floor(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=+infinity;
        got=floor(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=floor(undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=0.0;
        got=floor(0.1);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        got=floor(0.5);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        got=floor(0.9);
        compare=exact;
    };
    
    assertEquals{
        expected=1.0;
        got=floor(1.1);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=floor(1.5);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=floor(1.9);
        compare=exact;
    };
    
    assertEquals{
        expected=-1.0;
        got=floor(-0.1);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        got=floor(-0.5);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        got=floor(-0.9);
        compare=exact;
    };
}

void testCeiling() {
    print("Float.ceiling");
    assertEquals{
        expected=-infinity;
        got=ceiling(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=ceiling(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=ceiling(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=+infinity;
        got=ceiling(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=ceiling(undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=1.0;
        got=ceiling(0.1);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=ceiling(0.5);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=ceiling(0.9);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=ceiling(1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=2.0;
        got=ceiling(1.1);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        got=ceiling(1.5);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        got=ceiling(1.9);
        compare=exact;
    };
    
    assertEquals{
        expected=-0.0;
        got=ceiling(-0.1);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=ceiling(-0.5);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=ceiling(-0.9);
        compare=exact;
    };
}

void testHalfEven() {
    print("Float.halfEven");
    assertEquals{
        expected=-infinity;
        got=halfEven(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=halfEven(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        got=halfEven(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=+infinity;
        got=halfEven(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        got=halfEven(undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=0.0;
        got=halfEven(0.1);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        got=halfEven(0.5);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=halfEven(0.9);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        got=halfEven(1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=1.0;
        got=halfEven(1.1);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        got=halfEven(1.5);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        got=halfEven(1.9);
        compare=exact;
    };
    
    assertEquals{
        expected=-0.0;
        got=halfEven(-0.1);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        got=halfEven(-0.5);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        got=halfEven(-0.9);
        compare=exact;
    };
}

void testSumProduct() {
    print("Float.sum");
    assertEquals { 
        expected = 0.0; 
        got = sum();
        compare = exact; 
    };
    assertEquals { 
        expected = 6.0; 
        got = sum(1.0, 2.0, 3.0);
        compare = exact; 
    };
    print("Float.product");
    assertEquals { 
        expected = 1.0; 
        got = product();
        compare = exact; 
    };
    assertEquals { 
        expected = 6.0; 
        got = product(1.0, 2.0, 3.0);
        compare = exact; 
    };
}

shared void floatTests() {
    assertFalse(exact(0.0, -0.0), "Oops! Test is broken because we can't distinguish 0.0 and -0.0");
    testExp();
    testLog();
    testLog10();
    testSin();
    testCos();
    testTan();
    testAsin();
    testAcos();
    testAtan();
    testAtan2();
    testHypot();
    testSqrt();
    testCbrt();
    testRandom();
    testFloor();
    testCeiling();
    testHalfEven();
    testSumProduct();
}
