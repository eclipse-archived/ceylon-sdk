import ceylon.test { assertEquals, suite }
import ceylon.time.internal.math { floor, round, mod=floorMod, amod=adjustedMod }

shared void runMathTests(String suiteName="Math tests") {
    suite(suiteName,
    "Testing math floor positive whole" -> testFloorPositiveWhole,
    "Testing math floor positive float" -> testFloorPositiveFloat,
    "Testing math floor negative float" -> testFloorNegativeFloat,
    "Testing math floor negative whole" -> testFloorNegativeWhole,
    "Testing math round positive whole" -> testRoundPositiveWhole,
    "Testing math round positive point 01" -> testRoundPositivePoint01,
    "Testing math round positive point 04" -> testRoundPositivePoint04,
    "Testing math round positive point 05" -> testRoundPositivePoint05,
    "Testing math round positive point 06" -> testRoundPositivePoint06,
    "Testing math round positive point 09" -> testRoundPositivePoint09,
    "Testing math round negative whole" -> testRoundNegativeWhole,
    "Testing math round negative point 01" -> testRoundNegativePoint01,
    "Testing math round negative point 04" -> testRoundNegativePoint04,
    "Testing math round negative point 05" -> testRoundNegativePoint05,
    "Testing math round negative point 06" -> testRoundNegativePoint06,
    "Testing math round negative point 09" -> testRoundNegativePoint09,
    "Testing math positive mod positive" -> testPositiveModPositive,
    "Testing math negative mod positive" -> testNegativeModPositive,
    "Testing math positive mod negative" -> testPositiveModNegative,
    "Testing math negative mod negative" -> testNegativeModNegative,
    "Testing math modulus inverted" -> testModulusInverted,
    "Testing math modulus transitive" -> testModulusTransitive,
    "Testing math amod" -> testAmod
);
}

// Test floor function

shared void testFloorPositiveWhole() => assertEquals( 3, floor( 3.0));
shared void testFloorPositiveFloat() => assertEquals( 3, floor( 3.14));
shared void testFloorNegativeFloat() => assertEquals(-4, floor(-3.14));
shared void testFloorNegativeWhole() => assertEquals(-3, floor(-3.0));

// Test round function
shared void testRoundPositiveWhole() => assertEquals(3, round(3.0));
shared void testRoundPositivePoint01() => assertEquals(3, round(3.1));
shared void testRoundPositivePoint04() => assertEquals(3, round(3.4));
shared void testRoundPositivePoint05() => assertEquals(4, round(3.5));
shared void testRoundPositivePoint06() => assertEquals(4, round(3.6));
shared void testRoundPositivePoint09() => assertEquals(4, round(3.9));
shared void testRoundNegativeWhole() => assertEquals(-3, round(-3.0));
shared void testRoundNegativePoint01() => assertEquals(-3, round(-3.1));
shared void testRoundNegativePoint04() => assertEquals(-3, round(-3.4));
shared void testRoundNegativePoint05() => assertEquals(-3, round(-3.5));
shared void testRoundNegativePoint06() => assertEquals(-4, round(-3.6));
shared void testRoundNegativePoint09() => assertEquals(-4, round(-3.9));

// Test mod function
shared void testPositiveModPositive() => assertEquals( 4, mod( 9,  5));
shared void testNegativeModPositive() => assertEquals( 1, mod(-9,  5));
shared void testPositiveModNegative() => assertEquals(-1, mod( 9, -5));
shared void testNegativeModNegative() => assertEquals(-4, mod(-9, -5));
shared void testModulusInverted() => assertEquals(mod(-9, 5), 5 - mod(9, 5));
shared void testModulusTransitive() => assertEquals(3*4, mod(3*9, 3*5));

shared void testAmod(){
    value range = { for (y in -9..9) if (y != 0) y };
    for ( y in range ){
        for( x in -y..y ) {
            value expected = y + mod(x, -y);
            assertEquals(expected, amod(x, y), "``x`` amod ``y`` should be ``expected``");
        }
    }
}