import ceylon.test {
    assertEquals,
    test
}
import ceylon.whole {
    zero,
    Whole
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
    value [q, r] = c.quotientAndRemainder(b);

    value message = "``a``, ``b``";
    assertEquals(remainder, r, message);
    assertEquals(q, a, message);
}

void checkModuloPower(Whole a, Whole b, Whole c) {
    assertEquals (a.power(b).modulo(c), a.moduloPower(b, c), {a,b,c}.string);
}

Integer randomIterations = 32;

shared test
void randomPlusAndMinus() {
    for (_ in 0:randomIterations) {
        checkPlusAndMinus {
            generateWhole {128; };
            generateWhole {128; };
        };
    }
}

shared test
void randomTimesAndDivided() {
    for (_ in 0:randomIterations) {
        checkTimesAndDivided {
            generateWhole {128; };
            generateWhole {128; zero = false; };
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
