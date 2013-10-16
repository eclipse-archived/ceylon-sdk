import ceylon.test { assertEquals, assertTrue, assertFalse, test }
import ceylon.math.float { ... }

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

test void testExp() {
    print("Float.exp");
    assertEquals{
        expected=1.0;
        actual=exp(0.0);
        compare=exact;
    };
    
    assertEquals{
        expected=+0.0;
        actual=exp(-infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=infinity;
        actual=exp(infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=undefined;
        actual=exp(undefined);
        compare=exact;
    };
}

test void testLog() {
    print("Float.log");
    assertEquals{
        expected=undefined;
        actual=log(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        actual=log(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        actual=log(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=log(e);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=log(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=log(undefined);
        compare=exact;
    };
}

test void testLog10() {
    print("Float.log10");
    assertEquals{
        expected=undefined;
        actual=log10(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        actual=log10(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        actual=log10(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=log10(10.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=log10(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=log10(undefined);
        compare=exact;
    };
}

test void testSin() {
    print("Float.sin");
    assertEquals{
        expected=undefined;
        actual=sin(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=sin(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=sin(0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=sin(pi/2);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        actual=sin(pi);
        compare=approx;
    };
    assertEquals{
        expected=-1.0;
        actual=sin(pi*1.5);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        actual=sin(2*pi);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        actual=sin(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=sin(undefined);
        compare=exact;
    };
}

test void testCos() {
    print("Float.cos");
    assertEquals{
        expected=undefined;
        actual=cos(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=cos(0.0);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        actual=cos(pi/2);
        compare=approx;
    };
    assertEquals{
        expected=-1.0;
        actual=cos(pi);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        actual=cos(pi*1.5);
        compare=approx;
    };
    assertEquals{
        expected=1.0;
        actual=cos(2*pi);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        actual=cos(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=cos(undefined);
        compare=exact;
    };
}

test void testTan() {
    print("Float.tan");
    assertEquals{
        expected=undefined;
        actual=tan(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=tan(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=tan(0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=tan(pi/4);
        compare=approx;
    };
    assertEquals{
        expected=-1.0;
        actual=tan(0.75*pi);
        compare=approx;
    };
    assertEquals{
        expected=0.0;
        actual=tan(pi);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        actual=tan(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=tan(undefined);
        compare=exact;
    };
}

test void testAsin() {
    print("Float.asin");
    assertEquals{
        expected=undefined;
        actual=asin(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=asin(-2.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=asin(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=asin(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=asin(2.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=asin(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=asin(undefined);
        compare=exact;
    };
}

test void testAcos() {
    print("Float.acos");
    assertEquals{
        expected=undefined;
        actual=acos(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=acos(-2.0);
        compare=exact;
    };
    assertEquals{
        expected=pi/2;
        actual=acos(+0.0);
        compare=approx;
    };
    assertEquals{
        expected=undefined;
        actual=acos(2.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=acos(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=acos(undefined);
        compare=exact;
    };
}

test void testAtan() {
    print("Float.atan");
    assertEquals{
        expected=-0.0;
        actual=atan(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=atan(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=atan(undefined);
        compare=exact;
    };
}

test void testAtan2() {
    print("Float.atan2");
    assertEquals{
        expected=undefined;
        actual=atan2(undefined, 0.0);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=atan2(0.0, undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=+0.0;
        actual=atan2(+0.0, 1.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=atan2(1.0, +infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=-0.0;
        actual=atan2(-0.0, 1.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=atan2(-1.0, +infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=pi;
        actual=atan2(+0.0, -1.0);
        compare=exact;
    };
    assertEquals{
        expected=pi;
        actual=atan2(1.0, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=-pi;
        actual=atan2(-0.0, -1.0);
        compare=exact;
    };
    assertEquals{
        expected=-pi;
        actual=atan2(-1.0, -infinity);
        compare=exact;
    };
    
    assertEquals{
        expected=pi/2;
        actual=atan2(1.0, +0.0);
        compare=exact;
    };
    assertEquals{
        expected=pi/2;
        actual=atan2(1.0, -0.0);
        compare=exact;
    };
    assertEquals{
        expected=pi/2;
        actual=atan2(infinity, 1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=-pi/2;
        actual=atan2(-1.0, +0.0);
        compare=exact;
    };
    assertEquals{
        expected=-pi/2;
        actual=atan2(-1.0, -0.0);
        compare=exact;
    };
    assertEquals{
        expected=-pi/2;
        actual=atan2(-infinity, 1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=pi/4;
        actual=atan2(+infinity, +infinity);
        compare=exact;
    };
    assertEquals{
        expected=3*pi/4;
        actual=atan2(+infinity, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=-pi/4;
        actual=atan2(-infinity, +infinity);
        compare=exact;
    };
    assertEquals{
        expected=-3*pi/4;
        actual=atan2(-infinity, -infinity);
        compare=exact;
    };
}

test void testHypot() {
    print("Float.hypot");
    assertEquals{
        expected=0.0;
        actual=hypot(0.0, 0.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(0.0, infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(0.0, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(infinity, 0.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(-infinity, 0.0);
        compare=exact;
    };
    
    assertEquals{
        expected=infinity;
        actual=hypot(undefined, infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(undefined, -infinity);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(infinity, undefined);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=hypot(-infinity, undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=undefined;
        actual=hypot(0.0, undefined);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=hypot(undefined, 0.0);
        compare=exact;
    };
}

test void testSqrt() {
    print("Float.sqrt");
    assertEquals{
        expected=undefined;
        actual=sqrt(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=sqrt(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=sqrt(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=sqrt(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=sqrt(1.0);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        actual=sqrt(4.0);
        compare=approx;
    };
    assertEquals{
        expected=infinity;
        actual=sqrt(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=sqrt(undefined);
        compare=exact;
    };
}

test void testCbrt() {
    print("Float.cbrt");
    assertEquals{
        expected=-infinity;
        actual=cbrt(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        actual=cbrt(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=cbrt(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=cbrt(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=cbrt(1.0);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        actual=cbrt(8.0);
        compare=approx;
    };
    assertEquals{
        expected=infinity;
        actual=cbrt(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=cbrt(undefined);
        compare=exact;
    };
}

test void testRandom() {
    print("Float.cbrt");
    for (Integer ii in 0..1000) {
        Float r = random();
        assertTrue(r >= +0.0, "random() returned ``r`` (must be >= +0)");
        assertTrue(r < 1.0,  "random() returned ``r`` (must be < 1)");
    }
}

test void testFloor() {
    print("Float.floor");
    assertEquals{
        expected=-infinity;
        actual=floor(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=floor(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=floor(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=+infinity;
        actual=floor(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=floor(undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=0.0;
        actual=floor(0.1);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=floor(0.5);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=floor(0.9);
        compare=exact;
    };
    
    assertEquals{
        expected=1.0;
        actual=floor(1.1);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=floor(1.5);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=floor(1.9);
        compare=exact;
    };
    
    assertEquals{
        expected=-1.0;
        actual=floor(-0.1);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        actual=floor(-0.5);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        actual=floor(-0.9);
        compare=exact;
    };
}

test void testCeiling() {
    print("Float.ceiling");
    assertEquals{
        expected=-infinity;
        actual=ceiling(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=ceiling(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=ceiling(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=+infinity;
        actual=ceiling(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=ceiling(undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=1.0;
        actual=ceiling(0.1);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=ceiling(0.5);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=ceiling(0.9);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=ceiling(1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=2.0;
        actual=ceiling(1.1);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        actual=ceiling(1.5);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        actual=ceiling(1.9);
        compare=exact;
    };
    
    assertEquals{
        expected=-0.0;
        actual=ceiling(-0.1);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=ceiling(-0.5);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=ceiling(-0.9);
        compare=exact;
    };
}

test void testHalfEven() {
    print("Float.halfEven");
    assertEquals{
        expected=-infinity;
        actual=halfEven(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=halfEven(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=+0.0;
        actual=halfEven(+0.0);
        compare=exact;
    };
    assertEquals{
        expected=+infinity;
        actual=halfEven(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=halfEven(undefined);
        compare=exact;
    };
    
    assertEquals{
        expected=0.0;
        actual=halfEven(0.1);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=halfEven(0.5);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=halfEven(0.9);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=halfEven(1.0);
        compare=exact;
    };
    
    assertEquals{
        expected=1.0;
        actual=halfEven(1.1);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        actual=halfEven(1.5);
        compare=exact;
    };
    assertEquals{
        expected=2.0;
        actual=halfEven(1.9);
        compare=exact;
    };
    
    assertEquals{
        expected=-0.0;
        actual=halfEven(-0.1);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=halfEven(-0.5);
        compare=exact;
    };
    assertEquals{
        expected=-1.0;
        actual=halfEven(-0.9);
        compare=exact;
    };
}

test void testSumProduct() {
    print("Float.sum");
    assertEquals { 
        expected = 0.0; 
        actual=sum();
        compare = exact; 
    };
    assertEquals { 
        expected = 6.0; 
        actual=sum(1.0, 2.0, 3.0);
        compare = exact; 
    };
    print("Float.product");
    assertEquals { 
        expected = 1.0; 
        actual=product();
        compare = exact; 
    };
    assertEquals { 
        expected = 6.0; 
        actual=product(1.0, 2.0, 3.0);
        compare = exact; 
    };
}

test void floatTests() {
    assertFalse(exact(0.0, -0.0), "Oops! Test is broken because we can't distinguish 0.0 and -0.0");
}