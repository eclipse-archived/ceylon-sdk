import ceylon.math.whole {
    Whole,
    parseWhole,
    wholeNumber,
    one,
    two,
    zero,
    gcd
}
import ceylon.test {
    ...
}

import com.vasileff.ceylon.random.api {
    randomLimits,
    Random
}
import com.vasileff.ceylon.random.sample {
    LCGRandom
}

import java.lang {
    Thread
}
import java.math {
    BigInteger
}

Whole parseWholeOrFail(String str) {
    Whole? result = parseWhole(str);
    if (exists result) {
        return result;
    }
    throw AssertionError("``str`` didn't parse");
}

test void wholeInstantiationEqualityTests() {
    assertTrue(zero == zero, "zero==zero");
    assertTrue(one == one, "one==one");
    assertTrue(zero != one, "zero!=one");
    assertTrue(zero == wholeNumber(0), "zero==0");
    assertTrue(one == wholeNumber(1), "one==1");
    assertTrue(zero != wholeNumber(2), "zero!=2");
    assertTrue(one != wholeNumber(2), "one!=2");
    assertTrue(wholeNumber(1) == wholeNumber(1), "1==1");
    assertTrue(wholeNumber(1) != wholeNumber(2), "1!=2");
    assertTrue(wholeNumber(2) == wholeNumber(2), "2==2");
}

test void wholeParseTests() {
    assertEquals(wholeNumber(1), parseWhole("1"), "parseWhole");
    assertEquals(wholeNumber(0), parseWhole("0"), "parseWhole");
    assertEquals(wholeNumber(1), parseWhole("001"), "parseWhole");
    assertEquals(wholeNumber(-1), parseWhole("-1"), "parseWhole");
    assertNotNull(parseWholeOrFail("1000000000000000000000000000000000000"));
    assertNull(parseWhole("a"));
    assertNull(parseWhole("1a"));
    assertNull(parseWhole("a1"));
    assertNull(parseWhole("1.0"));
    assertNull(parseWhole("1.-0"));
}

test void wholeStringTests() {
    assertTrue("1" == wholeNumber(1).string, "1.string");
    assertTrue("-1" == wholeNumber(-1).string, "-1.string");
    assertEquals("1000000000000000000000000000000000000", parseWholeOrFail("1000000000000000000000000000000000000").string, ".string");
}

test void wholePlusTests() {
    assertTrue(wholeNumber(2) == wholeNumber(1).plus(wholeNumber(1)), "1.plus(1)");
    assertTrue(wholeNumber(2) == wholeNumber(1) + wholeNumber(1), "1+1");
}

test void wholeMinusTests() {
    assertTrue(wholeNumber(0) == wholeNumber(1).minus(wholeNumber(1)), "1.minus(1)");
    assertTrue(wholeNumber(0) == wholeNumber(1) - wholeNumber(1), "1-1");
}

test void wholeTimesTests() {
    assertTrue(wholeNumber(4) == wholeNumber(2).times(wholeNumber(2)), "2.times(2)");
    assertTrue(wholeNumber(4) == wholeNumber(2) * wholeNumber(2), "2*2");
}

test void wholeDividedTests() {
    assertTrue(wholeNumber(2) == wholeNumber(4).divided(wholeNumber(2)), "4.divided(2)");
    assertTrue(wholeNumber(2) == wholeNumber(4) / wholeNumber(2), "4/2");
    assertTrue(wholeNumber(1) == wholeNumber(4) / wholeNumber(3), "4/3");

    // high words are equal with leading "1" bit,
    // setting up potential misuse of unsigned Integer division
    assertEquals(one.leftLogicalShift(95) / (one.leftLogicalShift(63) + one),
                 one.leftLogicalShift(32) - one);
}

test void wholeRemainderTests() {
    assertEquals(wholeNumber(0), wholeNumber(4).remainder(wholeNumber(2)), "4.remainder(2)");
    assertEquals(wholeNumber(0), wholeNumber(4) % wholeNumber(2), "4%2");
    assertEquals(wholeNumber(1), wholeNumber(4) / wholeNumber(3), "4%3");
}

