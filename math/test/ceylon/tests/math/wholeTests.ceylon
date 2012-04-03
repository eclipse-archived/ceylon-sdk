import com.redhat.ceylon.sdk.test{...}
import ceylon.math.whole{Whole, parseWhole, toWhole}

shared void wholeTests() {

    Whole parseOrFail(String str) {
       Whole? result = parseWhole(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }
	
	print("Whole instantiation, equality");
	assert(toWhole(1) == toWhole(1), "1==1");
	assert(toWhole(1) != toWhole(2), "1!=2");
	
	print("parseWhole");
	assertEquals(toWhole(1), parseWhole("1"), "parseWhole");
	assertEquals(toWhole(0), parseWhole("0"), "parseWhole");
	assertEquals(toWhole(-1), parseWhole("-1"), "parseWhole");
	assertNotNull(parseOrFail("1000000000000000000000000000000000000"));
	assertNull(parseWhole("a"));
	assertNull(parseWhole("1a"));
	assertNull(parseWhole("a1"));
	assertNull(parseWhole("1.0"));
	assertNull(parseWhole("1.-0"));
	
	print("Whole.string");
	assert("1" == toWhole(1).string, ".string");
	assert("-1" == toWhole(-1).string, ".string");
	assertEquals("1000000000000000000000000000000000000", parseOrFail("1000000000000000000000000000000000000").string, ".string");
	
	print("Whole.plus");
	assert(toWhole(2) == toWhole(1).plus(toWhole(1)), ".plus()");
	assert(toWhole(2) == toWhole(1) + toWhole(1), "+");
	
	print("Whole.minus");
	assert(toWhole(0) == toWhole(1).minus(toWhole(1)), ".minus");
	assert(toWhole(0) == toWhole(1) - toWhole(1), "-");
	
	print("Whole.times");
	assert(toWhole(4) == toWhole(2).times(toWhole(2)), ".times");
	assert(toWhole(4) == toWhole(2) * toWhole(2), "*");
	
	print("Whole.divided");
	assert(toWhole(2) == toWhole(4).divided(toWhole(2)), ".divided");
	assert(toWhole(2) == toWhole(4) / toWhole(2), "/");
	
	print("Whole.remainder");
	assertEquals(toWhole(0), toWhole(4).remainder(toWhole(2)), ".remainder");
	assertEquals(toWhole(0), toWhole(4) % toWhole(2), "%");
	
	print("Whole.power");
	assertEquals(toWhole(4), toWhole(2).power(toWhole(2)), ".power");
	assertEquals(toWhole(4), toWhole(2) ** toWhole(2), "**");
	
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
	assert(larger == toWhole(2).compare(toWhole(1)), "larger");
	assert(toWhole(2) > toWhole(1), ">");
	assert(smaller == toWhole(1).compare(toWhole(2)), "smaller");
	assert(toWhole(1) < toWhole(2), "<");
	
	print("Whole predicates");
	assert(toWhole(2).positive, "2.positive");
	assert(!toWhole(-2).positive, "-2.positive");
	assert(!toWhole(2).negative, "2.negative");
	assert(toWhole(-2).negative, "-2.negative");
	assert(!toWhole(1).zero, "1.zero");
	assert(toWhole(0).zero, "0.zero");
	assert(toWhole(1).unit, "1.unit");
	assert(!toWhole(0).unit, "0.unit");
	
	print("Whole.hash");
	assertEquals(0, toWhole(0).hash, "0.hash");
	assertEquals(1, toWhole(1).hash, "1.hash");
	
	print("Whole *cessor");
	assertEquals(toWhole(2), toWhole(1).successor, ".successor");
	assertEquals(toWhole(0), toWhole(1).predecessor, ".predecessor");
	variable Whole w := toWhole(0);
	assertEquals(toWhole(1), ++w, "++");
	assertEquals(toWhole(0), --w, "++");
	
	print("Whole conversion");
	assertEquals(2, toWhole(2).integer, ".integer");
	assertEquals(2.0, toWhole(2).float, ".float");
	
	print("Whole misc");
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