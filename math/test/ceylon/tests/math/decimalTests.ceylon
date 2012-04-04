import com.redhat.ceylon.sdk.test{...}
import ceylon.math.decimal{
    Decimal, Rounding,
    halfUp, halfDown, halfEven, up, down, ceiling, floor,  
    parseDecimal, toDecimal, zero, one, ten, computeWithRounding}
import java.lang{ArithmeticException}

shared void decimalTests() {

    Decimal parseOrFail(String str) {
       Decimal? result = parseDecimal(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }    

    print("Decimal instantiation, equality");
    assert(zero == zero, "zero==zero");
    assert(zero != one, "zero!=one");
    assert(one == one, "one==one");
    assert(zero== toDecimal(0), "zero==0");
    assert(one == toDecimal(1), "one==1");
    assert(toDecimal(1) == toDecimal(1), "1==1");
    assert(toDecimal(0) != toDecimal(1), "0!=1");
    assert(toDecimal(1) != toDecimal(2), "1!=2");
    
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
    
    print("Decimal.strictEquals");
    assertFalse(toDecimal(1).strictlyEquals(parseOrFail("1.0")), "1.strictEquals(1.0)");
    assertFalse(toDecimal(1).strictlyEquals(parseOrFail("1.00")), "1.strictEquals(1.00)");
    
    print("Decimal.plus");
	assertEquals(toDecimal(2), toDecimal(1.0).plus(toDecimal(1)), "1.0.plus(1)");
	assertEquals(toDecimal(2), toDecimal(1.0) + toDecimal(1), "1.0+1");
	
	print("Decimal.minus");
    assertEquals(toDecimal(0), toDecimal(1.0).minus(toDecimal(1)), "1.0.minus(1)");
    assertEquals(toDecimal(0), toDecimal(1.0) - toDecimal(1), "1.0-1");
    
    print("Decimal.times");
    assertEquals(toDecimal(4), toDecimal(2.0).times(toDecimal(2)), "2.0.times(2)");
    assertEquals(toDecimal(4), toDecimal(2.0) * toDecimal(2), "2.0*2");
    
    print("Decimal.divided");
    assertEquals(toDecimal(2), toDecimal(4.0).divided(toDecimal(2)), "4.0.divided(2)");
    assertEquals(toDecimal(2), toDecimal(4.0) / toDecimal(2), "4.0/2");
    try {
        Decimal oneThird = toDecimal(1) / toDecimal(3);
        fail("1/3");
    } catch (ArithmeticException e) {
        // non-terminating decimal
    }
    variable Decimal numerator := one;
    variable Decimal denominator :=  toDecimal(3);
    function division() {
        return numerator / denominator;
    }
    numerator := one+one;
    assertEquals(parseDecimal("0.67"), computeWithRounding(division, Rounding(2, halfUp)));

    print("hash");    
    assertEquals(parseOrFail("2").hash, parseOrFail("2.0").hash, "2.hash==2.0.hash");
    assertEquals(parseOrFail("2").hash, parseOrFail("2.00").hash, "2.hash==2.0.hash");
}