test void wholePowerTests() {
    assertEquals(wholeNumber(4), wholeNumber(2).power(wholeNumber(2)), "2.power(2)");
    assertEquals(wholeNumber(4), wholeNumber(2) ^ wholeNumber(2), "2^2");

    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(1), "1^1");
    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(0), "1^0");
    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(-1), "1^-1");
    assertEquals(wholeNumber(1), wholeNumber(1) ^ wholeNumber(-2), "1^-2");

    assertEquals(wholeNumber(0), wholeNumber(0) ^ wholeNumber(1), "0^1");
    assertEquals(wholeNumber(1), wholeNumber(0) ^ wholeNumber(0), "0^0");
    try {
        Whole wn = wholeNumber(0) ^ wholeNumber(-1);
        fail("0^-1");
    } catch (Exception e){}
    try {
        Whole wn = wholeNumber(0) ^ wholeNumber(-2);
        fail("0^-2");
    } catch (Exception e){}

    assertEquals(wholeNumber(-1), wholeNumber(-1) ^ wholeNumber(1), "-1^1");
    assertEquals(wholeNumber(1), wholeNumber(-1) ^ wholeNumber(0), "-1^0");
    assertEquals(wholeNumber(-1), wholeNumber(-1) ^ wholeNumber(-1), "-1^-1");
    assertEquals(wholeNumber(1), wholeNumber(-1) ^ wholeNumber(-2), "-1^-2");

    assertEquals(wholeNumber(-2), wholeNumber(-2) ^ wholeNumber(1), "-2^-1");
    assertEquals(wholeNumber(1), wholeNumber(-2) ^ wholeNumber(0), "-2^0");
    try {
        Whole wn = wholeNumber(-2) ^ wholeNumber(-1);
        fail("-2^-1");
    } catch (Exception e){}
    try {
        Whole wn = wholeNumber(-2) ^ wholeNumber(-2);
        fail("-2^-2");
    } catch (Exception e){}
}

test void wholeComparisonTests() {
    assertTrue(larger == wholeNumber(2).compare(wholeNumber(1)), "2.compare(1)");
    assertTrue(wholeNumber(2) > wholeNumber(1), "2>1");
    assertTrue(smaller == wholeNumber(1).compare(wholeNumber(2)), "1.compare(2)");
    assertTrue(wholeNumber(1) < wholeNumber(2), "1<2");
}

test void wholePredicatesTests() {
    assertTrue(wholeNumber(2).positive, "2.positive");
    assertTrue(!wholeNumber(-2).positive, "-2.positive");
    assertTrue(!zero.positive, "zero.positive");
    assertTrue(!wholeNumber(2).negative, "2.negative");
    assertTrue(wholeNumber(-2).negative, "-2.negative");
    assertTrue(!zero.negative, "zero.negative");
    assertTrue(!wholeNumber(1).zero, "1.zero");
    assertTrue(wholeNumber(0).zero, "0.zero");
    assertTrue(wholeNumber(1).unit, "1.unit");
    assertTrue(!wholeNumber(0).unit, "0.unit");
}

test void wholeHashTests() {
    assertEquals(0.hash, wholeNumber(0).hash, "0.hash");
    assertEquals(1.hash, wholeNumber(1).hash, "1.hash");
    assertEquals(2.hash, wholeNumber(2).hash, "2.hash");
    assertEquals((-1).hash, wholeNumber(-1).hash, "-1.hash");
    assertEquals((-2).hash, wholeNumber(-2).hash, "-2.hash");
}

test void wholeSuccessorTests() {
    assertEquals(wholeNumber(2), wholeNumber(1).successor, "1.successor");
    assertEquals(wholeNumber(0), wholeNumber(1).predecessor, "1.predecessor");
    variable Whole w = wholeNumber(0);
    assertEquals(wholeNumber(1), ++w, "++0");
    assertEquals(wholeNumber(0), --w, "--1");
}

test void wholeConversionTests() {
    assertEquals(2, wholeNumber(2).integer, "2.integer");
    assertEquals(2.0, wholeNumber(2).float, "2.float");
}

