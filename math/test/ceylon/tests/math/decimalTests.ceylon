import com.redhat.ceylon.sdk.test{...}
import ceylon.math.decimal{Decimal, parseDecimal}

shared void decimalTests() {

    Decimal parseOrFail(String str) {
       Decimal? result = parseDecimal(str);
       if (exists result) {
           return result;
       }
       throw AssertionFailed("" str " didn't parse");
    }    

    print("Decimal instantiation, equality");
    assert(Decimal(1) == Decimal(1), "1==1");
    assert(Decimal(1) != Decimal(2), "1!=2");
    
    print("parseDecimal");
    assertEquals(Decimal(1), parseDecimal("1"), "parseDecimal");
    assertEquals(Decimal(1), parseDecimal("1.0"), "parseDecimal");
    
    print("Decimal.strictEquals");
    assertFalse(Decimal(1).strictlyEquals(parseOrFail("1.0")), "strictEquals");
    
    print("Decimal.plus");
	assertEquals(Decimal(2), Decimal(1).plus(Decimal(1)));
	assertEquals(Decimal(2), Decimal(1) + Decimal(1));
}
