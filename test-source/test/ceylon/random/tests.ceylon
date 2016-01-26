import ceylon.test {
    assertTrue
}

import ceylon.random {
    randomLimits,
    Random
}

shared
void testRange(Random random) {

    // don't check 64 bit random numbers, which produce negative integers
    // nextBits range tests
    for (bits in 1..smallest(63, randomLimits.maxBits)) {
        value maxInclusive = 2^bits-1;
        for (val in random.bits(bits).take(1k)) {
            assertTrue(0 <= val <= maxInclusive,
                "nextBits(``bits``); 0 <= ``val`` <= ``maxInclusive``");
        }
    }

    // nextInteger range tests
    value mib = randomLimits.maxIntegerBound;
    //workaround https://github.com/ceylon/ceylon.language/issues/656
    //for (bound in (0:mib).by(mib/100).skip(1)) {
    for (bound in (2..mib-mib/100).by(mib/100)) {
        for (val in random.integers(bound).take(100)) {
            assertTrue(0 <= val < bound,
                "nextInteger(``bound``); 0 <= ``val`` < ``bound``");
        }
    }
}

shared
void testAverageAndVarianceOfIntegers
        (Random random, Float stdDevs) {
    void test(Integer bound) {
        testAverageAndVariance(
                bound.nearestFloat - 1,
                random.integers(bound)
                      .map(Integer.nearestFloat)
                      .take(1k),
                stdDevs);
    }

    // be sure to include 32-bits
    for (exp in (22..52).by(10)) {
        value bound = 2^exp;
        test(bound); // exact power of two
        test(bound + bound/3);
        test(bound - bound/3);
    }
}

shared
void testAverageAndVarianceOfFloats
        (Random random, Float stdDevs)
    =>  testAverageAndVariance(1.0, random.floats().take(1k), stdDevs);

shared
void testAverageAndVarianceOfBytes
        (Random random, Float stdDevs) {
    value bytes = random.bytes();
    value twoBytes = zipPairs(bytes, bytes).map((pair)
        =>  let ([a, b] = pair)
            a.unsigned
                .leftLogicalShift(8)
                .or(b.unsigned));

    testAverageAndVariance(65535.0,
        twoBytes.map(Integer.nearestFloat).take(1k),
        stdDevs);
}

shared
void testAverageAndVariance(max, uniformSamples, stdDevs) {
    "upper bound, inclusive"
    Float max;

    "generate a sample with uniform distribution"
    {Float*} uniformSamples;

    "allowable number of standard devations from mean;
     with 3.89 std deviations, 1 test in 10k should fail"
    Float stdDevs;

    assert (exists [meanStdDevs, varianceStdDevs] =
            meanAndVarianceStdDevs(max, uniformSamples));

    // mean should be close to max/2
    assertTrue(meanStdDevs.magnitude < stdDevs,
            "average of random numbers outside \
             expected value by ``meanStdDevs`` \
             standard deviations");

    assertTrue(varianceStdDevs.magnitude < stdDevs,
            "variance of random numbers outside \
             expected range by ``varianceStdDevs`` \
             standard deviations");
}

shared
Float chiSquaredDeviationsBytes(
        "Bytes to test; should have at
         least [[count]] elements"
        {Byte*} uniformSamples,
        "Number of buckets"
        Integer buckets = 256,
        "Maximum number of samples to test"
        Integer count = buckets * 5)
    =>  chiSquaredDeviations {
            max = 255;
            buckets = buckets;
            samples = uniformSamples
                .map(Byte.unsigned).take(count);
        };

shared
void testChiSquaredBytes
        (Random random, Float stdDevs, String? description = null) {
    value stdDevsMeasured = chiSquaredDeviationsBytes(random.bytes());
    value desc = if (exists description)
                 then "; " + description
                 else "";
    assertTrue(stdDevsMeasured.magnitude < stdDevs,
            "chi squared outside of expected value \
             by ``stdDevsMeasured`` standard deviations"
            + desc);
}

shared
Float chiSquaredBits(Random random, Integer bits)
    =>  if (bits < 64) then
            chiSquaredDeviations {
                max = 2^bits - 1;
                buckets = 2^10;
                samples = random.bits(bits)
                    .take(2^10 * 5);
            }
        else
            // for the 64 bit test, only test the 63 most
            // significant digits to avoid sign issues,
            // which is fine; the lsb would be ignored anyway
            chiSquaredDeviations {
                max = 2^63 - 1;
                buckets = 2^10;
                samples = random.bits(64)
                    .map((i) => i.rightLogicalShift(1))
                    .take(2^10 * 5);
            };

shared
void testChiSquaredBits(Random random, Float stdDevs) {
    for (bits in 10..runtime.integerAddressableSize) {
        value stdDevsMeasured = chiSquaredBits(random, bits);
        assertTrue(stdDevsMeasured.magnitude < stdDevs,
                "chi squared outside of expected value \
                 by ``stdDevsMeasured`` standard deviations
                 for nextBits(``bits``)");
    }
}
