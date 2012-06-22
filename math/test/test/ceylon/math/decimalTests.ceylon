import com.redhat.ceylon.sdk.test{...}
import ceylon.math.decimal{
    Decimal, rounding,
    halfUp, halfDown, halfEven, up, down, ceiling, floor,
    parseDecimal, decimal, zero, one, ten, implicitlyRounded}
import java.lang{ArithmeticException}

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
    return !exists got;
}

Decimal parseOrFail(String str) {
    Decimal? result = parseDecimal(str);
    if (exists result) {
        return result;
    }
    throw AssertionFailed("" str " didn't parse");
}

void instantiationAndEquality() {
    print("Decimal instantiation, equality");
    assertTrue(zero == zero, "zero==zero");
    assertTrue(zero != one, "zero!=one");
    assertTrue(one == one, "one==one");
    assertTrue(zero== decimal(0), "zero==0");
    assertTrue(one == decimal(1), "one==1");
    assertTrue(decimal(1) == decimal(1), "1==1");
    assertTrue(decimal(0) != decimal(1), "0!=1");
    assertTrue(decimal(1) != decimal(2), "1!=2");
}

void parse() {
    print("parseDecimal");
    assertEquals(one, parseDecimal("1"), "parseDecimal(1)");
    assertEquals(decimal(-1), parseDecimal("-1"), "parseDecimal(-1)");
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
    assertFalse(decimal(1).strictlyEquals(parseOrFail("1.0")), "1.strictEquals(1.0)");
    assertFalse(decimal(1).strictlyEquals(parseOrFail("1.00")), "1.strictEquals(1.00)");
    print("hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.0").hash, "2.hash==2.0.hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.00").hash, "2.hash==2.0.hash");
}

void plus() {
    print("Decimal.plus");
    assertEquals(decimal(2), decimal(1.0).plus(decimal(1)), "1.0.plus(1)", strictly);
    assertEquals(decimal(2), decimal(1.0) + decimal(1), "1.0+1", strictly);
    variable value r := rounding(3, halfUp);
    assertEquals(parseDecimal("2.00"), parseOrFail("1.000").plusRounded(decimal(1), r), "1.000.plusWithRounding(1, r)", strictly);
    assertEquals(parseDecimal("2.01"), decimal(2).plusRounded(parseOrFail("0.005"), r), "2.plusWithRounding(0.005, r)", strictly);
    variable value a := parseOrFail("0.100");
    variable value b := parseOrFail("0.01");
    function calculation() {
        return a + b;
    }
    r := rounding(2, halfUp);
    assertEquals(parseDecimal("0.11"), implicitlyRounded(calculation, r), "0.100+0.01", strictly);
    a := parseOrFail("0.105");
    assertEquals(parseDecimal("0.12"), implicitlyRounded(calculation, r), "0.105+0.01", strictly);
}

void minus() {
    print("Decimal.minus");
    assertEquals(decimal(0), decimal(1.0).minus(decimal(1)), "1.0.minus(1)", strictly);
    assertEquals(decimal(0), decimal(1.0) - decimal(1), "1.0-1", strictly);
    variable value r := rounding(2, halfUp);
    assertEquals(parseDecimal("0.000"), parseOrFail("1.000").minusRounded(decimal(1), r), "1.000.minusWithRounding(1, r)", strictly);
    r := rounding(3, halfUp);
    assertEquals(parseDecimal("2.00"), decimal(2).minusRounded(parseOrFail("0.005"), r), "2.minusWithRounding(0.005, r)", strictly);
    variable value a := parseOrFail("0.100");
    variable value b := parseOrFail("0.01");
    function calculation() {
        return a - b;
    }
    r := rounding(2, halfUp);
    assertEquals(parseDecimal("0.090"), implicitlyRounded(calculation, r), "0.100-0.01", strictly);
    a := parseOrFail("0.105");
    assertEquals(parseDecimal("0.095"), implicitlyRounded(calculation, r), "0.105-0.01", strictly);
}

void times() {
    print("Decimal.times");
    assertEquals(decimal(4), decimal(2.0).times(decimal(2)), "2.0.times(2)", strictly);
    assertEquals(decimal(4), decimal(2.0) * decimal(2), "2.0*2", strictly);
    variable value r := rounding(3, halfUp);
    assertEquals(parseDecimal("1.00"), parseOrFail("1.000").timesRounded(decimal(1), r), "1.000.timesWithRounding(1, r)", strictly);
    assertEquals(parseDecimal("1.00"), decimal(2).timesRounded(parseOrFail("0.500"), r), "2.timesWithRounding(0.500, r)", strictly);
    variable value a := parseOrFail("0.100");
    variable value b := parseOrFail("0.1");
    function calculation() {
        return a * b;
    }
    assertEquals(parseDecimal("0.0100"), implicitlyRounded(calculation, r), "0.100 * 0.01", strictly);
    a := parseOrFail("0.105");
    assertEquals(parseDecimal("0.0105"), implicitlyRounded(calculation, r), "0.105 * 0.01", strictly);
}

