import ceylon.random {
    Random,
    randomLimits
}

shared
class BitMappingRandom(
        Random delegate,
        Integer requestBits,
        Integer lowBit,
        Integer useBits)
        satisfies Random {

    value highBit = lowBit + useBits - 1;

    assert (requestBits <= 63); // don't support negative #s
    assert (requestBits >= highBit + 1);
    assert (highBit >= lowBit);
    assert (lowBit >= 0);
    assert (requestBits <= randomLimits.maxBits);
    assert (useBits <= requestBits);

    Integer next()
        =>  delegate.nextBits(requestBits)
                    % 2^(highBit + 1);

    shared actual
    Integer nextBits(Integer bits) {
        if (bits <= 0) {
            return 0;
        }
        else if (bits <= useBits) {
            return next() / (2^(highBit + 1 - bits));
        }
        else if (bits <= randomLimits.maxBits) {
            variable value remaining = bits;
            variable Integer result = 0;
            while (remaining > 0) {
                value count = if (remaining <= useBits)
                              then remaining
                              else useBits;
                result *= 2^count;
                result += nextBits(count);
                remaining -= count;
            }
            return result;
        }
        else {
            throw Exception("bits cannot be greater than \
                             ``randomLimits.maxBits`` on this platform");
        }
    }
}
