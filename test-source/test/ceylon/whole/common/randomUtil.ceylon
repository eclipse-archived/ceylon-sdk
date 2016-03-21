import ceylon.whole {
    zero,
    Whole,
    one
}
import ceylon.random {
    randomLimits,
    Random,
    DefaultRandom
}

shared Random random = DefaultRandom();

shared  Whole randomWholeBits(variable Integer bits) {
    variable Whole result = zero;
    while (bits > 0) {
        value x = smallest(bits, 32);
        result = result.leftLogicalShift(x);
        result = result.plusInteger(random.nextBits(x));
        bits -= x;
    }
    return result;
}

shared Whole generateWhole(
        Integer bits,
        Boolean zero = true,
        Boolean negative = true,
        Boolean randomizeBits = true) {
    assert (1 <= bits);
    while (true) {
        value nBits =
                if (!randomizeBits)
                then bits
                else random.nextInteger(bits) + 1;
        value result = randomWholeBits(nBits);
        if (zero || !result.zero) {
            // equal probability for any magnitude
            // (zero is more likely than either -1 or 1)
            if (negative && random.nextBoolean()) {
                return result.negated;
            } else {
                return result;
            }
        }
    }
}

shared Integer generateInteger(
        Integer bits,
        Boolean zero = true,
        Boolean negative = true,
        Boolean randomizeBits = true) {
    assert (1 <= bits <= 63);
    while (true) {
        value nBits =
                if (!randomizeBits)
                then bits
                else random.nextInteger(bits) + 1;
        value result = random.nextBits(nBits);
        if (zero || !result.zero) {
            // equal probability for any magnitude
            // (zero is more likely than either -1 or 1)
            if (negative && random.nextBoolean()) {
                return result.negated;
            } else {
                return result;
            }
        }
    }
}

// positive Integer's only
Integer maxBits = smallest(randomLimits.maxBits, 62);

"Generate a pseudorandom [[ceylon.whole::Whole]] number in the range `origin`
 (inclusive) to `bound` (exclusive)."
throws (`class Exception`, "if origin <= bound")
shared Whole randomWhole(
        "The lower bound, inclusive. May be negative."
        Whole origin,
        "The upper bound, exclusive. Must be greater than `origin`."
        Whole bound,
        "The entropy source."
        Random random = DefaultRandom()) {
    value magnitude = bound - origin - one;

    if (magnitude.negative) {
        throw Exception("origin must be less than bound");
    } else if (magnitude.zero) {
        return origin;
    } else {
        value bits = bitLength(magnitude);
        variable Whole x;
        while ((x = randomWholeBits(bits)) > magnitude) { }
        return x - origin;
    }
}

shared Integer bitLength(variable Whole number) {
    assert(!number.negative);
    variable value bits = 0;
    while (number.positive) {
        bits++;
        number = number.rightArithmeticShift(1);
    }
    return bits;
}