test void wholeMiscTests() {
    assertEquals(wholeNumber(-2), wholeNumber(2).negated, "2.negated");
    assertEquals(wholeNumber(0), wholeNumber(0).negated, "0.negated");
    assertEquals(wholeNumber(2), wholeNumber(2).magnitude, "2.magnitude");
    assertEquals(wholeNumber(2), wholeNumber(-2).magnitude, "-2.magnitude");
    assertEquals(wholeNumber(2), wholeNumber(2).wholePart, "2.wholePart");
    assertEquals(wholeNumber(-2), wholeNumber(-2).wholePart, "-2.wholePart");
    assertEquals(wholeNumber(0), wholeNumber(2).fractionalPart, "2.fractionalPart");
    assertEquals(wholeNumber(0), wholeNumber(-2).fractionalPart, "-2.fractionalPart");
    assertEquals(+1, wholeNumber(2).sign, "2.sign");
    assertEquals(0, wholeNumber(0).sign, "0.sign");
    assertEquals(-1, wholeNumber(-2).sign, "-2.sign");

    assertEquals([wholeNumber(1), wholeNumber(2)], one..two, "one..two");
    assertEquals([wholeNumber(2), wholeNumber(1)], two..one, "two..one");
    assertEquals([wholeNumber(0), wholeNumber(1), wholeNumber(2)], zero..two, "zero..two");
    assertEquals([wholeNumber(2), wholeNumber(1), wholeNumber(0)], two..zero, "two..zero");

    assertEquals(-1, one.offset(two), "one.offset(two)");
    assertEquals(-runtime.maxIntegerValue, zero.offset(wholeNumber(runtime.maxIntegerValue)));
    assertEquals(runtime.minIntegerValue, zero.offset(wholeNumber(runtime.maxIntegerValue)+one));
    try {
        value off = zero.offset(wholeNumber(runtime.maxIntegerValue)+two);
        fail("zero.offset(wholeNumber(runtime.maxIntegerValue)+two) returned ``off``");
    } catch (OverflowException e) {
        // checking this is thrown
    }
}

Integer iters = 10_000;
Boolean randomizeNumBits = true;
{Integer*} bits = [ 32, 64, 128, 256 ];

test void wholeTortureAddition() {
    wholeTorture {
        label = "+";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.plus;
        javaOp = BigInteger.add;
    };
}

test void wholeTortureSubtraction() {
    wholeTorture {
        label = "-";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.minus;
        javaOp = BigInteger.subtract;
    };
}

test void wholeTortureMultiplication() {
    wholeTorture {
        label = "*";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.times;
        javaOp = BigInteger.multiply;
    };
}

test void wholeTortureDivision() {
    wholeTorture {
        label = "÷";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.divided;
        javaOp = BigInteger.divide;
        allowZeroRhs = false;
    };
}

test void wholeTortureRemainder() {
    wholeTorture {
        label = "%";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.remainder;
        javaOp = BigInteger.remainder;
        allowZeroRhs = false;
    };
}

test void wholeTortureMod() {
    wholeTorture {
        label = "mod";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.mod;
        javaOp = BigInteger.mod;
        allowZeroRhs = false;
        allowNegativeRhs = false;
    };
}

test void wholeTorturePower() {
    wholeTorture {
        label = "^";
        lhsBits = bits.filter((bits) => bits <= 192);
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters / 10;
        ceylonOp = Whole.power;
        javaOp = ((BigInteger x)(BigInteger y) => x.pow(y.intValue()));
        allowNegativeRhs = false;
    };
}

test void wholeTorturePowerOfInteger() {
    wholeTortureIntArg {
        label = "powerOfInteger";
        lhsBits = bits.filter((bits) => bits <= 192);
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters / 10;
        ceylonOp = (whole, rhs) => whole.powerOfInteger(rhs).string;
        javaOp = (big, rhs) => big.pow(rhs).string;
        allowNegativeRhs = false;
    };
}

test void wholeTortureAnd() {
    wholeTorture {
        label = "and";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.and;
        javaOp = BigInteger.and;
    };
}

test void wholeTortureOr() {
    wholeTorture {
        label = "or";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.or;
        javaOp = BigInteger.or;
    };
}

test void wholeTortureXOr() {
    wholeTorture {
        label = "xor";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.xor;
        javaOp = BigInteger.xor;
    };
}

test void wholeTortureGcd() {
    wholeTorture {
        label = "gcd";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = curry(gcd);
        javaOp = BigInteger.gcd;
    };
}

test void wholeTortureModInverse() {
    wholeTorture {
        label = "modInverse";
        lhsBits = bits;
        rhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = Whole.modInverse;
        javaOp = BigInteger.modInverse;
        allowNegativeRhs = false;
    };
}

