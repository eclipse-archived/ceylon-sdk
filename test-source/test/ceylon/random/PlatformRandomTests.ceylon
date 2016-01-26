import ceylon.random {
    platformRandom
}

shared
class PlatformRandomTests() extends StandardTests(
        // increase value for stdDevs if this test fails
        // to often on platforms with bad rng's
        platformRandom, 32, 3.890592) {}