void divided() {
    print("Decimal.divided");
    variable value r := rounding(3, halfUp);
    assertEquals(decimal(2), decimal(4.0).divided(decimal(2)), "4.0.divided(2)", strictly);
    assertEquals(decimal(2), decimal(4.0) / decimal(2), "4.0/2", strictly);
    try {
        Decimal oneThird = decimal(1) / decimal(3);
        fail("1/3");
    } catch (ArithmeticException e) {
        // non-terminating decimal
    }
    assertEquals(parseDecimal("0.333"), decimal(1).dividedRounded(decimal(3), r), "1.dividedWithRounding(3, r)", strictly);
    assertEquals(parseDecimal("0.667"), decimal(2).dividedRounded(decimal(3), r), "2.dividedWithRounding(3, r)", strictly);

    variable Decimal numerator := one;
    variable Decimal denominator :=  decimal(3);
    function calculation() {
        return numerator / denominator;
    }
    assertEquals(parseDecimal("0.333"), implicitlyRounded(calculation, r), "", strictly);
    numerator := one+one;
    assertEquals(parseDecimal("0.667"), implicitlyRounded(calculation, r), "", strictly);
}

void power() {
    print("Decimal.power");
    assertEquals(decimal(4), decimal(2)**decimal(2), "2**2");
    assertEquals(decimal(8), decimal(2)**decimal(3), "2**3");
    assertEquals(parseOrFail("0.25"), parseOrFail("0.5")**decimal(2), "0.5**2");
    try {
        Decimal d = decimal(2)**decimal(-2);
        fail();
    } catch (Exception e) {
    }
    try {
        Decimal d = decimal(2)**parseOrFail("0.5");
        fail();
    } catch (Exception e) {
        
    }
    try {
        Decimal d = decimal(2)**parseOrFail("100000000000000000000000000000000000000000000");
        fail();
    } catch (Exception e) {
        
    }

    value r = rounding(2, halfUp);
    assertEquals(parseOrFail("0.25"),
        decimal(2).powerRounded(-2, r),
        "0.25.powerWithRounding(-2, 2halfUp))", strictly);
        
    variable value a := parseOrFail("2");
    variable value b := decimal(-2);
    function calculation() {
        return a ** b;
    }
    assertEquals(parseDecimal("0.25"), implicitlyRounded(calculation, r), "2 ** -2", strictly);
}

void dividedAndTruncated() {
    print("Decimal.dividedAndTruncated");
    variable value r := rounding(3, halfUp);
    assertEquals(parseDecimal("0"), decimal(2).dividedTruncated(decimal(3), r), "2.dividedAndTruncated(3)", strictly);
    assertEquals(parseDecimal("1"), decimal(3).dividedTruncated(decimal(2), r), "3.dividedAndTruncated(2)", strictly);
    assertEquals(parseDecimal("-1"), decimal(-3).dividedTruncated(decimal(2), r), "-3.dividedAndTruncated(2)", strictly);
}

void remainder() {
    print("Decimal.remainder");
    variable value r := rounding(3, halfUp);
    assertEquals(parseDecimal("2"), decimal(2).remainderRounded(decimal(3), r), "2.remainder(3)", strictly);
    assertEquals(parseDecimal("1"), decimal(3).remainderRounded(decimal(2), r), "3.remainder(2)", strictly);
}

void scalePrecision() {
    print("Decimal.scale and .precision");
    assertEquals(3, parseOrFail("0.001").scale);
    assertEquals(1, parseOrFail("0.001").precision);
    assertEquals(2, parseOrFail("0.01").scale);
    assertEquals(1, parseOrFail("0.01").precision);
    assertEquals(1, parseOrFail("0.1").scale);
    assertEquals(1, parseOrFail("0.1").precision);
    assertEquals(0, decimal(1).scale);
    assertEquals(1, decimal(1).precision);
    assertEquals(0, decimal(10).scale);
    assertEquals(2, decimal(10).precision);
    assertEquals(0, decimal(100).scale);
    assertEquals(3, decimal(100).precision);
    
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