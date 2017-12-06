import ceylon.test { ... }
import ceylon.math.whole{Whole, parseWhole, wholeNumber, one, two, zero,
    formatWhole}

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

    print("Whole.modulo");
    assertEquals(wholeNumber(5).modulo(wholeNumber(3)), wholeNumber(2), "5.modulo(2)");
    assertEquals(wholeNumber(-5).modulo(wholeNumber(3)), wholeNumber(1), "(-5).modulo(2)");

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
        suppressWarnings("unusedDeclaration")
        Whole wn = wholeNumber(0) ^ wholeNumber(-1);
        fail("0^-1");
    } catch (AssertionError e){}
    try {
        suppressWarnings("unusedDeclaration")
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
        suppressWarnings("unusedDeclaration")
        Whole wn = wholeNumber(-2) ^ wholeNumber(-1);
        fail("-2^-1");
    } catch (AssertionError e){}
    try {
        suppressWarnings("unusedDeclaration")
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

test void formatWholeTests() {
    assertEquals("0", formatWhole(zero), "formatWhole(0)");
    assertEquals("1", formatWhole(one), "formatWhole(1)");
    assertEquals("-1", formatWhole(-one), "formatWhole(-1)");
    assertEquals("1234567890", formatWhole(wholeNumber(1234567890)), "formatWhole(1234567890)");
    assertEquals("-1234567890", formatWhole(wholeNumber(-1234567890)), "formatWhole(-1234567890)");
    assertEquals("-46", formatWhole(wholeNumber(-46)));
    assertEquals("1001", formatWhole(wholeNumber(9),2));
    assertEquals("12", formatWhole(wholeNumber(10),8));
    assertEquals("1ff", formatWhole(wholeNumber(511),16));
    assertEquals("g0", formatWhole(wholeNumber(512),32));
    try {
        formatWhole(zero, 1);
        fail("formatWhole(0, 1) should throw");
    } catch (AssertionError ex) {
        // OK
    }
    try {
        formatWhole(zero, 37);
        fail("formatWhole(0, 37) should throw");
    } catch (AssertionError ex) {
        // OK
    }
}

test void parseWholeTests() {
    assertTrue((parseWhole("-123") else 0)==wholeNumber(-123), "parseWhole(-123)");

    assertEquals(wholeNumber(1000), parseWhole("1000"), "parseWhole(1000)");
    assertEquals(wholeNumber(1k), parseWhole("1k"), "parseWhole(1k)");
    assertEquals(wholeNumber(+1000), parseWhole("+1000"), "parseWhole(+1000)");
    assertEquals(wholeNumber(+1k), parseWhole("+1k"), "parseWhole(+1k)");
    assertEquals(wholeNumber(-1000), parseWhole("-1000"), "parseWhole(-1000)");
    assertEquals(wholeNumber(-1k), parseWhole("-1k"), "parseWhole(-1k)");

    assertEquals(wholeNumber(0), parseWhole("0"), "parseWhole(0)");
    assertEquals(wholeNumber(00), parseWhole("00"), "parseWhole(00)");
    assertEquals(wholeNumber(0_000), parseWhole("0000"), "parseWhole(0_000)");
    assertEquals(wholeNumber(-00), parseWhole("-00"), "parseWhole(-00)");
    assertEquals(wholeNumber(+00), parseWhole("+00"), "parseWhole(+00)");
    assertEquals(wholeNumber(0k), parseWhole("0k"), "parseWhole(0k)");

    assertEquals(wholeNumber(1), parseWhole("1"), "parseWhole(1)");
    assertEquals(wholeNumber(01), parseWhole("01"), "parseWhole(01)");
    assertEquals(wholeNumber(0_001), parseWhole("0001"), "parseWhole(0_001)");
    assertEquals(wholeNumber(+1), parseWhole("+1"), "parseWhole(+1)");
    assertEquals(wholeNumber(+01), parseWhole("+01"), "parseWhole(+01)");
    assertEquals(wholeNumber(+0_001), parseWhole("+0001"), "parseWhole(+0_001)");

    assertEquals(wholeNumber(-1), parseWhole("-1"), "parseWhole(-1)");
    assertEquals(wholeNumber(-01), parseWhole("-01"), "parseWhole(-01)");
    assertEquals(wholeNumber(-0_001), parseWhole("-0001"), "parseWhole(-0_001)");

    assertEquals(wholeNumber(1k), parseWhole("1k"), "parseWhole(1k)");
    assertEquals(wholeNumber(1M), parseWhole("1M"), "parseWhole(1M)");
    assertEquals(wholeNumber(1G), parseWhole("1G"), "parseWhole(1G)");
    assertEquals(wholeNumber(1T), parseWhole("1T"), "parseWhole(1T)");
    assertEquals(wholeNumber(1P), parseWhole("1P"), "parseWhole(1P)");
    assertEquals(wholeNumber(-1k), parseWhole("-1k"), "parseWhole(-1k)");
    assertEquals(wholeNumber(-1M), parseWhole("-1M"), "parseWhole(-1M)");
    assertEquals(wholeNumber(-1G), parseWhole("-1G"), "parseWhole(-1G)");
    assertEquals(wholeNumber(-1T), parseWhole("-1T"), "parseWhole(-1T)");
    assertEquals(wholeNumber(-1P), parseWhole("-1P"), "parseWhole(-1P)");
    assertTrue(!parseWhole("1k", 2) exists, "!parseWhole(1k, 2) exists");

    assertEquals(wholeNumber($1111111), parseWhole("1111111", 2), "parseWhole(1111111, 2)");
    assertEquals(wholeNumber($1111111), parseWhole("01111111", 2), "parseWhole(01111111, 2)");
    assertEquals(wholeNumber($10000000), parseWhole("10000000", 2), "parseWhole(10000000, 2)");
    assertEquals(wholeNumber(-($110000)), parseWhole("-110000", 2), "parseWhole(-110000, 2)");
    assertEquals(wholeNumber($1010_0011_1111), parseWhole("101000111111", 2), "parseWhole(1010_0011_1111, 2)");
    assertEquals(wholeNumber($11_0110_0100), parseWhole("1101100100", 2), "parseWhole(11_0110_0100, 2)");
    assertTrue(!parseWhole("11_01_00", 2) exists, "!parseWhole(11_01_00, 2) exists");

    assertEquals(wholeNumber(1193046), parseWhole("123456", 16), "parseWhole(123456, 16)");
    assertEquals(wholeNumber(255), parseWhole("ff", 16), "parseWhole(ff, 16)");
    assertTrue(!parseWhole("fk", 16) exists, "parseWhole(fk, 16)");
    assertEquals(wholeNumber(#f_ffff), parseWhole("fffff", 16), "parseWhole(f_ffff, 16)");
    assertEquals(wholeNumber(#ff_ffff), parseWhole("ffffff", 16), "parseWhole(ff_ffff, 16)");
    assertEquals(wholeNumber(#fff_ffff), parseWhole("fffffff", 16), "parseWhole(fff_ffff, 16)");
    assertEquals(wholeNumber(#ffff_ffff), parseWhole("ffffffff", 16), "parseWhole(ffff_ffff, 16)");
    assertEquals(wholeNumber(#ffff_ffff_ffff), parseWhole("ffffffffffff", 16), "parseWhole(ffff_ffff_ffff, 16)");
    assertEquals(wholeNumber(#fff_ffff_ffff), parseWhole("fffffffffff", 16), "parseWhole(ffff_ffff_ffff, 16)");
    assertEquals(wholeNumber(#ff_ffff_ffff), parseWhole("ffffffffff", 16), "parseWhole(ff_ffff_ffff, 16)");
    assertEquals(wholeNumber(#f_ffff_ffff), parseWhole("fffffffff", 16), "parseWhole(f_ffff_ffff, 16)");
    assertEquals(wholeNumber(#ff_ff_ff_ff_ff_ff), parseWhole("ffffffffffff", 16), "parseWhole(ff_ff_ff_ff_ff_ff, 16)");
    assertEquals(wholeNumber(#f_ff_ff_ff_ff_ff), parseWhole("fffffffffff", 16), "parseWhole(f_ff_ff_ff_ff_ff, 16)");
    assertTrue(!parseWhole("ff_ff_ff_ffff", 16) exists, "!parseWhole(ff_ff_ff_ffff, 16) exists");
    assertTrue(!parseWhole("ffff_ff_ff_ff", 16) exists, "!parseWhole(ffff_ff_ff_ff, 16) exists");
    assertEquals(wholeNumber(255), parseWhole("FF", 16), "parseWhole(FF, 16)");
    assertTrue(!parseWhole("FK", 16) exists, "parseWhole(FK, 16)");
    assertEquals(wholeNumber(#F_FFFF), parseWhole("FFFFF", 16), "parseWhole(F_FFFF, 16)");
    assertEquals(wholeNumber(#FF_FFFF), parseWhole("FFFFFF", 16), "parseWhole(FF_FFFF, 16)");
    assertEquals(wholeNumber(#FFF_FFFF), parseWhole("FFFFFFF", 16), "parseWhole(FFF_FFFF, 16)");
    assertEquals(wholeNumber(#FFFF_FFFF), parseWhole("FFFFFFFF", 16), "parseWhole(FFFF_FFFF, 16)");
    assertEquals(wholeNumber(#FFFF_FFFF_FFFF), parseWhole("FFFFFFFFFFFF", 16), "parseWhole(FFFF_FFFF_FFFF, 16)");
    assertEquals(wholeNumber(#FFF_FFFF_FFFF), parseWhole("FFFFFFFFFFF", 16), "parseWhole(FFFF_FFFF_FFFF, 16)");
    assertEquals(wholeNumber(#FF_FFFF_FFFF), parseWhole("FFFFFFFFFF", 16), "parseWhole(FF_FFFF_FFFF, 16)");
    assertEquals(wholeNumber(#F_FFFF_FFFF), parseWhole("FFFFFFFFF", 16), "parseWhole(F_FFFF_FFFF, 16)");
    assertEquals(wholeNumber(#FF_FF_FF_FF_FF_FF), parseWhole("FFFFFFFFFFFF", 16), "parseWhole(FF_FF_FF_FF_FF_FF, 16)");
    assertEquals(wholeNumber(#F_FF_FF_FF_FF_FF), parseWhole("FFFFFFFFFFF", 16), "parseWhole(F_FF_FF_FF_FF_FF, 16)");

    assertTrue(!parseWhole("FF_FF_FF_FFFF", 16) exists, "!parseWhole(FF_FF_FF_FFFF, 16) exists");
    assertTrue(!parseWhole("FFFF_FF_FF_FF", 16) exists, "!parseWhole(FFFF_FF_FF_FF, 16) exists");

    assertTrue(!parseWhole("12_34", 8) exists, "!parseWhole(12_34, 8) exists");
    assertTrue(!parseWhole("123_456", 8) exists, "!parseWhole(123_456, 8) exists");
    assertTrue(!parseWhole("1234_5678", 8) exists, "!parseWhole(1234_5678, 8) exists");

    try {
        parseWhole("0", 1);
        fail("parseWhole(0, 1) should throw");
    } catch (AssertionError ex) {
        // OK
    }
    try {
        parseWhole("0", 37);
        fail("parseWhole(0, 37) should throw");
    } catch (AssertionError ex) {
        // OK
    }

    assertTrue(!parseWhole("") exists, "parseWhole()");
    assertTrue(!parseWhole("+") exists, "parseWhole(+)");
    assertTrue(!parseWhole("-") exists, "parseWhole(-)");
    assertTrue(!parseWhole("foo") exists, "parseWhole(foo)");
    assertTrue(!parseWhole(" 0") exists, "parseWhole( 0)");
    assertTrue(!parseWhole("0 ") exists, "parseWhole(0 )");
    assertTrue(!parseWhole("0+0") exists, "parseWhole(0+0)");
    assertTrue(!parseWhole("0-0") exists, "parseWhole(0-0)");
    assertTrue(!parseWhole("0+") exists, "parseWhole(0+)");
    assertTrue(!parseWhole("0-") exists, "parseWhole(0-)");
    assertTrue(!parseWhole("k") exists, "parseWhole(k)");
    assertTrue(!parseWhole("k1") exists, "parseWhole(k1)");
    assertTrue(!parseWhole("+k") exists, "parseWhole(+k)");
    assertTrue(!parseWhole("-k") exists, "parseWhole(-k)");
    assertTrue(!parseWhole("1kk") exists, "parseWhole(1kk)");
    assertTrue(!parseWhole("0_") exists, "parseWhole(0_)");
    assertTrue(!parseWhole("_0") exists, "parseWhole(_0)");
    assertTrue(!parseWhole("0_0") exists, "parseWhole(0_0)");
    assertTrue(!parseWhole("0_00") exists, "parseWhole(0_00)");
    assertTrue(!parseWhole("0_0000") exists, "parseWhole(0_0000)");
    assertTrue(!parseWhole("0_000_0") exists, "parseWhole(0_000_0)");
    assertTrue(!parseWhole("0000_000") exists, "parseWhole(0000_000)");
}
