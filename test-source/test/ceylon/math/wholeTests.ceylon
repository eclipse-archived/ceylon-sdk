import ceylon.math.whole {
    Whole,
    parseWhole,
    wholeNumber,
    one,
    two,
    zero
}
import ceylon.test {
    ...
}

import com.vasileff.ceylon.random.api {
    randomLimits,
    Random,
    stream
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
    } catch (AssertionError e){}
    try {
        Whole wn = wholeNumber(0) ^ wholeNumber(-2);
        fail("0^-2");
    } catch (AssertionError e){}

    assertEquals(wholeNumber(-1), wholeNumber(-1) ^ wholeNumber(1), "-1^1");
    assertEquals(wholeNumber(1), wholeNumber(-1) ^ wholeNumber(0), "-1^0");
    assertEquals(wholeNumber(-1), wholeNumber(-1) ^ wholeNumber(-1), "-1^-1");
    assertEquals(wholeNumber(1), wholeNumber(-1) ^ wholeNumber(-2), "-1^-2");

    assertEquals(wholeNumber(-2), wholeNumber(-2) ^ wholeNumber(1), "-2^-1");
    assertEquals(wholeNumber(1), wholeNumber(-2) ^ wholeNumber(0), "-2^0");
    try {
        Whole wn = wholeNumber(-2) ^ wholeNumber(-1);
        fail("-2^-1");
    } catch (AssertionError e){}
    try {
        Whole wn = wholeNumber(-2) ^ wholeNumber(-2);
        fail("-2^-2");
    } catch (AssertionError e){}
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

Integer iters = 500;
{Integer*} bits = (8..128).by(8).follow(4);

test void wholeTortureAddition() {
    wholeTorture {
        label = "+";
        lhsBits = bits;
        rhsBits = bits;
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
        iterations = iters;
        ceylonOp = Whole.remainder;
        javaOp = BigInteger.remainder;
        allowZeroRhs = false;
    };
}

test void wholeTorturePower() {
    wholeTorture {
        label = "^";
        lhsBits = (2..128).by(16);
        rhsBits = (2..6).by(2);
        iterations = 100;
        ceylonOp = Whole.power;
        javaOp = ((BigInteger x)(BigInteger y) => x.pow(y.intValue()));
        allowNegativeRhs = false;
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
                  Boolean allowNegativeRhs = true) {

    value rng = LCGRandom();
    function generateWhole(Integer bits,
                           Boolean allowZero = true,
                           Boolean allowNegative = true) {
        while (true) {
            value result = randomWholeBits(rng, bits);
            if (allowZero || !result.zero) {
                if (allowNegative && rng.nextBoolean()) {
                    return result.negated;
                } else {
                    return result;
                }
            }
        }
    }

    for (lbits in lhsBits) {
        for (rbits in rhsBits) {
            for (_ in 0:iterations) {
                value lhs = generateWhole(lbits, true, allowNegativeLhs);
                value rhs = generateWhole(rbits, allowZeroRhs, allowNegativeRhs);

                Whole ceylonResult;
                try {
                    ceylonResult = ceylonOp(lhs)(rhs);
                } catch (Exception|AssertionError e) {
                    print ("Whole exception for ``lhs`` ``label`` ``rhs``");
                    throw e;
                }

                BigInteger javaResult;
                try {
                    javaResult = javaOp(BigInteger(lhs.string))
                                       (BigInteger(rhs.string));
                } catch (Exception e) {
                    print ("BigInteger exception for ``lhs`` ``label`` ``rhs``");
                    throw e;
                }

                assertEquals(ceylonResult.string, javaResult.string,
                             "``lhs`` ``label`` ``rhs``");
            }            
        }
    }
}

test void wholeGcdTests() {
    //print("gcd");
    //assertEquals(Whole(6), gcd(Whole(12), Whole(18)), "gcd(12, 18)");
}

// positive Integer's only
Integer maxBits = smallest(randomLimits.maxBits, 62);
shared Whole randomWholeBits(Random random, variable Integer numBits) {
    variable Whole result = zero;
    while (numBits > 0) {
        value x = smallest(numBits, maxBits);
        result = result.timesInteger(2^x);
        result = result.plusInteger(random.nextInteger(2^x));
        numBits -= x;
    }
    return result;
}

shared Iterable<Whole> wholeStream(
        Random random,
        Integer numBits,
        Boolean allowZero = true,
        Boolean allowNegative = true) {
    return stream(() {
        while (true) {
            value result = randomWholeBits(random, numBits);
            if (allowZero || !result.zero) {
                if (allowNegative && random.nextBoolean()) {
                    return result.negated;
                } else {
                    return result;
                }
            }
        }        
    });
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
        rhsBits = {64, 64};
        iterations = iterations;
        ceylonOp = Whole.divided;
        javaOp = BigInteger.divide;
        allowZeroRhs = false;
    };
}
