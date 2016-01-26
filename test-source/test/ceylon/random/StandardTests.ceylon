import ceylon.test {
    test
}

import ceylon.random {
    Random
}

shared abstract
class StandardTests(
        Random() random,
        "Number of random bits produced per iteration of the
         underlying random number generator."
        Integer baseBitLength,
        "Allowable number of standard devations from expected
         value for each iteration of each test; with 3.89 std
         deviations, expected failure rate is 1 in 10k."
        Float stdDevs = 3.890592) {

    function factory() => RangeCheckingRandom(random());

    test shared
    void testRange()
        =>  package.testRange(random());

    test shared
    void testAverageAndVarianceOfIntegers()
        =>  package.testAverageAndVarianceOfIntegers(
                factory(), stdDevs);

    test shared
    void testAverageAndVarianceOfFloats()
        =>  package.testAverageAndVarianceOfFloats(
                factory(), stdDevs);

    test shared
    void testAverageAndVarianceOfBytes()
        =>  package.testAverageAndVarianceOfBytes(
                factory(), stdDevs);

    test shared
    void testAverageAndVarianceOfBooleans()
        =>  package.testAverageAndVarianceOfBytes(
                BooleanBackedRandom(
                    random().nextBoolean),
                    stdDevs);

    test shared
    void testChiSquaredBytes()
        =>  package.testChiSquaredBytes(
                factory(), stdDevs);

    test shared
    void testChiSquaredBooleans()
        =>  package.testChiSquaredBytes(
                BooleanBackedRandom(
                    random().nextBoolean),
                    stdDevs);

    test shared
    void testChiSquaredBits()
        =>  package.testChiSquaredBits(
                factory(), stdDevs);

    test shared
    void testChiSquaredBitRanges() {
        for (i in 0:baseBitLength - 8) {
            package.testChiSquaredBytes(
                RangeCheckingRandom(
                    BitMappingRandom(
                        random(),
                        baseBitLength, i, 8)),
                stdDevs);
        }
    }

    shared
    void runTests() {
        executeTests([
            "testRange" -> testRange,
            "testAverageAndVarianceOfIntegers" -> testAverageAndVarianceOfIntegers,
            "testAverageAndVarianceOfFloats" -> testAverageAndVarianceOfFloats,
            "testAverageAndVarianceOfBytes" -> testAverageAndVarianceOfBytes,
            "testAverageAndVarianceOfBooleans" -> testAverageAndVarianceOfBooleans,
            "testChiSquaredBytes" -> testChiSquaredBytes,
            "testChiSquaredBooleans" -> testChiSquaredBooleans,
            "testChiSquaredBits" -> testChiSquaredBits,
            "testChiSquaredBitRanges" -> testChiSquaredBitRanges
        ]);
    }
}
