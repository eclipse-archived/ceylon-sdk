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
         value for each iteration of each test. Common values
         and expected failure rates are:

            - 3.890592, 1 in 10,000
            - 4.417173, 1 in 100,000
            - 4.891638, 1 in 1,000,000
            - 5.326724, 1 in 10,000,000

         Note that many individual tests are executed for each [[StandardTests]] run.
         Also note that failure rates may be slightly higher then expected for some
         psuedorandom number generators due to the algorithms used. This is particularly
         true for the chi squared tests."
        Float stdDevs = 5.326724) {

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
