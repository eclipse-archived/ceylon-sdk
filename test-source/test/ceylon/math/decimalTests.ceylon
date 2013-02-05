import ceylon.math.decimal { Decimal, round, halfUp, parseDecimal, decimalNumber, zero, one, implicitlyRounded }

import ceylon.test { ... }

import java.lang { ArithmeticException }

Boolean strictly(Object? expect, Object? got) {
    if (exists expect) {
        if (is Decimal expect) {
            if (exists got) {
                if (is Decimal got) {
                    return expect.strictlyEquals(got);
                }
            }
            return false;
        }
    }
    return !got exists; 
}

Decimal parseOrFail(String str) {
    Decimal? result = parseDecimal(str);
    if (exists result) {
        return result;
    }
    throw AssertException("``str`` didn't parse");
}

void instantiationAndEquality() {
    print("Decimal instantiation, equality");
    assertTrue(zero == zero, "zero==zero");
    assertTrue(zero != one, "zero!=one");
    assertTrue(one == one, "one==one");
    assertTrue(zero== decimalNumber(0), "zero==0");
    assertTrue(one == decimalNumber(1), "one==1");
    assertTrue(decimalNumber(1) == decimalNumber(1), "1==1");
    assertTrue(decimalNumber(0) != decimalNumber(1), "0!=1");
    assertTrue(decimalNumber(1) != decimalNumber(2), "1!=2");
}

void parse() {
    print("parseDecimal");
    assertEquals(one, parseDecimal("1"), "parseDecimal(1)");
    assertEquals(decimalNumber(-1), parseDecimal("-1"), "parseDecimal(-1)");
    assertEquals(zero, parseDecimal("0"), "parseDecimal(0)");
    assertEquals(one, parseDecimal("1.0"), "parseDecimal(1.0)");
    assertEquals(one, parseDecimal("1.00"), "parseDecimal(1.00)");
    assertEquals(one, parseDecimal("01.0"), "parseDecimal(01.0)");
    assertEquals(one, parseDecimal("01"), "parseDecimal(01)");
    assertEquals(one, parseDecimal("1."), "parseDecimal(1.)");
    assertEquals(parseDecimal("0.1"), parseDecimal(".1"), "parseDecimal(.1)");
    assertNull(parseDecimal("a"), "parseDecimal(a)");
    assertNull(parseDecimal("1a"), "parseDecimal(1a)");
    assertNull(parseDecimal("a1"), "parseDecimal(a1)");
}

void strictEqualsAndHash() {
    print("Decimal.strictEquals");
    assertFalse(decimalNumber(1).strictlyEquals(parseOrFail("1.0")), "1.strictEquals(1.0)");
    assertFalse(decimalNumber(1).strictlyEquals(parseOrFail("1.00")), "1.strictEquals(1.00)");
    print("hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.0").hash, "2.hash==2.0.hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.00").hash, "2.hash==2.0.hash");
}

void plus() {
    print("Decimal.plus");
    assertEquals(decimalNumber(2), decimalNumber(1.0).plus(decimalNumber(1)), "1.0.plus(1)", strictly);
    assertEquals(decimalNumber(2), decimalNumber(1.0) + decimalNumber(1), "1.0+1", strictly);
    variable value r = round(3, halfUp);
    assertEquals(parseDecimal("2.00"), parseOrFail("1.000").plusRounded(decimalNumber(1), r), "1.000.plusWithRounding(1, r)", strictly);
    assertEquals(parseDecimal("2.01"), decimalNumber(2).plusRounded(parseOrFail("0.005"), r), "2.plusWithRounding(0.005, r)", strictly);
    variable value a = parseOrFail("0.100");
    variable value b = parseOrFail("0.01");
    function calculation() {
        return a + b;
    }
    r = round(2, halfUp);
    assertEquals(parseDecimal("0.11"), implicitlyRounded(calculation, r), "0.100+0.01", strictly);
    a = parseOrFail("0.105");
    assertEquals(parseDecimal("0.12"), implicitlyRounded(calculation, r), "0.105+0.01", strictly);
}

void minus() {
    print("Decimal.minus");
    assertEquals(decimalNumber(0), decimalNumber(1.0).minus(decimalNumber(1)), "1.0.minus(1)", strictly);
    assertEquals(decimalNumber(0), decimalNumber(1.0) - decimalNumber(1), "1.0-1", strictly);
    variable value r = round(2, halfUp);
    assertEquals(parseDecimal("0.000"), parseOrFail("1.000").minusRounded(decimalNumber(1), r), "1.000.minusWithRounding(1, r)", strictly);
    r = round(3, halfUp);
    assertEquals(parseDecimal("2.00"), decimalNumber(2).minusRounded(parseOrFail("0.005"), r), "2.minusWithRounding(0.005, r)", strictly);
    variable value a = parseOrFail("0.100");
    variable value b = parseOrFail("0.01");
    function calculation() {
        return a - b;
    }
    r = round(2, halfUp);
    assertEquals(parseDecimal("0.090"), implicitlyRounded(calculation, r), "0.100-0.01", strictly);
    a = parseOrFail("0.105");
    assertEquals(parseDecimal("0.095"), implicitlyRounded(calculation, r), "0.105-0.01", strictly);
}

