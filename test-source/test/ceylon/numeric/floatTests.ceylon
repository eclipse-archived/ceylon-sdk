import ceylon.test { assertEquals, assertTrue, assertFalse, test }
import ceylon.numeric.float { ... }

Float undefined = 0.0/0.0;

Boolean approx(Anything expect, Anything got) {
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

Boolean exact(Anything expect, Anything got) {
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

shared test void testExp() {
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

shared test void testExpm1() {
    assertEquals{
        expected=0.0;
        actual=expm1(0.0);
        compare=exact;
    };

    assertEquals{
        expected=-1.0;
        actual=expm1(-infinity);
        compare=exact;
    };

    assertEquals{
        expected=infinity;
        actual=expm1(infinity);
        compare=exact;
    };

    assertEquals{
        expected=undefined;
        actual=expm1(undefined);
        compare=exact;
    };
}

shared test void testLog() {
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

shared test void testLog1p() {
    assertEquals{
        expected=undefined;
        actual=log1p(-2.0);
        compare=exact;
    };
    assertEquals{
        expected=-infinity;
        actual=log1p(-1.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=log1p(e - 1.0);
        compare=exact;
    };
    assertEquals{
        expected=infinity;
        actual=log1p(infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=log1p(undefined);
        compare=exact;
    };
}

shared test void testLog10() {
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

shared test void testSin() {
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

shared test void testSinh() {
    assertEquals{
        expected=-infinity;
        actual=sinh(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=sinh(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=sinh(0.0);
        compare=exact;
    };
    assertEquals{
        expected=-sinh(10.0);
        actual=sinh(-10.0);
        compare=approx;
    };
    assertEquals{
        expected=+infinity;
        actual=sinh(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=sinh(undefined);
        compare=exact;
    };
}

shared test void testCosh() {
    assertEquals{
        expected=+infinity;
        actual=cosh(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=cosh(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=1.0;
        actual=cosh(0.0);
        compare=exact;
    };
    assertEquals{
        expected=cosh(10.0);
        actual=cosh(-10.0);
        compare=approx;
    };
    assertEquals{
        expected=+infinity;
        actual=cosh(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=cosh(undefined);
        compare=exact;
    };
}

shared test void testTanh() {
    assertEquals{
        expected=-1.0;
        actual=tanh(-infinity);
        compare=exact;
    };
    assertEquals{
        expected=-0.0;
        actual=tanh(-0.0);
        compare=exact;
    };
    assertEquals{
        expected=0.0;
        actual=tanh(0.0);
        compare=exact;
    };
    assertEquals{
        expected=-tanh(10.0);
        actual=tanh(-10.0);
        compare=approx;
    };
    assertEquals{
        expected=+1.0;
        actual=tanh(+infinity);
        compare=exact;
    };
    assertEquals{
        expected=undefined;
        actual=tanh(undefined);
        compare=exact;
    };
}

shared test void testCos() {
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

shared test void testTan() {
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

shared test void testAsin() {
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

shared test void testAcos() {
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

shared test void testAtan() {
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

shared test void testAtan2() {
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
        expected=0.0;
        actual=atan2(+0.0, 0.0);
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

shared test void testHypot() {
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

shared test void testSqrt() {
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

shared test void testCbrt() {
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

shared test void testRandom() {
    for (Integer ii in 0..1000) {
        Float r = random();
        assertTrue(r >= +0.0, "random() returned ``r`` (must be >= +0)");
        assertTrue(r < 1.0,  "random() returned ``r`` (must be < 1)");
    }
}

shared test void testFloor() {
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

shared test void testCeiling() {
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

shared test void testHalfEven() {
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

shared test void testSumProduct() {
    assertEquals {
        expected = 0.0;
        actual=sum {};
        compare = exact;
    };
    assertEquals {
        expected = 6.0;
        actual=sum { 1.0, 2.0, 3.0 };
        compare = exact;
    };
    assertEquals {
        expected = 1.0;
        actual=product {};
        compare = exact;
    };
    assertEquals {
        expected = 6.0;
        actual=product { 1.0, 2.0, 3.0 };
        compare = exact;
    };
}

shared test void testScalb() {
    // TODO scalb(-0.0, x) is -0.0 on JVM, +0.0 on JS
    assertEquals {
        expected = 0.0;
        actual=scalb(0.0, 0);
        compare = exact;
    };
    assertEquals {
        expected = 0.0;
        actual=scalb(0.0, 2);
        compare = exact;
    };
    assertEquals {
        expected = 0.0;
        actual=scalb(0.0, -2);
        compare = exact;
    };
    assertEquals {
        expected = 4.0;
        actual=scalb(1.0, 2);
        compare = exact;
    };
    assertEquals {
        expected = 0.25;
        actual=scalb(1.0, -2);
        compare = exact;
    };
    assertEquals {
        expected = -4.0;
        actual=scalb(-1.0, 2);
        compare = exact;
    };
    assertEquals {
        expected = -0.25;
        actual=scalb(-1.0, -2);
        compare = exact;
    };
    assertEquals {
        expected = 24.0;
        actual=scalb(3.0, 3);
        compare = exact;
    };
    assertEquals {
        expected = 0.375;
        actual=scalb(3.0, -3);
        compare = exact;
    };
    assertEquals {
        expected = -24.0;
        actual=scalb(-3.0, 3);
        compare = exact;
    };
    assertEquals {
        expected = -0.375;
        actual=scalb(-3.0, -3);
        compare = exact;
    };
}

shared test void testRemainder() {
    assertEquals {
        expected = 1.0;
        actual=remainder(5.5, 1.5);
        compare = exact;
    };
    assertEquals {
        expected = 1.0;
        actual=remainder(5.5, -1.5);
        compare = exact;
    };
    assertEquals {
        expected = -1.0;
        actual=remainder(-5.5, 1.5);
        compare = exact;
    };
    assertEquals {
        expected = -1.0;
        actual=remainder(-5.5, -1.5);
        compare = exact;
    };
    // zero dividend
    assertEquals {
        expected = 0.0;
        actual=remainder(0.0, 1.0);
        compare = exact;
    };
    assertEquals {
        expected = -0.0;
        actual=remainder(-0.0, 1.0);
        compare = exact;
    };
    assertEquals {
        expected = 0.0;
        actual=remainder(0.0, infinity);
        compare = exact;
    };
    assertEquals {
        expected = 0.0;
        actual=remainder(0.0, -infinity);
        compare = exact;
    };
    assertEquals {
        expected = -0.0;
        actual=remainder(-0.0, infinity);
        compare = exact;
    };
    assertEquals {
        expected = -0.0;
        actual=remainder(-0.0, -infinity);
        compare = exact;
    };
    assertEquals {
        expected = 0.0 / 0.0; // undefined
        actual=remainder(0.0, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = -0.0 / 0.0; // undefined
        actual=remainder(-0.0, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(0.0, undefined);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-0.0, undefined);
        compare = exact;
    };
    // infinite dividend (always undefined)
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, -0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, 1.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, -1.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, undefined);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, -undefined);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, infinity);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(infinity, -infinity);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, -0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, 1.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, -1.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, infinity);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, -infinity);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, undefined);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-infinity, -undefined);
        compare = exact;
    };
    // zero divisor
    assertEquals {
        expected = undefined;
        actual=remainder(1.0, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(-1.0, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(undefined, 0.0);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(undefined, 0.0);
        compare = exact;
    };
    // infinite divisor
    assertEquals {
        expected = 1.5;
        actual=remainder(1.5, infinity);
        compare = exact;
    };
    assertEquals {
        expected = 1.5;
        actual=remainder(1.5, -infinity);
        compare = exact;
    };
    assertEquals {
        expected = -1.5;
        actual=remainder(-1.5, infinity);
        compare = exact;
    };
    assertEquals {
        expected = -1.5;
        actual=remainder(-1.5, -infinity);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(undefined, infinity);
        compare = exact;
    };
    assertEquals {
        expected = undefined;
        actual=remainder(undefined, -infinity);
        compare = exact;
    };
}

shared test void floatTests() {
    assertFalse(exact(0.0, -0.0), "Oops! Test is broken because we can't distinguish 0.0 and -0.0");
}
