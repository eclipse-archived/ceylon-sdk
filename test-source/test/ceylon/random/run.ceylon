import ceylon.random {
    DefaultRandom
}

shared
void run() {
    DefaultRandomTests().runTests();
}

void executeTests({<String -> Anything()>*} tests) {
    for (testName -> test in tests) {
        //print("Running test: ``testName``");
        try {
            test();
        }
        catch (Throwable t) {
            print("Test failed with message: ``t.message``");
        }
    }
}


shared
void runManyTests() {
    for (i in 0:10k) {
        DefaultRandomTests().runTests();
    }
}

shared
void chiSquaredTesting() {
    value iters = 100k;

    variable value fails_001 = 0;
    variable value fails_01 = 0;
    variable value fails_1 = 0;
    variable value fails_5 = 0;
    variable value fails_10 = 0;
    variable value fails_32 = 0;
    variable value fails_50 = 0;

    for (i in 0:iters) {
        value rng = DefaultRandom();

        value stddevs = chiSquaredBits(rng, 32);
        //value stddevs = chiSquaredDeviationsBytes(rng.bytes(), 256, 256*25);
        //value stddevs = chiSquaredDeviationsBytes(BooleanBackedRandom(rng.nextBoolean).bytes());

        if (stddevs.magnitude > 4.417173) { fails_001++; } // 0.001%
        if (stddevs.magnitude > 3.890592) { fails_01++; } // 0.01%
        if (stddevs.magnitude > 2.575829) { fails_1++; } // 1%
        if (stddevs.magnitude > 1.959964) { fails_5++; } // 5%
        if (stddevs.magnitude > 1.644854) { fails_10++; } // 10%
        if (stddevs.magnitude > 0.994458) { fails_32++; } // 32%
        if (stddevs.magnitude > 0.674490) { fails_50++; } // 50%
        if (stddevs.magnitude > 4.0) {
            print(stddevs);
        }
    }

    print("Failures 001: ``fails_001`` (``fails_001.float / iters * 100``)%");
    print("Failures 01:  ``fails_01`` (``fails_01.float / iters * 100``)%");
    print("Failures 1:   ``fails_1`` (``fails_1.float / iters * 100``)%");
    print("Failures 5:   ``fails_5`` (``fails_5.float / iters * 100``)%");
    print("Failures 10:  ``fails_10`` (``fails_10.float / iters * 100``)%");
    print("Failures 32:  ``fails_32`` (``fails_32.float / iters * 100``)%");
    print("Failures 50:  ``fails_50`` (``fails_50.float / iters * 100``)%");
}
