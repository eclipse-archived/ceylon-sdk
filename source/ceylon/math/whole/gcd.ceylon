import ceylon.math.integer {
    smallest
}

"The greatest common divisor."
shared Whole gcd(Whole first, Whole second) {

    function gcdPositive(variable Whole first, variable Whole second) {
        assert (first.positive, second.positive);

        // Knuth 4.5.2 Algorithm A
        // (Euclidean algorithm while u & v are very different in size)
        while (!second.zero && !(-2 < first.wordsSize - second.wordsSize < 2)) {
            // gcd(u, v) = gcd(v, u - qv)
            value r = first % second; // r will be >= 0
            first = second;
            second = r;
        }

        if (second.zero) {
            return first;
        }

        variable value u = MutableWhole.CopyOfWhole(first);
        variable value v = MutableWhole.CopyOfWhole(second);

        // Knuth 4.5.2 Algorithm B
        // (Binary method to find the gcd)
        value uZeroBits = u.trailingZeros;
        value vZeroBits = v.trailingZeros;

        // if u and v are both even, gcd(u, v) = 2 gcd(u/2, v/2)
        value zeroBits = smallest(uZeroBits, vZeroBits);

        // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
        u.inplaceRightArithmeticShift(uZeroBits);
        v.inplaceRightArithmeticShift(vZeroBits);

        // make u be the larger one
        if (u < v) {
            value tmp = u;
            u = v;
            v = tmp;
        }

        while (!v.zero) {
            // TODO: optimize when both u and v are single word
            // u & v are both odd
            while (true) {
                // gcd(u, v) = gcd(u - v, v)
                u.inplaceSubtract(v); // u will be even and >= 0
                // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
                u.inplaceRightArithmeticShift(u.trailingZeros);
                if (v > u) {
                    break;
                }
            }
            // make u the larger one, again
            value tmp = u;
            u = v;
            v = tmp;
        }

        u.inplaceLeftLogicalShift(zeroBits);
        return Whole.CopyOfMutableWhole(u);
    }

    return if (first.zero) then
        second.magnitude
    else if (second.zero) then
        first.magnitude
    else gcdPositive(first.magnitude, second.magnitude);
}
