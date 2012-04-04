import com.redhat.ceylon.sdk.test{...}
import ceylon.math.decimal{
    Decimal, rounding,
    halfUp, halfDown, halfEven, up, down, ceiling, floor,  
    parseDecimal, toDecimal, zero, one, ten, computeWithRounding}
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
    assert(zero == zero, "zero==zero");
    assert(zero != one, "zero!=one");
    assert(one == one, "one==one");
    assert(zero== toDecimal(0), "zero==0");
    assert(one == toDecimal(1), "one==1");
    assert(toDecimal(1) == toDecimal(1), "1==1");
    assert(toDecimal(0) != toDecimal(1), "0!=1");
    assert(toDecimal(1) != toDecimal(2), "1!=2");
}

void parse() {
    print("parseDecimal");
    assertEquals(one, parseDecimal("1"), "parseDecimal(1)");
    assertEquals(toDecimal(-1), parseDecimal("-1"), "parseDecimal(-1)");
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
    assertFalse(toDecimal(1).strictlyEquals(parseOrFail("1.0")), "1.strictEquals(1.0)");
    assertFalse(toDecimal(1).strictlyEquals(parseOrFail("1.00")), "1.strictEquals(1.00)");
    print("hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.0").hash, "2.hash==2.0.hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.00").hash, "2.hash==2.0.hash");
}

void plus() {
    print("Decimal.plus");
    assertEquals(toDecimal(2), toDecimal(1.0).plus(toDecimal(1)), "1.0.plus(1)", strictly);
    assertEquals(toDecimal(2), toDecimal(1.0) + toDecimal(1), "1.0+1", strictly);
    variable value r := rounding(3, halfUp);
    assertEquals(parseDecimal("2.00"), parseOrFail("1.000").plusWithRounding(toDecimal(1), r), "1.000.plusWithRounding(1, r)", strictly);
    assertEquals(parseDecimal("2.01"), toDecimal(2).plusWithRounding(parseOrFail("0.005"), r), "2.plusWithRounding(0.005, r)", strictly);
    variable value a := parseOrFail("0.100");
    variable value b := parseOrFail("0.01");
    function calculation() {
        return a + b;
    }
    r := rounding(2, halfUp);
    assertEquals(parseDecimal("0.11"), computeWithRounding(calculation, r), "0.100+0.01", strictly);
    a := parseOrFail("0.105");
    assertEquals(parseDecimal("0.12"), computeWithRounding(calculation, r), "0.105+0.01", strictly);
}

void minus() {
    print("Decimal.minus");
    assertEquals(toDecimal(0), toDecimal(1.0).minus(toDecimal(1)), "1.0.minus(1)", strictly);
    assertEquals(toDecimal(0), toDecimal(1.0) - toDecimal(1), "1.0-1", strictly);
    variable value r := rounding(2, halfUp);
    assertEquals(parseDecimal("0.000"), parseOrFail("1.000").minusWithRounding(toDecimal(1), r), "1.000.minusWithRounding(1, r)", strictly);
    r := rounding(3, halfUp);
    assertEquals(parseDecimal("2.00"), toDecimal(2).minusWithRounding(parseOrFail("0.005"), r), "2.minusWithRounding(0.005, r)", strictly);
    variable value a := parseOrFail("0.100");
    variable value b := parseOrFail("0.01");
    function calculation() {
        return a - b;
    }
    r := rounding(2, halfUp);
    assertEquals(parseDecimal("0.090"), computeWithRounding(calculation, r), "0.100-0.01", strictly);
    a := parseOrFail("0.105");
    assertEquals(parseDecimal("0.095"), computeWithRounding(calculation, r), "0.105-0.01", strictly);
}

void times() {
    print("Decimal.times");
    assertEquals(toDecimal(4), toDecimal(2.0).times(toDecimal(2)), "2.0.times(2)", strictly);
    assertEquals(toDecimal(4), toDecimal(2.0) * toDecimal(2), "2.0*2", strictly);
    variable value r := rounding(3, halfUp);
    assertEquals(parseDecimal("1.00"), parseOrFail("1.000").timesWithRounding(toDecimal(1), r), "1.000.timesWithRounding(1, r)", strictly);
    assertEquals(parseDecimal("1.00"), toDecimal(2).timesWithRounding(parseOrFail("0.500"), r), "2.timesWithRounding(0.500, r)", strictly);
    variable value a := parseOrFail("0.100");
    variable value b := parseOrFail("0.1");
    function calculation() {
        return a * b;
    }
    assertEquals(parseDecimal("0.0100"), computeWithRounding(calculation, r), "0.100 * 0.01", strictly);
    a := parseOrFail("0.105");
    assertEquals(parseDecimal("0.0105"), computeWithRounding(calculation, r), "0.105 * 0.01", strictly);
}

void divided() {
    print("Decimal.divided");
    variable value r := rounding(3, halfUp);
    assertEquals(toDecimal(2), toDecimal(4.0).divided(toDecimal(2)), "4.0.divided(2)", strictly);
    assertEquals(toDecimal(2), toDecimal(4.0) / toDecimal(2), "4.0/2", strictly);
    try {
        Decimal oneThird = toDecimal(1) / toDecimal(3);
        fail("1/3");
    } catch (ArithmeticException e) {
        // non-terminating decimal
    }
    assertEquals(parseDecimal("0.333"), toDecimal(1).dividedWithRounding(toDecimal(3), r), "1.dividedWithRounding(3, r)", strictly);
    assertEquals(parseDecimal("0.667"), toDecimal(2).dividedWithRounding(toDecimal(3), r), "2.dividedWithRounding(3, r)", strictly);
    
    variable Decimal numerator := one;
    variable Decimal denominator :=  toDecimal(3);
    function calculation() {
        return numerator / denominator;
    }
    assertEquals(parseDecimal("0.333"), computeWithRounding(calculation, r), "", strictly);
    numerator := one+one;
    assertEquals(parseDecimal("0.667"), computeWithRounding(calculation, r), "", strictly);
}

shared void decimalTests() {

    instantiationAndEquality();    
    parse();
    strictEqualsAndHash();
    plus();
    minus();
    times();   
    divided();   
}