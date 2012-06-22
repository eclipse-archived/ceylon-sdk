import com.redhat.ceylon.sdk.test{...}
import ceylon.math.whole{Whole, parseWhole, whole, one, zero}

shared void wholeTests() {

    Whole parseOrFail(String str) {
       Whole? result = parseWhole(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }

    print("Whole instantiation, equality");
    assertTrue(zero == zero, "zero==zero");
    assertTrue(one == one, "one==one");
    assertTrue(zero != one, "zero!=one");
    assertTrue(zero == whole(0), "zero==0");
    assertTrue(one == whole(1), "one==1");
    assertTrue(zero != whole(2), "zero!=2");
    assertTrue(one != whole(2), "one!=2");
    assertTrue(whole(1) == whole(1), "1==1");
    assertTrue(whole(1) != whole(2), "1!=2");
    assertTrue(whole(2) == whole(2), "2==2");

    print("parseWhole");
    assertEquals(whole(1), parseWhole("1"), "parseWhole");
    assertEquals(whole(0), parseWhole("0"), "parseWhole");
    assertEquals(whole(1), parseWhole("001"), "parseWhole");
    assertEquals(whole(-1), parseWhole("-1"), "parseWhole");
    assertNotNull(parseOrFail("1000000000000000000000000000000000000"));
    assertNull(parseWhole("a"));
    assertNull(parseWhole("1a"));
    assertNull(parseWhole("a1"));
    assertNull(parseWhole("1.0"));
    assertNull(parseWhole("1.-0"));

    print("Whole.string");
    assertTrue("1" == whole(1).string, "1.string");
    assertTrue("-1" == whole(-1).string, "-1.string");
    assertEquals("1000000000000000000000000000000000000", parseOrFail("1000000000000000000000000000000000000").string, ".string");

    print("Whole.plus");
    assertTrue(whole(2) == whole(1).plus(whole(1)), "1.plus(1)");
    assertTrue(whole(2) == whole(1) + whole(1), "1+1");

    print("Whole.minus");
    assertTrue(whole(0) == whole(1).minus(whole(1)), "1.minus(1)");
    assertTrue(whole(0) == whole(1) - whole(1), "1-1");

    print("Whole.times");
    assertTrue(whole(4) == whole(2).times(whole(2)), "2.times(2)");
    assertTrue(whole(4) == whole(2) * whole(2), "2*2");

    print("Whole.divided");
    assertTrue(whole(2) == whole(4).divided(whole(2)), "4.divided(2)");
    assertTrue(whole(2) == whole(4) / whole(2), "4/2");

    print("Whole.remainder");
    assertEquals(whole(0), whole(4).remainder(whole(2)), "4.remainder(2)");
    assertEquals(whole(0), whole(4) % whole(2), "4%2");

    print("Whole.power");
    assertEquals(whole(4), whole(2).power(whole(2)), "2.power(2)");
    assertEquals(whole(4), whole(2) ** whole(2), "2**2");

    assertEquals(whole(1), whole(1) ** whole(1), "1**1");
    assertEquals(whole(1), whole(1) ** whole(0), "1**0");
    assertEquals(whole(1), whole(1) ** whole(-1), "1**-1");
    assertEquals(whole(1), whole(1) ** whole(-2), "1**-2");

    assertEquals(whole(0), whole(0) ** whole(1), "0**1");
    assertEquals(whole(1), whole(0) ** whole(0), "0**0");
    try {
        Whole w = whole(0) ** whole(-1);
        fail("0**-1");
    } catch (Exception e){}
    try {
        Whole w = whole(0) ** whole(-2);
        fail("0**-2");
    } catch (Exception e){}

    assertEquals(whole(-1), whole(-1) ** whole(1), "-1**1");
    assertEquals(whole(1), whole(-1) ** whole(0), "-1**0");
    assertEquals(whole(-1), whole(-1) ** whole(-1), "-1**-1");
    assertEquals(whole(1), whole(-1) ** whole(-2), "-1**-2");

    assertEquals(whole(-2), whole(-2) ** whole(1), "-2**-1");
    assertEquals(whole(1), whole(-2) ** whole(0), "-2**0");
    try {
        Whole w = whole(-2) ** whole(-1);
        fail("-2**-1");
    } catch (Exception e){}
    try {
        Whole w = whole(-2) ** whole(-2);
        fail("-2**-2");
    } catch (Exception e){}

    print("Whole comparison");
    assertTrue(larger == whole(2).compare(whole(1)), "2.compare(1)");
    assertTrue(whole(2) > whole(1), "2>1");
    assertTrue(smaller == whole(1).compare(whole(2)), "1.compare(2)");
    assertTrue(whole(1) < whole(2), "1<2");

    print("Whole predicates");
    assertTrue(whole(2).positive, "2.positive");
    assertTrue(!whole(-2).positive, "-2.positive");
    assertTrue(!zero.positive, "zero.positive");
    assertTrue(!whole(2).negative, "2.negative");
    assertTrue(whole(-2).negative, "-2.negative");
    assertTrue(!zero.negative, "zero.negative");
    assertTrue(!whole(1).zero, "1.zero");
    assertTrue(whole(0).zero, "0.zero");
    assertTrue(whole(1).unit, "1.unit");
    assertTrue(!whole(0).unit, "0.unit");

    print("Whole.hash");
    assertEquals(0, whole(0).hash, "0.hash");
    assertEquals(1, whole(1).hash, "1.hash");
    assertEquals(2, whole(2).hash, "2.hash");

    print("Whole *cessor");
    assertEquals(whole(2), whole(1).successor, "1.successor");
    assertEquals(whole(0), whole(1).predecessor, "1.predecessor");
    variable Whole w := whole(0);
    assertEquals(whole(1), ++w, "++0");
    assertEquals(whole(0), --w, "--1");

    print("Whole conversion");
    assertEquals(2, whole(2).integer, "2.integer");
    assertEquals(2.0, whole(2).float, "2.float");

    print("Whole misc");
    assertEquals(whole(2), whole(2).positiveValue, "2.positiveValue");
    assertEquals(whole(-2), whole(2).negativeValue, "2.negativeValue");
    assertEquals(whole(0), whole(0).positiveValue, "0.positiveValue");
    assertEquals(whole(0), whole(0).negativeValue, "0.negativeValue");
    assertEquals(whole(2), whole(2).magnitude, "2.magnitude");
    assertEquals(whole(2), whole(-2).magnitude, "-2.magnitude");
    assertEquals(whole(2), whole(2).wholePart, "2.wholePart");
    assertEquals(whole(-2), whole(-2).wholePart, "-2.wholePart");
    assertEquals(whole(0), whole(2).fractionalPart, "2.fractionalPart");
    assertEquals(whole(0), whole(-2).fractionalPart, "-2.fractionalPart");
    assertEquals(+1, whole(2).sign, "2.sign");
    assertEquals(0, whole(0).sign, "0.sign");
    assertEquals(-1, whole(-2).sign, "-2.sign");

    // TODO castTo

    //print("gcd");
    //assertEquals(Whole(6), gcd(Whole(12), Whole(18)), "gcd(12, 18)");

}