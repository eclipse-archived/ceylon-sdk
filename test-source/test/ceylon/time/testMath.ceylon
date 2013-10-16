import ceylon.test {
    assertEquals,
    test
}
import ceylon.time.internal.math {
    floor,
    round,
    mod=floorMod,
    amod=adjustedMod
}

// Test floor function

test void testFloorPositiveWhole() => assertEquals( 3, floor( 3.0));
test void testFloorPositiveFloat() => assertEquals( 3, floor( 3.14));
test void testFloorNegativeFloat() => assertEquals(-4, floor(-3.14));
test void testFloorNegativeWhole() => assertEquals(-3, floor(-3.0));

// Test round function
test void testRoundPositiveWhole() => assertEquals(3, round(3.0));
test void testRoundPositivePoint01() => assertEquals(3, round(3.1));
test void testRoundPositivePoint04() => assertEquals(3, round(3.4));
test void testRoundPositivePoint05() => assertEquals(4, round(3.5));
test void testRoundPositivePoint06() => assertEquals(4, round(3.6));
test void testRoundPositivePoint09() => assertEquals(4, round(3.9));
test void testRoundNegativeWhole() => assertEquals(-3, round(-3.0));
test void testRoundNegativePoint01() => assertEquals(-3, round(-3.1));
test void testRoundNegativePoint04() => assertEquals(-3, round(-3.4));
test void testRoundNegativePoint05() => assertEquals(-3, round(-3.5));
test void testRoundNegativePoint06() => assertEquals(-4, round(-3.6));
test void testRoundNegativePoint09() => assertEquals(-4, round(-3.9));

// Test mod function
test void testPositiveModPositive() => assertEquals( 4, mod( 9,  5));
test void testNegativeModPositive() => assertEquals( 1, mod(-9,  5));
test void testPositiveModNegative() => assertEquals(-1, mod( 9, -5));
test void testNegativeModNegative() => assertEquals(-4, mod(-9, -5));
test void testModulusInverted() => assertEquals(mod(-9, 5), 5 - mod(9, 5));
test void testModulusTransitive() => assertEquals(3*4, mod(3*9, 3*5));

test void testAmod(){
    value range = { for (y in -9..9) if (y != 0) y };
    for ( y in range ){
        for( x in -y..y ) {
            value expected = y + mod(x, -y);
            assertEquals(expected, amod(x, y), "``x`` amod ``y`` should be ``expected``");
        }
    }
}