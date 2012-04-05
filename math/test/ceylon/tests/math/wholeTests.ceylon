import com.redhat.ceylon.sdk.test{...}
import ceylon.math.whole{Whole, parseWhole, toWhole, one, zero}

shared void wholeTests() {

    Whole parseOrFail(String str) {
       Whole? result = parseWhole(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }
    
    print("Whole instantiation, equality");
    assert(zero == zero, "zero==zero");
    assert(one == one, "one==one");
    assert(zero != one, "zero!=one");
    assert(zero == toWhole(0), "zero==0");
    assert(one == toWhole(1), "one==1");
    assert(zero != toWhole(2), "zero!=2");
    assert(one != toWhole(2), "one!=2");
    assert(toWhole(1) == toWhole(1), "1==1");
    assert(toWhole(1) != toWhole(2), "1!=2");
    assert(toWhole(2) == toWhole(2), "2==2");
    
    print("parseWhole");
    assertEquals(toWhole(1), parseWhole("1"), "parseWhole");
    assertEquals(toWhole(0), parseWhole("0"), "parseWhole");
    assertEquals(toWhole(1), parseWhole("001"), "parseWhole");
    assertEquals(toWhole(-1), parseWhole("-1"), "parseWhole");
    assertNotNull(parseOrFail("1000000000000000000000000000000000000"));
    assertNull(parseWhole("a"));
    assertNull(parseWhole("1a"));
    assertNull(parseWhole("a1"));
    assertNull(parseWhole("1.0"));
    assertNull(parseWhole("1.-0"));
    
    print("Whole.string");
    assert("1" == toWhole(1).string, "1.string");
    assert("-1" == toWhole(-1).string, "-1.string");
    assertEquals("1000000000000000000000000000000000000", parseOrFail("1000000000000000000000000000000000000").string, ".string");
    
    print("Whole.plus");
    assert(toWhole(2) == toWhole(1).plus(toWhole(1)), "1.plus(1)");
    assert(toWhole(2) == toWhole(1) + toWhole(1), "1+1");
    
    print("Whole.minus");
    assert(toWhole(0) == toWhole(1).minus(toWhole(1)), "1.minus(1)");
    assert(toWhole(0) == toWhole(1) - toWhole(1), "1-1");
    
    print("Whole.times");
    assert(toWhole(4) == toWhole(2).times(toWhole(2)), "2.times(2)");
    assert(toWhole(4) == toWhole(2) * toWhole(2), "2*2");
    
    print("Whole.divided");
    assert(toWhole(2) == toWhole(4).divided(toWhole(2)), "4.divided(2)");
    assert(toWhole(2) == toWhole(4) / toWhole(2), "4/2");
    
    print("Whole.remainder");
    assertEquals(toWhole(0), toWhole(4).remainder(toWhole(2)), "4.remainder(2)");
    assertEquals(toWhole(0), toWhole(4) % toWhole(2), "4%2");
    
    print("Whole.power");
    assertEquals(toWhole(4), toWhole(2).power(toWhole(2)), "2.power(2)");
    assertEquals(toWhole(4), toWhole(2) ** toWhole(2), "2**2");
    
    assertEquals(toWhole(1), toWhole(1) ** toWhole(1), "1**1");
    assertEquals(toWhole(1), toWhole(1) ** toWhole(0), "1**0");
    assertEquals(toWhole(1), toWhole(1) ** toWhole(-1), "1**-1");
    assertEquals(toWhole(1), toWhole(1) ** toWhole(-2), "1**-2");
    
    assertEquals(toWhole(0), toWhole(0) ** toWhole(1), "0**1");
    assertEquals(toWhole(1), toWhole(0) ** toWhole(0), "0**0");
    try {
        Whole w = toWhole(0) ** toWhole(-1);
        fail("0**-1");
    } catch (Exception e){}
    try {
        Whole w = toWhole(0) ** toWhole(-2);
        fail("0**-2");
    } catch (Exception e){}
    
    assertEquals(toWhole(-1), toWhole(-1) ** toWhole(1), "-1**1");
    assertEquals(toWhole(1), toWhole(-1) ** toWhole(0), "-1**0");
    assertEquals(toWhole(-1), toWhole(-1) ** toWhole(-1), "-1**-1");
    assertEquals(toWhole(1), toWhole(-1) ** toWhole(-2), "-1**-2");
    
    assertEquals(toWhole(-2), toWhole(-2) ** toWhole(1), "-2**-1");
    assertEquals(toWhole(1), toWhole(-2) ** toWhole(0), "-2**0");
    try {
        Whole w = toWhole(-2) ** toWhole(-1);
        fail("-2**-1");
    } catch (Exception e){}
    try {
        Whole w = toWhole(-2) ** toWhole(-2);
        fail("-2**-2");
    } catch (Exception e){}
    
    print("Whole comparison");
    assert(larger == toWhole(2).compare(toWhole(1)), "2.compare(1)");
    assert(toWhole(2) > toWhole(1), "2>1");
    assert(smaller == toWhole(1).compare(toWhole(2)), "1.compare(2)");
    assert(toWhole(1) < toWhole(2), "1<2");
    
    print("Whole predicates");
    assert(toWhole(2).positive, "2.positive");
    assert(!toWhole(-2).positive, "-2.positive");
    assert(!zero.positive, "zero.positive");
    assert(!toWhole(2).negative, "2.negative");
    assert(toWhole(-2).negative, "-2.negative");
    assert(!zero.negative, "zero.negative");
    assert(!toWhole(1).zero, "1.zero");
    assert(toWhole(0).zero, "0.zero");
    assert(toWhole(1).unit, "1.unit");
    assert(!toWhole(0).unit, "0.unit");
    
    print("Whole.hash");
    assertEquals(0, toWhole(0).hash, "0.hash");
    assertEquals(1, toWhole(1).hash, "1.hash");
    assertEquals(2, toWhole(2).hash, "2.hash");
    
    print("Whole *cessor");
    assertEquals(toWhole(2), toWhole(1).successor, "1.successor");
    assertEquals(toWhole(0), toWhole(1).predecessor, "1.predecessor");
    variable Whole w := toWhole(0);
    assertEquals(toWhole(1), ++w, "++0");
    assertEquals(toWhole(0), --w, "--1");
    
    print("Whole conversion");
    assertEquals(2, toWhole(2).integer, "2.integer");
    assertEquals(2.0, toWhole(2).float, "2.float");
    
    print("Whole misc");
    assertEquals(toWhole(2), toWhole(2).positiveValue, "2.positiveValue");
    assertEquals(toWhole(-2), toWhole(2).negativeValue, "2.negativeValue");
    assertEquals(toWhole(0), toWhole(0).positiveValue, "0.positiveValue");
    assertEquals(toWhole(0), toWhole(0).negativeValue, "0.negativeValue");
    assertEquals(toWhole(2), toWhole(2).magnitude, "2.magnitude");
    assertEquals(toWhole(2), toWhole(-2).magnitude, "-2.magnitude");
    assertEquals(toWhole(2), toWhole(2).wholePart, "2.wholePart");
    assertEquals(toWhole(-2), toWhole(-2).wholePart, "-2.wholePart");
    assertEquals(toWhole(0), toWhole(2).fractionalPart, "2.fractionalPart");
    assertEquals(toWhole(0), toWhole(-2).fractionalPart, "-2.fractionalPart");
    assertEquals(+1, toWhole(2).sign, "2.sign");
    assertEquals(0, toWhole(0).sign, "0.sign");
    assertEquals(-1, toWhole(-2).sign, "-2.sign");
    
    // TODO castTo
    
    //print("gcd");
    //assertEquals(Whole(6), gcd(Whole(12), Whole(18)), "gcd(12, 18)");
    
}