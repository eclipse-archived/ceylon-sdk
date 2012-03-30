import com.redhat.ceylon.sdk.test{...}
import ceylon.math.whole{Whole, parseWhole}

shared void wholeTests() {

    Whole parseOrFail(String str) {
       Whole? result = parseWhole(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }
	
	print("Whole instantiation, equality");
	assert(Whole(1) == Whole(1), "1==1");
	assert(Whole(1) != Whole(2), "1!=2");
	
	print("parseWhole");
	assertEquals(Whole(1), parseWhole("1"), "parseWhole");
	assertEquals(Whole(0), parseWhole("0"), "parseWhole");
	assertEquals(Whole(-1), parseWhole("-1"), "parseWhole");
	assertNotNull(parseOrFail("1000000000000000000000000000000000000"));
	assertNull(parseWhole("a"));
	assertNull(parseWhole("1a"));
	assertNull(parseWhole("a1"));
	assertNull(parseWhole("1.0"));
	assertNull(parseWhole("1.-0"));
	
	print("Whole.string");
	assert("1" == Whole(1).string, ".string");
	assert("-1" == Whole(-1).string, ".string");
	assertEquals("1000000000000000000000000000000000000", parseOrFail("1000000000000000000000000000000000000").string, ".string");
	
	print("Whole.plus");
	assert(Whole(2) == Whole(1).plus(Whole(1)), ".plus()");
	assert(Whole(2) == Whole(1) + Whole(1), "+");
	
	print("Whole.minus");
	assert(Whole(0) == Whole(1).minus(Whole(1)), ".minus");
	assert(Whole(0) == Whole(1) - Whole(1), "-");
	
	print("Whole.times");
	assert(Whole(4) == Whole(2).times(Whole(2)), ".times");
	assert(Whole(4) == Whole(2) * Whole(2), "*");
	
	print("Whole.divided");
	assert(Whole(2) == Whole(4).divided(Whole(2)), ".divided");
	assert(Whole(2) == Whole(4) / Whole(2), "/");
	
	print("Whole.remainder");
	assertEquals(Whole(0), Whole(4).remainder(Whole(2)), ".remainder");
	assertEquals(Whole(0), Whole(4) % Whole(2), "%");
	
	print("Whole.power");
	assertEquals(Whole(4), Whole(2).power(Whole(2)), ".power");
	assertEquals(Whole(4), Whole(2) ** Whole(2), "**");
	
	print("Whole comparison");
	assert(larger == Whole(2).compare(Whole(1)), "larger");
	assert(Whole(2) > Whole(1), ">");
	assert(smaller == Whole(1).compare(Whole(2)), "smaller");
	assert(Whole(1) < Whole(2), "<");
	
	print("Whole predicates");
	assert(Whole(2).positive, "2.positive");
	assert(!Whole(-2).positive, "-2.positive");
	assert(!Whole(2).negative, "2.negative");
	assert(Whole(-2).negative, "-2.negative");
	assert(!Whole(1).zero, "1.zero");
	assert(Whole(0).zero, "0.zero");
	assert(Whole(1).unit, "1.unit");
	assert(!Whole(0).unit, "0.unit");
	
	print("Whole.hash");
	assertEquals(0, Whole(0).hash, "0.hash");
	assertEquals(1, Whole(1).hash, "1.hash");
	
	print("Whole *cessor");
	assertEquals(Whole(2), Whole(1).successor, ".successor");
	assertEquals(Whole(0), Whole(1).predecessor, ".predecessor");
	variable Whole w := Whole(0);
	assertEquals(Whole(1), ++w, "++");
	assertEquals(Whole(0), --w, "++");
	
	print("Whole conversion");
	assertEquals(2, Whole(2).integer, ".integer");
	assertEquals(2.0, Whole(2).float, ".float");
	
	print("Whole misc");
	assertEquals(Whole(2), Whole(2).magnitude, "2.magnitude");
	assertEquals(Whole(2), Whole(-2).magnitude, "-2.magnitude");
	assertEquals(Whole(2), Whole(2).wholePart, "2.wholePart");
	assertEquals(Whole(-2), Whole(-2).wholePart, "-2.wholePart");
	assertEquals(Whole(0), Whole(2).fractionalPart, "2.fractionalPart");
    assertEquals(Whole(0), Whole(-2).fractionalPart, "-2.fractionalPart");
	assertEquals(+1, Whole(2).sign, "2.sign");
	assertEquals(0, Whole(0).sign, "0.sign");
	assertEquals(-1, Whole(-2).sign, "-2.sign");
	// TODO castTo
	
	//print("gcd");
	//assertEquals(Whole(6), gcd(Whole(12), Whole(18)), "gcd(12, 18)");
	
}