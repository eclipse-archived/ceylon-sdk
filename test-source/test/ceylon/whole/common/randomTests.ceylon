import ceylon.test {
    assertEquals,
    test,
    assertTrue
}
import ceylon.whole {
    zero,
    Whole,
    gcd
}

Whole multiplyByAdding(variable Whole a, variable Whole b) {
    variable value result = zero;
    value negate = b.negative;
    b = b.magnitude;
    while (!b.zero) {
        if (!b.even) {
            result += a;
            b--;
        }
        a += a;
        b = b.rightArithmeticShift(1);
    }
    return if (negate) then -result else result;
}

void checkPlusAndMinus(Whole a, Whole b) {
    value c = a + b;
    value message = "``a``, ``b``";
    assertEquals(c - a, b, message);
    assertEquals(c - b, a, message);
    assertEquals(a - c, -b, message);
    assertEquals(b - c, -a, message);
    assertEquals(c, b + a);
}

void checkTimesAndPlus(Whole a, Whole b) {
    assertEquals(a * b, multiplyByAdding(a, b), { a, b }.string);
}

void checkTimesAndDivided(Whole a, Whole b, Boolean withRemainder) {
    variable Whole remainder;
    if (!withRemainder) {
        remainder = zero;
    }
    else {
        value bMag = b.magnitude;
        value bBits = bitLength(bMag);
        if (bBits.zero) {
            remainder = zero;
        }
        else {
            while (true) {
                remainder = generateWhole { bBits; negative = false; };
                if (remainder < bMag) {
                    break;
                }
            }
        }
        if ((b.sign * a.sign).negative) {
            remainder = -remainder;
        }
    }

    value c = a * b + remainder;
    let ([q, r] = c.quotientAndRemainder(b));

    value message = "``a``, ``b``";
    assertEquals(remainder, r, message);
    assertEquals(q, a, message);
}

void checkModuloPower(Whole a, Whole b, Whole c) {
    assertEquals(a.power(b).modulo(c), a.moduloPower(b, c), {a,b,c}.string);
}

void checkModuloInverse(Whole a, Whole b) {
    value message = { a, b }.string;
    Whole c;
    try {
        c = a.moduloInverse(b);
    }
    catch (e) {
        if (b.positive && gcd(a, b).unit) {
            throw AssertionError("modInverse threw for valid coprime inputs ``message``");
        }
        return;
    }
    assertTrue(c < b, message);
    assertTrue((c.zero && b.unit) || (a * c).modulo(b).unit, message);
}

void checkXorOrAndNot(Whole a, Whole b) {
    // a ^ b == (~a & b) | (a & ~b)
    assertEquals {
        a.xor(b);
        a.not.and(b).or(a.and(b.not));
        { a, b }.string;
    };
}

Integer randomIterations = 32;

shared test
void randomPlusAndMinus() {
    for (_ in 0:randomIterations) {
        checkPlusAndMinus {
            generateWhole { 128; };
            generateWhole { 128; };
        };
    }
}

shared test
void randomTimesAndPlus() {
    for (_ in 0:randomIterations / 2) {
        checkTimesAndPlus {
            generateWhole { 128; };
            generateWhole { 128; };
        };
    }
}

shared test
void randomTimesAndDivided() {
    for (_ in 0:randomIterations) {
        checkTimesAndDivided {
            generateWhole { 128; };
            generateWhole { 128; zero = false; };
            random.nextBoolean();
        };
    }
}

shared test
void randomModuloPower() {
    for (_ in 0:randomIterations/4) {
        checkModuloPower {
            generateWhole { 16; negative = true; };
            generateWhole { 8; negative = false; };
            generateWhole { 1000; negative = false; zero = false; };
        };
    }
}

shared test
void randomModuloInverse() {
    for (_ in 0:randomIterations/4) {
        checkModuloInverse {
            generateWhole { 128; };
            generateWhole { 128; negative = false; zero = false; };
        };
    }
}

shared test
void randomXorOrAndNot() {
    for (_ in 0:randomIterations) {
        checkXorOrAndNot {
            generateWhole { 128; };
            generateWhole { 128; };
        };
    }
}
