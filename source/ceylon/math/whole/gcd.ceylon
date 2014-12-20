import ceylon.math.integer {
    smallest
}

"The greatest common divisor."
shared Whole gcd(Whole first, Whole second) {

    function gcdWords(Integer first, Integer second) {
        //value wRadix = wordRadix;
        //assert (0 < first < wRadix && 0 < second < wRadix);

        variable value u = first;
        variable value v = second;

        value uZeroBits = numberOfTrailingZeros(u);
        value vZeroBits = numberOfTrailingZeros(v);

        // if u and v are both even, gcd(u, v) = 2 gcd(u/2, v/2)
        value zeroBits = smallest(uZeroBits, vZeroBits);

        // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
        u = u.rightArithmeticShift(uZeroBits);
        v = v.rightArithmeticShift(vZeroBits);

        // make u be the larger one
        if (u < v) {
            value tmp = u;
            u = v;
            v = tmp;
        }

        while (v != 0) {
            // u & v are both odd
            while (true) {
                // gcd(u, v) = gcd(u - v, v)
                u = u - v; // u will be even and >= 0
                if (u != 0) { // FIXME this is ugly; make numberOfTrailingZeros work for zeros
                    // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
                    u = u.rightArithmeticShift(numberOfTrailingZeros(u));
                }
                if (v > u) {
                    break;
                }
            }
            // make u the larger one, again
            value tmp = u;
            u = v;
            v = tmp;
        }

        return u.leftLogicalShift(zeroBits);
    }

    function gcdPositive(variable Whole first, variable Whole second) {
        //assert (first.positive, second.positive);

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

        // easy case
        if (first.wordsSize == 1 && second.wordsSize == 1) {
            return wholeNumber(gcdWords(first.integer,
                                        second.integer));
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
            // optimize single word case
            if (u.wordsSize == 1) {
                //assert (v.wordsSize == 1);
                return wholeNumber(gcdWords(u.integer, v.integer))
                            .leftLogicalShift(zeroBits);
            }

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
        return Whole.OfWords(1, u.words, u.wordsSize); // helps a little
        //return Whole.CopyOfMutableWhole(u);
    }

    return if (first.zero) then
        second.magnitude
    else if (second.zero) then
        first.magnitude
    else gcdPositive(first.magnitude, second.magnitude);
}
