import ceylon.random {
    LCGRandom
}

shared
class LCGRandomTests() extends StandardTests(
        LCGRandom,
        if (realInts) then 32 else 15) {}
