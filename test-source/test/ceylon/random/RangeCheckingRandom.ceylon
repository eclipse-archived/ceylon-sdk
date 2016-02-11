import ceylon.random {
    Random,
    randomLimits
}

shared
class RangeCheckingRandom
        (Random delegate)
        satisfies Random {

    shared actual
    Integer nextBits(Integer bits) {
        value result = delegate.nextBits(bits);
        assert(bits <= randomLimits.maxBits);
        assert((bits == 0 && result == 0) ||
                bits == 64 ||
                0 <= result <= 2^bits - 1);
        return result;
    }

    shared actual
    Integer nextInteger(Integer bound) {
        value result = delegate.nextInteger(bound);
        assert(1 <= bound <= randomLimits.maxIntegerBound);
        assert(0 <= result < bound);
        return result;
    }

    shared actual
    Boolean nextBoolean()
        =>  delegate.nextBoolean();

    shared actual
    Byte nextByte()
        =>  delegate.nextByte();

    shared actual
    Float nextFloat() {
        value result = delegate.nextFloat();
        assert(0.0 <= result < 1.0);
        return result;
    }

    shared actual
    Element|Absent nextElement<Element, Absent=Null>
            (Iterable<Element, Absent> stream)
            given Element satisfies Object
            given Absent satisfies Null
        =>  delegate.nextElement(stream);
}
