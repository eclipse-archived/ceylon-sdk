import com.redhat.ceylon.sdk.test{...}
import ceylon.math.decimal{Decimal, parseDecimal, toDecimal}

shared void decimalTests() {

    Decimal parseOrFail(String str) {
       Decimal? result = parseDecimal(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }    

    print("Decimal instantiation, equality");
    assert(toDecimal(1) == toDecimal(1), "1==1");
    assert(toDecimal(1) != toDecimal(2), "1!=2");
    
    print("parseDecimal");
    assertEquals(toDecimal(1), parseDecimal("1"), "parseDecimal");
    assertEquals(toDecimal(1), parseDecimal("1.0"), "parseDecimal");
    
    print("Decimal.strictEquals");
    assertFalse(toDecimal(1).strictlyEquals(parseOrFail("1.0")), "strictEquals");
    
    print("Decimal.plus");
	assertEquals(toDecimal(2), toDecimal(1).plus(toDecimal(1)));
	assertEquals(toDecimal(2), toDecimal(1) + toDecimal(1));
}
