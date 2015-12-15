import ceylon.test {
    assertEquals,
    test
}

import com.vasileff.ceylon.random.api {
    LCGRandom,
    Random
}
import ceylon.whole {
    Whole,
    parseWhole,
    zero,
    gcd
}

import java.math {
    BigInteger
}

Integer iters = 50_000;
Integer bits = 256;

test shared void wholeTortureAddition() {
    runTests {
        label = "+";
        // Workaround https://github.com/ceylon/ceylon-compiler/issues/2378
        actual = basicWW((Whole a)(Whole b) => a + b);
        expected = basicBB(BigInteger.add);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureSubtraction() {
    runTests {
        label = "-";
        // Workaround https://github.com/ceylon/ceylon-compiler/issues/2378
        actual = basicWW((Whole a)(Whole b) => a - b);
        expected = basicBB(BigInteger.subtract);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureMultiplication() {
    runTests {
        label = "*";
        // Workaround https://github.com/ceylon/ceylon-compiler/issues/2378
        actual = basicWW((Whole a)(Whole b) => a * b);
        expected = basicBB(BigInteger.multiply);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureDivision() {
    runTests {
        label = "÷";
        // Workaround https://github.com/ceylon/ceylon-compiler/issues/2378
        actual = basicWW((Whole a)(Whole b) => a / b);
        expected = basicBB(BigInteger.divide);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureRemainder() {
    runTests {
        label = "%";
        // Workaround https://github.com/ceylon/ceylon-compiler/issues/2378
        actual = basicWW((Whole a)(Whole b) => a % b);
        expected = basicBB(BigInteger.remainder);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureMod() {
    runTests {
        label = "mod";
        actual = basicWW(Whole.modulo);
        expected = basicBB(BigInteger.mod);
        tests = {[
            generateWhole(bits),
            generateWhole { bits=bits; negative=false; }
        ]}.cycled.take(iters);
    };
}

test shared void wholeTorturePower() {
    runTests {
        label = "^";
        actual = basicWW(Whole.power);
        expected = (Whole a, Whole b)
            =>  let (a2 = toBigInteger(a),
                     b2 = b.integer)
                a2.pow(b2).string;
        tests = {[
            generateWhole(192),
            generateWhole { bits=8; negative=false; }
        ]}.cycled.take(iters / 40);
    };
}

test shared void wholeTorturePowerOfInteger() {
    runTests {
        label = "powerOfInteger";
        actual = basicWI(Whole.powerOfInteger);
        expected = basicBI(BigInteger.pow);
        tests = {[
            generateWhole(192),
            generateInteger { bits=8; negative=false; }
        ]}.cycled.take(iters / 40);
    };
}

test shared void wholeTortureAnd() {
    runTests {
        label = "and";
        actual = basicWW(Whole.and);
        expected = basicBB(BigInteger.and);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureOr() {
    runTests {
        label = "or";
        actual = basicWW(Whole.or);
        expected = basicBB(BigInteger.or);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureXOr() {
    runTests {
        label = "xor";
        actual = basicWW(Whole.xor);
        expected = basicBB(BigInteger.xor);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureGcd() {
    runTests {
        label = "gcd";
        actual = (Whole a, Whole b) => gcd(a, b).string;
        expected = basicBB(BigInteger.gcd);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureModInverse() {
    runTests {
        label = "modInverse";
        actual = basicWW(Whole.moduloInverse);
        expected = basicBB(BigInteger.modInverse);
        tests = {[
            generateWhole(bits),
            generateWhole(bits)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureModPower() {
    runTests {
        label = "modPower";
        actual = (Whole a, Whole b, Whole c)
            =>  a.moduloPower(b, c).string;
        expected = (Whole a, Whole b, Whole c)
            =>  let (a2 = toBigInteger(a),
                     b2 = toBigInteger(b),
                     c2 = toBigInteger(c))
                a2.modPow(b2, c2).string;
        tests = {[
            generateWhole(256),
            generateWhole(256),
            generateWhole { bits=256; negative=false; }
        ]}.cycled.take(iters / 10);
    };
}

test shared void wholeTortureRightArithmeticShift() {
    runTests {
        label = ">>";
        actual = basicWI(Whole.rightArithmeticShift);
        expected = basicBI(BigInteger.shiftRight);
        tests = {[
            generateWhole(bits),
            generateInteger(8)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureLeftLogicalShift() {
    runTests {
        label = "<<";
        actual = basicWI(Whole.leftLogicalShift);
        expected = basicBI(BigInteger.shiftLeft);
        tests = {[
            generateWhole(bits),
            generateInteger(8)
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureGet() {
    runTests {
        label = "get";
        actual = (Whole a, Integer b) => a.get(b);
        expected = (Whole a, Integer b) => toBigInteger(a).testBit(b);
        tests = {[
            generateWhole(bits),
            generateInteger{ bits=8; negative=false; }
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureSetFalse() {
    runTests {
        label = "set-false";
        actual = (Whole a, Integer b) => a.set(b, false).string;
        expected = basicBI(BigInteger.clearBit);
        tests = {[
            generateWhole(bits),
            generateInteger{ bits=8; negative=false; }
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureSetTrue() {
    runTests {
        label = "set-true";
        actual = basicWI(Whole.set);
        expected = basicBI(BigInteger.setBit);
        tests = {[
            generateWhole(bits),
            generateInteger{ bits=8; negative=false; }
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureFlip() {
    runTests {
        label = "flip";
        actual = basicWI(Whole.flip);
        expected = basicBI(BigInteger.flipBit);
        tests = {[
            generateWhole(bits),
            generateInteger{ bits=8; negative=false; }
        ]}.cycled.take(iters);
    };
}

test shared void wholeTortureNot() {
    runTests {
        label = "not";
        actual = (Whole a) => a.not.string;
        expected = (Whole a) => toBigInteger(a).not().string;
        tests = {[generateWhole(bits)]}.cycled.take(iters);
    };
}

test shared void wholeTortureNegated() {
    runTests {
        label = "negated";
        actual = (Whole a) => a.negated.string;
        expected = (Whole a) => toBigInteger(a).negate().string;
        tests = {[generateWhole(bits)]}.cycled.take(iters);
    };
}

test shared void wholeTortureInteger() {
    runTests {
        label = "integer";
        actual = (Whole a) => a.integer;
        expected = (Whole a) => toBigInteger(a).longValue();
        tests = {[generateWhole(bits)]}.cycled.take(iters);
    };
}

test shared void wholeTortureFloat() {
    assert (exists boundWhole = parseWhole("9007199254740992"));
    runTests {
        label = "float";
        actual = (Whole a)
            =>  if (a.magnitude < boundWhole)
                then a.float
                else 0.0;
        expected = (Whole a)
            =>  if (a.magnitude < boundWhole)
                then toBigInteger(a).doubleValue()
                else 0.0;
        tests = {[generateWhole(56)]}.cycled.take(iters);
    };
}

Random random = LCGRandom();

Whole randomWholeBits(variable Integer bits) {
    variable Whole result = zero;
    while (bits > 0) {
        value x = smallest(bits, 32);
        result = result.leftLogicalShift(x);
        result = result.plusInteger(random.nextBits(x));
        bits -= x;
    }
    return result;
}

Whole generateWhole(
        Integer bits,
        Boolean zero = true,
        Boolean negative = true,
        Boolean randomizeBits = true) {
    assert (1 <= bits);
    while (true) {
        value nBits =
                if (!randomizeBits)
                then bits
                else random.nextInteger(bits) + 1;
        value result = randomWholeBits(nBits);
        if (zero || !result.zero) {
            // equal probability for any magnitude
            // (zero is more likely than either -1 or 1)
            if (negative && random.nextBoolean()) {
                return result.negated;
            } else {
                return result;
            }
        }
    }
}

Integer generateInteger(
        Integer bits,
        Boolean zero = true,
        Boolean negative = true,
        Boolean randomizeBits = true) {
    assert (1 <= bits <= 63);
    while (true) {
        value nBits =
                if (!randomizeBits)
                then bits
                else random.nextInteger(bits) + 1;
        value result = random.nextBits(nBits);
        if (zero || !result.zero) {
            // equal probability for any magnitude
            // (zero is more likely than either -1 or 1)
            if (negative && random.nextBoolean()) {
                return result.negated;
            } else {
                return result;
            }
        }
    }
}

String basicWW(Whole(Whole)(Whole) f)(Whole a, Whole b)
    =>  f(a)(b).string;

String basicWI(Whole(Integer)(Whole) f)(Whole a, Integer b)
    =>  f(a)(b).string;

String basicBB
        (BigInteger(BigInteger)(BigInteger) f)
        (Whole a, Whole b)
    =>  f(toBigInteger(a))(toBigInteger(b)).string;

String basicBI
        (BigInteger(Integer)(BigInteger) f)
        (Whole a, Integer b)
    =>  f(toBigInteger(a))(b).string;

void runTestsBasic(label, actual, expected, tests) {
    String label;
    Whole(Whole, Whole) actual;
    BigInteger(BigInteger, BigInteger) expected;
    {[Whole, Whole]*} tests;

    runTests<[Whole, Whole], String> {
        label = label;
        actual = compose(Whole.string, actual);
        expected = (a, b)
                => expected(toBigInteger(a),
                            toBigInteger(b))
                   .string;
        tests = tests;
    };
}

void runTests<Args, Result>(label, actual, expected, tests)
        given Args satisfies [Anything*] {
    String label;
    Result(*Args) actual;
    Result(*Args) expected;
    {Args*} tests;
    for (args in tests) {
        variable Result? actualResult = null;
        variable Throwable? actualThrowable = null;
        try {
            actualResult = actual(*args);
        } catch (Throwable t) {
            actualThrowable = t;
        }

        variable Result? expectedResult = null;
        variable Throwable? expectedThrowable = null;
        try {
            expectedResult = expected(*args);
        } catch (Throwable t) {
            expectedThrowable = t;
        }

        if (exists at = actualThrowable) {
            if (expectedThrowable exists) {
                continue;
            }
            print("exception calculating actual for ``args`` ``label``");
            throw at;
        } else if (exists et = expectedThrowable) {
            print("exception calculating expected for ``args`` ``label``");
            throw et;
        }

        assert (exists ar = actualResult, exists er = expectedResult);
        assertEquals(ar, er, "``args`` ``label``");
    }
}