test void wholeTortureModPower() {
    wholeTortureThree {
        label = "modPower";
        lhsBits = bits.filter((bits) => bits <= 192);
        rhsBits1 = bits.filter((bits) => bits <= 192);
        rhsBits2 = bits.filter((bits) => bits <= 192);
        randomizeNumBits = randomizeNumBits;
        iterations = iters / 20;
        ceylonOp = Whole.modPower;
        javaOp = BigInteger.modPow;
        allowNegativeRhs2 = false;
    };
}

test void wholeTortureRightArithmeticShift() {
    wholeTortureIntArg {
        label = ">>";
        lhsBits = bits;
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole, rhs) => whole.rightArithmeticShift(rhs).string;
        javaOp = (big, rhs) => big.shiftRight(rhs).string;
    };
}

test void wholeTortureLeftLogicalShift() {
    wholeTortureIntArg {
        label = "<<";
        lhsBits = bits;
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole, rhs) => whole.leftLogicalShift(rhs).string;
        javaOp = (big, rhs) => big.shiftLeft(rhs).string;
    };
}

test void wholeTortureGet() {
    wholeTortureIntArg {
        label = "get";
        lhsBits = bits;
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole, rhs) => whole.get(rhs);
        javaOp = (big, rhs) => big.testBit(rhs);
        allowNegativeRhs = false;
    };
}

test void wholeTortureSetFalse() {
    wholeTortureIntArg {
        label = "set-false";
        lhsBits = bits;
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole, rhs) => whole.set(rhs, false).string;
        javaOp = (big, rhs) => big.clearBit(rhs).string;
        allowNegativeRhs = false;
    };
}

test void wholeTortureFlip() {
    wholeTortureIntArg {
        label = "set-false";
        lhsBits = bits;
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole, rhs) => whole.flip(rhs).string;
        javaOp = (big, rhs) => big.flipBit(rhs).string;
        allowNegativeRhs = false;
    };
}

test void wholeTortureSetTrue() {
    wholeTortureIntArg {
        label = "set-true";
        lhsBits = bits;
        rhsBits = [4, 8];
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole, rhs) => whole.set(rhs, true).string;
        javaOp = (big, rhs) => big.setBit(rhs).string;
        allowNegativeRhs = false;
    };
}

test void wholeTortureNot() {
    wholeTortureNoArg {
        label = "not";
        lhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole) => whole.not.string;
        javaOp = (big) => big.not().string;
    };
}

test void wholeTortureNegated() {
    wholeTortureNoArg {
        label = "negated";
        lhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole) => whole.negated.string;
        javaOp = (big) => big.negate().string;
    };
}

test void wholeTortureInteger() {
    wholeTortureNoArg {
        label = "integer";
        lhsBits = bits;
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole) => whole.integer;
        javaOp = (big) => big.longValue();
    };
}

test void wholeTortureFloat() {
    assert (exists boundWhole = parseWhole("9007199254740992"));
    assert (is BigInteger boundBI = boundWhole.implementation);
    wholeTortureNoArg {
        label = "float";
        lhsBits = (8..56).by(8).follow(4);
        randomizeNumBits = randomizeNumBits;
        iterations = iters;
        ceylonOp = (whole) => if (whole.magnitude < boundWhole)
                              then whole.float
                              else 0.0;
        javaOp = (big) => if (big.abs().compareTo(boundBI) != 1)
                          then big.doubleValue()
                          else 0.0;
    };
}

