import ceylon.test { assertEquals }
import ceylon.time.internal.math { floor, round, mod=floorMod, amod=adjustedMod }

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