void times() {
    print("Decimal.times");
    assertEquals(decimalNumber(4), decimalNumber(2.0).times(decimalNumber(2)), "2.0.times(2)", strictly);
    assertEquals(decimalNumber(4), decimalNumber(2.0) * decimalNumber(2), "2.0*2", strictly);
    variable value r = round(3, halfUp);
    assertEquals(parseDecimal("1.00"), parseOrFail("1.000").timesRounded(decimalNumber(1), r), "1.000.timesWithRounding(1, r)", strictly);
    assertEquals(parseDecimal("1.00"), decimalNumber(2).timesRounded(parseOrFail("0.500"), r), "2.timesWithRounding(0.500, r)", strictly);
    variable value a = parseOrFail("0.100");
    variable value b = parseOrFail("0.1");
    function calculation() {
        return a * b;
    }
    assertEquals(parseDecimal("0.0100"), implicitlyRounded(calculation, r), "0.100 * 0.01", strictly);
    a = parseOrFail("0.105");
    assertEquals(parseDecimal("0.0105"), implicitlyRounded(calculation, r), "0.105 * 0.01", strictly);
}

void divided() {
    print("Decimal.divided");
    variable value r = round(3, halfUp);
    assertEquals(decimalNumber(2), decimalNumber(4.0).divided(decimalNumber(2)), "4.0.divided(2)", strictly);
    assertEquals(decimalNumber(2), decimalNumber(4.0) / decimalNumber(2), "4.0/2", strictly);
    try {
        Decimal oneThird = decimalNumber(1) / decimalNumber(3);
        fail("1/3");
    } catch (ArithmeticException e) {
        // non-terminating decimal
    }
    assertEquals(parseDecimal("0.333"), decimalNumber(1).dividedRounded(decimalNumber(3), r), "1.dividedWithRounding(3, r)", strictly);
    assertEquals(parseDecimal("0.667"), decimalNumber(2).dividedRounded(decimalNumber(3), r), "2.dividedWithRounding(3, r)", strictly);

    variable Decimal numerator = one;
    variable Decimal denominator =  decimalNumber(3);
    function calculation() {
        return numerator / denominator;
    }
    assertEquals(parseDecimal("0.333"), implicitlyRounded(calculation, r), "", strictly);
    numerator = one+one;
    assertEquals(parseDecimal("0.667"), implicitlyRounded(calculation, r), "", strictly);
}

void power() {
    print("Decimal.power");
    assertEquals(decimalNumber(4), decimalNumber(2)^2, "2^2");
    assertEquals(decimalNumber(8), decimalNumber(2)^3, "2^3");
    assertEquals(parseOrFail("0.25"), parseOrFail("0.5")^2, "0.5^2");
    try {
        Decimal d = decimalNumber(2)^(-2);
        fail();
    } catch (Exception e) {
    }

    value r = round(2, halfUp);
    assertEquals(parseOrFail("0.25"),
        decimalNumber(2).powerRounded(-2, r),
        "0.25.powerWithRounding(-2, 2halfUp))", strictly);
        
    variable value a = parseOrFail("2");
    variable value b = -2;
    function calculation() {
        return a ^ b;
    }
    assertEquals(parseDecimal("0.25"), implicitlyRounded(calculation, r), "2 ^ -2", strictly);
}

void dividedAndTruncated() {
    print("Decimal.dividedAndTruncated");
    variable value r = round(3, halfUp);
    assertEquals(parseDecimal("0"), decimalNumber(2).dividedTruncated(decimalNumber(3), r), "2.dividedAndTruncated(3)", strictly);
    assertEquals(parseDecimal("1"), decimalNumber(3).dividedTruncated(decimalNumber(2), r), "3.dividedAndTruncated(2)", strictly);
    assertEquals(parseDecimal("-1"), decimalNumber(-3).dividedTruncated(decimalNumber(2), r), "-3.dividedAndTruncated(2)", strictly);
}

void remainder() {
    print("Decimal.remainder");
    variable value r = round(3, halfUp);
    assertEquals(parseDecimal("2"), decimalNumber(2).remainderRounded(decimalNumber(3), r), "2.remainder(3)", strictly);
    assertEquals(parseDecimal("1"), decimalNumber(3).remainderRounded(decimalNumber(2), r), "3.remainder(2)", strictly);
}

void scalePrecision() {
    print("Decimal.scale and .precision");
    assertEquals(3, parseOrFail("0.001").scale);
    assertEquals(1, parseOrFail("0.001").precision);
    assertEquals(2, parseOrFail("0.01").scale);
    assertEquals(1, parseOrFail("0.01").precision);
    assertEquals(1, parseOrFail("0.1").scale);
    assertEquals(1, parseOrFail("0.1").precision);
    assertEquals(0, decimalNumber(1).scale);
    assertEquals(1, decimalNumber(1).precision);
    assertEquals(0, decimalNumber(10).scale);
    assertEquals(2, decimalNumber(10).precision);
    assertEquals(0, decimalNumber(100).scale);
    assertEquals(3, decimalNumber(100).precision);
    
}

shared void decimalTests() {

    instantiationAndEquality();
    parse();
    strictEqualsAndHash();
    plus();
    minus();
    times();
    divided();
    power();
    dividedAndTruncated();
    remainder();
    scalePrecision();
}