void wholeTorture(String label,
                  {Integer*} lhsBits,
                  {Integer*} rhsBits,
                  Integer iterations,
                  Whole ceylonOp(Whole v1)(Whole v2),
                  BigInteger javaOp(BigInteger v1)(BigInteger v2),
                  Boolean allowZeroRhs = true,
                  Boolean allowNegativeLhs = true,
                  Boolean allowNegativeRhs = true,
                  Boolean randomizeNumBits = false) {

    value rng = LCGRandom();

    for (lbits in lhsBits) {
        for (rbits in rhsBits) {
            for (_ in 0:iterations) {
                value lhs = generateWhole(rng, lbits, true, allowNegativeLhs, randomizeNumBits);
                value rhs = generateWhole(rng, rbits, allowZeroRhs, allowNegativeRhs, randomizeNumBits);

                variable Whole? ceylonResult = null;
                variable Exception|AssertionError? ceylonException = null;
                try {
                    ceylonResult = ceylonOp(lhs)(rhs);
                } catch (Exception|AssertionError e) {
                    ceylonException = e;
                }

                variable BigInteger? javaResult = null;
                variable Exception|AssertionError? javaException = null;
                try {
                    assert (is BigInteger lhsBI = lhs.implementation);
                    assert (is BigInteger rhsBI = rhs.implementation);
                    javaResult = javaOp(lhsBI)(rhsBI);
                } catch (Exception e) {
                    javaException = e;
                }

                if (exists ce = ceylonException) {
                    if (javaException exists) {
                        continue;
                    }
                    print("Whole exception for ``lhs`` ``label`` ``rhs``");
                    throw ce;
                } else if (exists je = javaException) {
                    print("BigInteger exception for ``lhs`` ``label`` ``rhs``");
                    throw je;
                }

                assert (exists cr = ceylonResult, exists jr = javaResult);
                assertEquals(cr.string, jr.string,
                             "``lhs`` ``label`` ``rhs``");
            }            
        }
    }
}

void wholeTortureThree(String label,
                  {Integer*} lhsBits,
                  {Integer*} rhsBits1,
                  {Integer*} rhsBits2,
                  Integer iterations,
                  Whole ceylonOp(Whole v1)(Whole v2, Whole v3),
                  BigInteger javaOp(BigInteger v1)(BigInteger v2, BigInteger v3),
                  Boolean allowZeroRhs = true,
                  Boolean allowNegativeLhs = true,
                  Boolean allowNegativeRhs1 = true,
                  Boolean allowNegativeRhs2 = true,
                  Boolean randomizeNumBits = false) {

    value rng = LCGRandom();

    for (lbits in lhsBits) {
        for (rbits1 in rhsBits1) {
            for (rbits2 in rhsBits2) {
                for (_ in 0:iterations) {
                    value lhs = generateWhole(rng, lbits, true, allowNegativeLhs, randomizeNumBits);
                    value rhs1 = generateWhole(rng, rbits1, allowZeroRhs, allowNegativeRhs1, randomizeNumBits);
                    value rhs2 = generateWhole(rng, rbits2, allowZeroRhs, allowNegativeRhs2, randomizeNumBits);

                    variable Whole? ceylonResult = null;
                    variable Exception|AssertionError? ceylonException = null;
                    try {
                        ceylonResult = ceylonOp(lhs)(rhs1, rhs2);
                    } catch (Exception|AssertionError e) {
                        ceylonException = e;
                    }

                    variable BigInteger? javaResult = null;
                    variable Exception|AssertionError? javaException = null;
                    try {
                        assert (is BigInteger lhsBI = lhs.implementation);
                        assert (is BigInteger rhsBI1 = rhs1.implementation);
                        assert (is BigInteger rhsBI2 = rhs2.implementation);
                        javaResult = javaOp(lhsBI)(rhsBI1, rhsBI2);
                    } catch (Exception e) {
                        javaException = e;
                    }

                    if (exists ce = ceylonException) {
                        if (javaException exists) {
                            continue;
                        }
                        print("Whole exception for ``lhs`` ``label`` ``rhs1`` ``rhs2``");
                        throw ce;
                    } else if (exists je = javaException) {
                        print("BigInteger exception for ``lhs`` ``label`` ``rhs1`` ``rhs2``");
                        throw je;
                    }

                    assert (exists cr = ceylonResult, exists jr = javaResult);
                    assertEquals(cr.string, jr.string,
                                 "``lhs`` ``label`` ``rhs1`` ``rhs2``");
                }
            }
        }
    }
}

