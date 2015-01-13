import ceylon.test { ... }
import ceylon.math.whole{Whole, parseWhole, wholeNumber, one, two, zero}

test void wholeTests() {

    Whole parseOrFail(String str) {
       Whole? result = parseWhole(str);
       if (exists result) {
           return result;
       }
       throw AssertionError("``str`` didn't parse");
    }

    print("Whole instantiation, equality");
    assertTrue(zero == zero, "zero==zero");
    assertTrue(one == one, "one==one");
    assertTrue(zero != one, "zero!=one");
    assertTrue(zero == wholeNumber(0), "zero==0");
    assertTrue(one == wholeNumber(1), "one==1");
    assertTrue(zero != wholeNumber(2), "zero!=2");
    assertTrue(one != wholeNumber(2), "one!=2");
    assertTrue(wholeNumber(1) == wholeNumber(1), "1==1");
    assertTrue(wholeNumber(1) != wholeNumber(2), "1!=2");
    assertTrue(wholeNumber(2) == wholeNumber(2), "2==2");

    print("parseWhole");
    assertEquals(wholeNumber(1), parseWhole("1"), "parseWhole");
    assertEquals(wholeNumber(0), parseWhole("0"), "parseWhole");
    assertEquals(wholeNumber(1), parseWhole("001"), "parseWhole");
    assertEquals(wholeNumber(-1), parseWhole("-1"), "parseWhole");
    assertNotNull(parseOrFail("1000000000000000000000000000000000000"));
    assertNull(parseWhole("a"));
    assertNull(parseWhole("1a"));
    assertNull(parseWhole("a1"));
    assertNull(parseWhole("1.0"));
    assertNull(parseWhole("1.-0"));

    print("Whole.string");
    assertTrue("1" == wholeNumber(1).string, "1.string");
    assertTrue("-1" == wholeNumber(-1).string, "-1.string");
    assertEquals("1000000000000000000000000000000000000", parseOrFail("1000000000000000000000000000000000000").string, ".string");

    print("Whole.plus");
    assertTrue(wholeNumber(2) == wholeNumber(1).plus(wholeNumber(1)), "1.plus(1)");
    assertTrue(wholeNumber(2) == wholeNumber(1) + wholeNumber(1), "1+1");

    print("Whole.minus");
    assertTrue(wholeNumber(0) == wholeNumber(1).minus(wholeNumber(1)), "1.minus(1)");
    assertTrue(wholeNumber(0) == wholeNumber(1) - wholeNumber(1), "1-1");

    print("Whole.times");
    assertTrue(wholeNumber(4) == wholeNumber(2).times(wholeNumber(2)), "2.times(2)");
    assertTrue(wholeNumber(4) == wholeNumber(2) * wholeNumber(2), "2*2");

    print("Whole.divided");
    assertTrue(wholeNumber(2) == wholeNumber(4).divided(wholeNumber(2)), "4.divided(2)");
    assertTrue(wholeNumber(2) == wholeNumber(4) / wholeNumber(2), "4/2");

    print("Whole.remainder");
    assertEquals(wholeNumber(0), wholeNumber(4).remainder(wholeNumber(2)), "4.remainder(2)");
    assertEquals(wholeNumber(0), wholeNumber(4) % wholeNumber(2), "4%2");
    assertEquals(wholeNumber(-2), wholeNumber(-5) % wholeNumber(3), "(-5)%3");

    print("Whole.mod");
    assertEquals(wholeNumber(5).mod(wholeNumber(3)), wholeNumber(2), "5.mod(2)");
    assertEquals(wholeNumber(-5).mod(wholeNumber(3)), wholeNumber(1), "(-5).mod(2)");

    print("Whole.power");
    assertEquals(wholeNumber(4), wholeNumber(2).power(wholeNumber(2)), "2.power(2)");
    assertEquals(wholeNumber(4), wholeNumber(2) ^ wholeNumber(2), "2^2");

    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(1), "1^1");
    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(0), "1^0");
    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(-1), "1^-1");
    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(-2), "1^-2");

    assertEquals(wholeNumber(0), wholeNumber(0) ^ wholeNumber(1), "0^1");
    assertEquals(wholeNumber(1), wholeNumber(0) ^ wholeNumber(0), "0^0");
    try {
        Whole wn = wholeNumber(0) ^ wholeNumber(-1);
        fail("0^-1");
    } catch (AssertionError e){}
    try {
        Whole wn = wholeNumber(0) ^ wholeNumber(-2);
        fail("0^-2");
    } catch (AssertionError e){}

    assertEquals(wholeNumber(-1), wholeNumber(-1) ^ wholeNumber(1), "-1^1");
    assertEquals(wholeNumber(1), wholeNumber(-1) ^ wholeNumber(0), "-1^0");
    assertEquals(wholeNumber(-1), wholeNumber(-1) ^ wholeNumber(-1), "-1^-1");
    assertEquals(wholeNumber(1), wholeNumber(-1) ^ wholeNumber(-2), "-1^-2");

    assertEquals(wholeNumber(-2), wholeNumber(-2) ^ wholeNumber(1), "-2^-1");
    assertEquals(wholeNumber(1), wholeNumber(-2) ^ wholeNumber(0), "-2^0");
    try {
        Whole wn = wholeNumber(-2) ^ wholeNumber(-1);
        fail("-2^-1");
    } catch (AssertionError e){}
    try {
        Whole wn = wholeNumber(-2) ^ wholeNumber(-2);
        fail("-2^-2");
    } catch (AssertionError e){}

    print("Whole comparison");
    assertTrue(larger == wholeNumber(2).compare(wholeNumber(1)), "2.compare(1)");
    assertTrue(wholeNumber(2) > wholeNumber(1), "2>1");
    assertTrue(smaller == wholeNumber(1).compare(wholeNumber(2)), "1.compare(2)");
    assertTrue(wholeNumber(1) < wholeNumber(2), "1<2");

    print("Whole predicates");
    assertTrue(wholeNumber(2).positive, "2.positive");
    assertTrue(!wholeNumber(-2).positive, "-2.positive");
    assertTrue(!zero.positive, "zero.positive");
    assertTrue(!wholeNumber(2).negative, "2.negative");
    assertTrue(wholeNumber(-2).negative, "-2.negative");
    assertTrue(!zero.negative, "zero.negative");
    assertTrue(!wholeNumber(1).zero, "1.zero");
    assertTrue(wholeNumber(0).zero, "0.zero");
    assertTrue(wholeNumber(1).unit, "1.unit");
    assertTrue(!wholeNumber(0).unit, "0.unit");

    print("Whole.hash");
    assertEquals(0, wholeNumber(0).hash, "0.hash");
    assertEquals(1, wholeNumber(1).hash, "1.hash");
    assertEquals(2, wholeNumber(2).hash, "2.hash");

    print("Whole *cessor");
    assertEquals(wholeNumber(2), wholeNumber(1).successor, "1.successor");
    assertEquals(wholeNumber(0), wholeNumber(1).predecessor, "1.predecessor");
    variable Whole w = wholeNumber(0);
    assertEquals(wholeNumber(1), ++w, "++0");
    assertEquals(wholeNumber(0), --w, "--1");

    print("Whole conversion");
    assertEquals(2, wholeNumber(2).integer, "2.integer");
    assertEquals(2.0, wholeNumber(2).float, "2.float");

    print("Whole misc");
    assertEquals(wholeNumber(-2), wholeNumber(2).negated, "2.negated");
    assertEquals(wholeNumber(0), wholeNumber(0).negated, "0.negated");
    assertEquals(wholeNumber(2), wholeNumber(2).magnitude, "2.magnitude");
    assertEquals(wholeNumber(2), wholeNumber(-2).magnitude, "-2.magnitude");
    assertEquals(wholeNumber(2), wholeNumber(2).wholePart, "2.wholePart");
    assertEquals(wholeNumber(-2), wholeNumber(-2).wholePart, "-2.wholePart");
    assertEquals(wholeNumber(0), wholeNumber(2).fractionalPart, "2.fractionalPart");
    assertEquals(wholeNumber(0), wholeNumber(-2).fractionalPart, "-2.fractionalPart");
    assertEquals(+1, wholeNumber(2).sign, "2.sign");
    assertEquals(0, wholeNumber(0).sign, "0.sign");
    assertEquals(-1, wholeNumber(-2).sign, "-2.sign");

    assertEquals([wholeNumber(1), wholeNumber(2)], one..two, "one..two");
    assertEquals([wholeNumber(2), wholeNumber(1)], two..one, "two..one");
    assertEquals([wholeNumber(0), wholeNumber(1), wholeNumber(2)], zero..two, "zero..two");
    assertEquals([wholeNumber(2), wholeNumber(1), wholeNumber(0)], two..zero, "two..zero");
    
    assertEquals(-1, one.offset(two), "one.offset(two)");
    assertEquals(-runtime.maxIntegerValue, zero.offset(wholeNumber(runtime.maxIntegerValue)));
    assertEquals(runtime.minIntegerValue, zero.offset(wholeNumber(runtime.maxIntegerValue)+one));
    try {
        value off = zero.offset(wholeNumber(runtime.maxIntegerValue)+two);
        fail("zero.offset(wholeNumber(runtime.maxIntegerValue)+two) returned ``off``");
    } catch (OverflowException e) {
        // checking this is thrown
    }
    

    //print("gcd");
    //assertEquals(Whole(6), gcd(Whole(12), Whole(18)), "gcd(12, 18)");

}