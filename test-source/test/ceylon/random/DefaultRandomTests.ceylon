import ceylon.random {
    DefaultRandom
}

shared
class DefaultRandomTests() extends StandardTests(
        DefaultRandom,
        if (realInts) then 32 else 15) {}