void wholeTortureIntArg<Result>(String label,
                  {Integer*} lhsBits,
                  {Integer*} rhsBits,
                  Integer iterations,
                  Result ceylonOp(Whole v1, Integer v2),
                  Result javaOp(BigInteger v1, Integer v2),
                  Boolean allowZeroRhs = true,
                  Boolean allowNegativeLhs = true,
                  Boolean allowNegativeRhs = true,
                  Boolean randomizeNumBits = false) {

    value rng = LCGRandom();

    for (lbits in lhsBits) {
        for (rbits in rhsBits) {
            for (_ in 0:iterations) {
                value lhs = generateWhole(rng, lbits, true, allowNegativeLhs, randomizeNumBits);
                value rhs = generateInteger(rng, rbits, true, allowNegativeRhs, randomizeNumBits);
                Result ceylonResult;
                try {
                    ceylonResult = ceylonOp(lhs, rhs);
                } catch (Exception|AssertionError e) {
                    print ("Whole exception for ``lhs`` ``label`` ``rhs``");
                    throw e;
                }

                Result javaResult;
                try {
                    assert (is BigInteger lhsBI = lhs.implementation);
                    javaResult = javaOp(lhsBI, rhs);
                } catch (Exception e) {
                    print ("BigInteger exception for ``lhs`` ``label`` ``rhs``");
                    throw e;
                }

                assertEquals(ceylonResult, javaResult,
                             "``lhs`` ``label`` ``rhs``");
            }
        }
    }
}

void wholeTortureNoArg<Result>(String label,
                  {Integer*} lhsBits,
                  Integer iterations,
                  Result ceylonOp(Whole v1),
                  Result javaOp(BigInteger v1),
                  Boolean allowZeroRhs = true,
                  Boolean allowNegativeLhs = true,
                  Boolean randomizeNumBits = false) {

    value rng = LCGRandom();

    for (lbits in lhsBits) {
        for (_ in 0:iterations) {
            value lhs = generateWhole(rng, lbits, true, allowNegativeLhs, randomizeNumBits);

            Result ceylonResult;
            try {
                ceylonResult = ceylonOp(lhs);
            } catch (Exception|AssertionError e) {
                print ("Whole exception for ``lhs`` ``label``");
                throw e;
            }

            Result javaResult;
            try {
                assert (is BigInteger lhsBI = lhs.implementation);
                javaResult = javaOp(lhsBI);
            } catch (Exception e) {
                print ("BigInteger exception for ``lhs`` ``label``");
                throw e;
            }

            assertEquals(ceylonResult, javaResult,
                         "``lhs`` ``label``");
        }
    }
}

// positive Integer's only
Integer maxBits = smallest(randomLimits.maxBits, 62);
shared Whole randomWholeBits(Random random, variable Integer numBits) {
    variable Whole result = zero;
    while (numBits > 0) {
        value x = smallest(numBits, maxBits);
        result = result.leftLogicalShift(x);
        result = result.plusInteger(random.nextInteger(2^x));
        numBits -= x;
    }
    return result;
}

shared Whole generateWhole(Random random,
                    Integer numBits,
                    Boolean allowZero = true,
                    Boolean allowNegative = true,
                    Boolean randomizeNumBits = false) {
    while (true) {
        value bits = if (!randomizeNumBits)
                     then numBits
                     else random.nextInteger(numBits);
        if (bits == 0) {
            continue;
        }
        value result = randomWholeBits(random, bits);
        if (allowZero || !result.zero) {
            // this is slightly wrong; throws off probability of result == zero
            if (allowNegative && random.nextBoolean()) {
                return result.negated;
            } else {
                return result;
            }
        }
    }
}

shared Integer generateInteger(Random random,
                    Integer numBits,
                    Boolean allowZero = true,
                    Boolean allowNegative = true,
                    Boolean randomizeNumBits = false) {
    assert (numBits <= 63);
    while (true) {
        value bits = if (!randomizeNumBits)
                     then numBits
                     else random.nextInteger(numBits);
        if (bits == 0) {
            continue;
        }
        value result = random.nextBits(bits);
        if (allowZero || !result.zero) {
            // this is slightly wrong; throws off probability of result == zero
            if (allowNegative && random.nextBoolean()) {
                return result.negated;
            } else {
                return result;
            }
        }
    }
}

shared Iterable<Whole> wholeStream(
        Random random,
        Integer numBits,
        Boolean allowZero = true,
        Boolean allowNegative = true,
        Boolean randomizeNumBits = false) {

    return { generateWhole(random, numBits,
                           allowZero, allowNegative,
                           randomizeNumBits) }.cycled;
}

