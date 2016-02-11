import ceylon.random {
    Random,
    randomLimits
}

shared
class BooleanBackedRandom(
        Boolean() generate)
        satisfies Random {

    shared actual
    Integer nextBits(Integer bits) {
        if (bits > randomLimits.maxBits) {
            throw Exception("bits cannot be greater than \
                             ``randomLimits.maxBits`` on this platform");
        }
        else {
            variable value result = 0;
            for (bit in 0:bits) {
                result *= 2;
                result += if (generate())
                          then 1 else 0;
            }
            return result;
        }
    }
}
