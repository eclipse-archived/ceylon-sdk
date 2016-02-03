import ceylon.random {
    Random
}

"A random number generator that delegates to a new [[Random]] instance created using the
 given factory on each invocation of [[nextBits]]. This class can be used to test for
 proper seeding of [[Random]]s produced by the given factory."
shared
class RandomBackedRandom(Random() newRandom) satisfies Random {

    shared actual
    Integer nextBits(Integer bits)
        =>  newRandom().nextBits(bits);
}