shared void doBenches(
        String label,
        {Integer*} lhsBits,
        {Integer*} rhsBits,
        Integer iterations,
        Whole ceylonOp(Whole v1)(Whole v2),
        BigInteger javaOp(BigInteger v1)(BigInteger v2),
        Boolean allowZeroRhs = true,
        Boolean allowNegativeLhs = true,
        Boolean allowNegativeRhs = true) {

    for (lhsBitCount in lhsBits) {
        for (rhsBitCount in rhsBits) { 
            bench1 {
                label = label;
                lhsBits = lhsBitCount;
                rhsBits = rhsBitCount;
                iterations = iterations;
                ceylonOp = ceylonOp;
                javaOp = javaOp;
                allowZeroRhs = allowZeroRhs;
                allowNegativeLhs = allowNegativeLhs;
                allowNegativeRhs = allowNegativeRhs;
            };
        }
    }
}

shared void bench1(
        String label,
        Integer lhsBits,
        Integer rhsBits,
        Integer iterations,
        Whole ceylonOp(Whole v1)(Whole v2),
        BigInteger javaOp(BigInteger v1)(BigInteger v2),
        Boolean allowZeroRhs = true,
        Boolean allowNegativeLhs = true,
        Boolean allowNegativeRhs = true) { 

    // FIXME: better way to create wholes, quickly
    value uniqueRandoms = 100;

    value random = LCGRandom();

    value lhsWholes = wholeStream(random, lhsBits, true, allowNegativeLhs);
    value rhsWholes = wholeStream(random, rhsBits, allowZeroRhs, allowNegativeRhs);

    value wholes = zipPairs(lhsWholes, rhsWholes).take(uniqueRandoms).sequence();
    value bigIntegers = wholes.collect(([Whole, Whole] pair)
        => [BigInteger(pair.first.string), BigInteger(pair.last.string)]);

    bench {
        ["Whole | ``label`` | ``lhsBits`` | ``rhsBits``",
         function () {
            variable Integer sum = 0;
            for (pair in wholes.cycled.take(iterations)) {
                sum = sum * 31 + ceylonOp(pair.first)(pair.last).integer;
            }
            return sum;
        }],
        ["BigInteger | ``label`` | ``lhsBits`` | ``rhsBits``",
         function () {
             variable Integer sum = 0;
             for (pair in bigIntegers.cycled.take(iterations)) {
                 sum = sum * 31 + javaOp(pair.first)(pair.last).longValue();
             }
             return sum;
        }]
    };
}

shared void bench({[String, Object()]+} tests) {
    variable Object expectedResult = 0;
    for (_ in 1:5) {
        for (test in tests) {
            expectedResult = test[1]();
        }
    }

    for (test in tests) {
        Thread.currentThread().sleep(500);
        Integer start = system.nanoseconds;
        value actualResult = test[1]();
        assert(expectedResult == actualResult);
        value time = (system.nanoseconds - start) / 10^6; 
        print ("``time`` | ``test[0]``");
    }
}

shared void doBench() {
    value iterations = 500_000;
    doBenches {
        label = "+";
        lhsBits = {64};
        rhsBits = {64, 64};
        iterations = iterations;
        ceylonOp = Whole.plus;
        javaOp = BigInteger.add;
        allowNegativeLhs = false;
        allowNegativeRhs = false;
    };
    doBenches {
        label = "-";
        lhsBits = {64};
        rhsBits = {64, 64};
        iterations = iterations;
        ceylonOp = Whole.minus;
        javaOp = BigInteger.subtract;
        allowNegativeLhs = false;
        allowNegativeRhs = false;
    };
    doBenches {
        label = "*";
        lhsBits = {64};
        rhsBits = {64, 64};
        iterations = iterations;
        ceylonOp = Whole.times;
        javaOp = BigInteger.multiply;
    };
    doBenches {
        label = "/";
        lhsBits = {64};
        rhsBits = {32, 32};
        iterations = iterations;
        ceylonOp = Whole.divided;
        javaOp = BigInteger.divide;
        allowZeroRhs = false;
    };
    doBenches {
        label = "%";
        lhsBits = {64};
        rhsBits = {32, 32};
        iterations = iterations;
        ceylonOp = Whole.remainder;
        javaOp = BigInteger.remainder;
        allowZeroRhs = false;
    };
    doBenches {
        label = "gcd";
        lhsBits = {64};
        rhsBits = {32, 32};
        iterations = iterations;
        ceylonOp = curry(gcd);
        javaOp = BigInteger.gcd;
        allowZeroRhs = false;
    };
}
