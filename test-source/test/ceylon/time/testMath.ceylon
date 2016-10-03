import ceylon.test {
    assertEquals,
    test,
    parameters
}
import ceylon.time.internal.math {
    floor,
    round,
    mod=floorMod,
    amod=adjustedMod
}

// Test floor function
[[Integer, Float]*] floorTests = [
    [3, 3.0],
    [3, 3.14],
    [-4, -3.14],
    [-3, -3.0]
];
parameters (`value floorTests`)
shared test void testFloor(Integer result, Float operand)
        => assertEquals { expected = result; actual = floor(operand); };

// Test round function
[[Integer, Float]*] roundTests = [
    [3, 3.0],
    [3, 3.1],
    [3, 3.4],
    [4, 3.5],
    [4, 3.6],
    [4, 3.9],
    [-3, -3.0],
    [-3, -3.1],
    [-3, -3.4],
    [-3, -3.5],
    [-4, -3.6],
    [-4, -3.9]
];
parameters (`value roundTests`)
shared test void testRound(Integer result, Float operand)
        => assertEquals { expected = result; actual = round(operand); };

// Test mod function
[[Integer, Integer, Integer]*] modTests = [
    [4, 9, 5],
    [1, -9, 5],
    [-1, 9, -5],
    [-4, -9, -5]
];
parameters (`value modTests`)
shared test void testMod(Integer result, Integer x, Integer y)
        => assertEquals { expected = result; actual = mod(x, y); };
shared test void testModulusInverted() => assertEquals(mod(-9, 5), 5 - mod(9, 5));
shared test void testModulusTransitive() => assertEquals(3*4, mod(3*9, 3*5));

shared test void testAmod(){
    value range = { for (y in -9..9) if (y != 0) y };
    for ( y in range ){
        for( x in -y..y ) {
            value expected = y + mod(x, -y);
            assertEquals { expected = expected; actual = amod(x, y); message = "``x`` amod ``y`` should be ``expected``"; };
        }
    }
}
