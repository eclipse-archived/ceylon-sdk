"An arbitrary precision integer."
shared final class Whole
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    shared actual Integer sign;

    List<Integer> words;

    variable Integer? integerMemo = null;

    variable String? stringMemo = null;

    variable Integer? lastNonZeroIndexMemo = null;

    shared new Internal(Integer sign, variable List<Integer> words) {
        // FIXME should be package private when available
        words = normalized(words);

        // words must fit with word-size bits
        if (words.any((word) => word != word.and(wordMask))) {
            throw OverflowException("Invalid word");
        }

        // sign must not be 0 if magnitude != 0
        assert (-1 <= sign <= 1);
        assert (!sign.zero || words.empty);

        this.sign = words.empty then 0 else sign;
        this.words = words;
    }

    shared actual Whole plus(Whole other)
        =>  if (zero) then
                other
            else if (other.zero) then
                this
            else if (sign == other.sign) then
                Internal(sign, add(words, other.words))
            else
               (switch (compareMagnitude(this.words, other.words))
                case (equal)
                    package.zero
                case (larger)
                    Internal(sign, subtract(words, other.words))
                case (smaller)
                    Internal(sign.negated, subtract(other.words, words)));

    shared actual Whole plusInteger(Integer integer)
        =>  plus(wholeNumber(integer));

    shared actual Whole times(Whole other)
        =>  if (this.zero || other.zero) then
                package.zero
            else if (this.unit) then
                other
            else if (this == negativeOne) then
                other.negated
            else
                Internal(this.sign * other.sign, multiply(words, other.words));

    shared actual Whole timesInteger(Integer integer)
        =>  times(wholeNumber(integer));

    // TODO doc
    shared [Whole, Whole] quotientAndRemainder(Whole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            [package.zero, package.zero]
        else if (other.unit) then
            [this, package.zero]
        else if (other == package.negativeOne) then
            [this.negated, package.zero]
        else (
            switch (compareMagnitude(this.words, other.words))
            case (equal)
                [if (sign == other.sign)
                    then package.one
                    else package.negativeOne,
                 package.zero]
            case (smaller)
                [package.zero, this]
            case (larger)
                (let (resultWords   = divide(this.words, other.words))
                 [Internal(sign * other.sign, resultWords[0]),
                  Internal(sign, resultWords[1])]));
    }

    shared actual Whole divided(Whole other)
        =>  quotientAndRemainder(other)[0];

    shared actual Whole remainder(Whole other)
        =>  quotientAndRemainder(other)[1];

    "The result of raising this number to the given power.

     Special cases:

     * Returns one if `this` is one (or all powers)
     * Returns one if `this` is minus one and the power
       is even
     * Returns minus one if `this` is minus one and the
       power is odd
     * Returns one if the power is zero.
     * Otherwise negative powers result in an `Exception`
       being thrown"
    throws(`class Exception`, "If passed a negative or large
                               positive exponent")
    shared actual Whole power(Whole exponent) {
        if (this == package.one) {
            return this;
        }
        else if (exponent == package.zero) {
            return one;
        }
        else if (this == package.negativeOne && exponent.even) {
            return package.one;
        }
        else if (this == package.negativeOne && !exponent.even) {
            return this;
        }
        else if (exponent == package.one) {
            return this;
        }
        else if (exponent > package.one) {
            // TODO a reasonable implementation
            variable Whole result = this;
            for (_ in package.one..exponent-package.one) {
                result = result * this;
            }
            return result;
        }
        else {
            throw AssertionError(
                "``string``^``exponent`` cannot be represented as an Integer");
        }
    }

    shared actual Whole powerOfInteger(Integer exponent) {
        if (this == package.one) {
            return this;
        }
        else if (exponent == 0) {
            return one;
        }
        else if (this == package.negativeOne && exponent.even) {
            return package.one;
        }
        else if (this == package.negativeOne && !exponent.even) {
            return this;
        }
        else if (exponent == 1) {
            return this;
        }
        else if (exponent > 1) {
            // TODO a reasonable implementation
            variable Whole result = this;
            for (_ in 1..exponent-1) {
                result = result * this;
            }
            return result;
        }
        else {
            throw AssertionError(
                "``string``^``exponent`` cannot be represented as an Integer");
        }
    }

    "The result of `(this**exponent) % modulus`."
    throws(`class Exception`, "If passed a negative modulus")
    shared Whole powerRemainder(Whole exponent,
                                Whole modulus) => nothing;

    shared actual Whole neighbour(Integer offset)
        => plusInteger(offset);

    "The distance between this whole and the other whole"
    throws(`class OverflowException`,
        "The numbers differ by an amount larger than can be represented as an `Integer`")
    shared actual Integer offset(Whole other) {
        value diff = this - other;
        if (integerMin <= diff <= integerMax) {
            return diff.integer;
        }
        else {
            throw OverflowException();
        }
    }

    // TODO document 32 bit JS limit; nail down justification, including
    // asymmetry with wholeNumber(). No other amount seems reasonable.
    // JavaScript _almost_ supports 53 bits (1 negative number short),
    // but even so, 53 bits is not a convenient chunk to work with, and
    // is greater than the 32 bits supported for bitwise operations.
    "The number, represented as an [[Integer]]. If the number is too
     big to fit in an Integer then an Integer corresponding to the
     lower order bits is returned."
    shared Integer integer {
        if (exists integerMemo = integerMemo) {
            return integerMemo;
        } else {
            // result is lower runtime.integerAddressableSize bits of
            // the two's complement representation

            // for negative numbers, flip the bits and add 1
            variable Integer result = 0;
            // result should have up to integerAddressableSize bits (32 or 64)
            value count = runtime.integerAddressableSize/wordSize;
            for (i in (words.size - count):count) {
                // most significant first
                variable value x = words[i];
                if (negative, exists xx = x) {
                    if (i >= lastNonZeroIndex) {
                        x = xx.negated; // negate the least significant non-zero
                    } else {
                        x = xx.not; // flip the other non-zeros
                    }
                }
                result = result.leftLogicalShift(wordSize);
                result = result.plus((x else (negative then -1 else 0)).and(wordMask));
            }
            return integerMemo = result;
        }
    }

    "The number, represented as a [[Float]]. If the magnitude of this number
     is too large the result will be `infinity` or `-infinity`. If the result
     is finite, precision may still be lost."
    shared Float float {
        assert (exists f = parseFloat(string));
        return f;
    }

    shared actual Whole negated
        =>  if (zero) then
                package.zero
            else if (this.unit) then
                package.negativeOne
            else if (this == package.negativeOne) then
                package.one
            else Internal(sign.negated, words);

    shared actual Whole wholePart => this;

    shared actual Whole fractionalPart => package.zero;

    shared actual Boolean positive => sign.positive;

    shared actual Boolean negative => sign.negative;

    shared actual Boolean zero => sign.zero;

    shared actual Boolean unit => this == one;

    // TODO doc
    shared Boolean even => words.last?.even else false;

    "The platform-specific implementation object, if any.
     This is provided for interoperation with the runtime
     platform."
    see(`function fromImplementation`)
    shared Object? implementation => nothing;  // TODO remove once decimal allows

    shared actual Integer hash
        => sign * words.fold(0)((acc, x) => 31*acc + x);

    shared actual String string {
        // TODO optimize? & support any radix
        if (exists stringMemo = stringMemo) {
            return stringMemo;
        }
        else if (this.zero) {
            return stringMemo = "0";
        }
        else {
            // Use Integer once other fn's are optimized
            value toRadix = wholeNumber(10);
            value sb = StringBuilder();
            variable value x = this.magnitude;
            while (!x.zero) {
                value qr = x.quotientAndRemainder(toRadix);
                x = qr[0];
                sb.append (qr[1].integer.string);
            }
            if (negative) {
                sb.append("-");
            }
            return stringMemo = sb.string.reversed;
        }
    }

    shared actual Comparison compare(Whole other)
        =>  if (sign != other.sign) then
                sign.compare(other.sign)
            else if (zero) then
                equal
            else if (positive) then
                compareMagnitude(this.words, other.words)
            else
                compareMagnitude(other.words, this.words);

    shared actual Boolean equals(Object that)
        =>  if (is Whole that) then
                (this === that) ||
                (this.sign == that.sign &&
                 this.words == that.words)
            else
                false;

    Integer lastNonZeroIndex
            =>  lastNonZeroIndexMemo
                else (lastNonZeroIndexMemo =
                      words.lastIndexWhere((word) => word != 0) else -1);

    Array<Integer> add(List<Integer> first, List<Integer> second) {
        // Knuth 4.3.1 Algorithm A
        assert(!first.empty && !second.empty);

        List<Integer> u;
        List<Integer> v;
        if (first.size >= second.size) {
            u = first;
            v = second;
        } else {
            u = second;
            v = first;
        }

        value result = arrayOfSize(u.size, 0);
        value resultSize = result.size;
        variable value carry = 0;

        // start from the last element (least-significant)
        for (j in 0:u.size) {
            value uj = u.getFromLast(j) else 0; // never null
            value vj = v.getFromLast(j) else 0; // null when index < 0
            value sum = uj + vj + carry;
            result.set(resultSize - j - 1, sum.and(wordMask));
            carry = sum.rightLogicalShift(wordSize);
        }

        // remaining carry, if any
        return if (carry != 0)
               then Array { 1, *result }
               else result;
    }

    List<Integer> subtract(List<Integer> u, List<Integer> v, Array<Integer>? r = null) {
        // Knuth 4.3.1 Algorithm S
        // assert(compareMagnitude(u, v) == larger);
        value result = r else arrayOfSize(u.size, 0);
        value resultSize = result.size;
        variable value borrow = 0;

        // start from the last element (least-significant)
        for (j in 0:u.size) {
            value uj = u.getFromLast(j) else 0; // never null
            value vj = v.getFromLast(j) else 0; // null when index < 0
            value difference = uj - vj + borrow;
            result.set(resultSize - j - 1, difference.and(wordMask));
            borrow = difference.rightArithmeticShift(wordSize);
        }

        // zero out the leading portion of the result array
        // if an oversized array was provided
        for (i in 0:resultSize-u.size) {
            result.set(i, 0);
        }

        return result;
    }

    Array<Integer> multiply(List<Integer> u, List<Integer> v) {
        // Knuth 4.3.1 Algorithm M
        value result = arrayOfSize(u.size + v.size, 0);
        value resultSize = result.size;

        variable value carry = 0;
        for (i in 0:u.size) {
            carry = 0;
            for (j in 0:v.size) {
                value k = resultSize - j - i - 1;
                assert (exists ui = u.getFromLast(i));
                assert (exists vj = v.getFromLast(j));
                assert (exists wk = result[k]);
                value product = ui * vj + wk + carry;
                result.set(k, product.and(wordMask));
                carry = product.rightLogicalShift(wordSize);
            }
            result.set(resultSize - v.size - i - 1, carry);
        }
        return result;
    }

    Array<Integer> multiplyWord(List<Integer> u, Integer v, Array<Integer>? r = null) {
        assert(v.and(wordMask) == v);

        value result = r else arrayOfSize(u.size + 1, 0);
        value resultSize = result.size;

        variable value carry = 0;
        for (i in 0:u.size) {
            assert (exists ui = u.getFromLast(i));
            value product = ui * v + carry;
            result.set(resultSize - i - 1, product.and(wordMask));
            carry = product.rightLogicalShift(wordSize);
        }
        if (!carry.zero) {
            // provided array may be _exactly_ the right size
            result.set(resultSize - u.size - 1, carry);
        }
        else if (resultSize >= (u.size + 1)) {
            // but zero it out if it did have room for a carry word
            result.set(resultSize - u.size - 1, 0);
        }

        // zero out the leading portion of the result array
        // if an oversized array was provided
        for (i in 0:resultSize - u.size - 1) {
            result.set(i, 0);
        }

        return result;
    }

    "`u[j+1..j+vSize] <- u[j+1..j+vSize] - v * q`, returning the absolute value
     of the final borrow that would normally be subtracted against u[j]."
    Integer multiplyAndSubtract(Array<Integer> u,
                                List<Integer> v,
                                Integer q,
                                Integer j) {
        assert(u.size > v.size + j);
        variable Integer absBorrow = 0;
        for (i in v.size..1) {
            assert(exists vi = v[i - 1]);
            assert(exists ui = u[j + i]);

            // the product is subtracted, so absBorrow adds to it
            value product = q * vi + absBorrow;
            value difference = ui - product.and(wordMask);
            u.set(j + i, difference.and(wordMask));
            absBorrow = product.rightLogicalShift(wordSize) -
                        difference.rightArithmeticShift(wordSize);
        }
        return absBorrow;
    }

    [List<Integer>, List<Integer>] divide(
            List<Integer> dividend, List<Integer> divisor) {
        if (divisor.size < 2) {
            assert (exists first = divisor.first);
            return divideWord(dividend, first);
        }

        // Knuth 4.3.1 Algorithm D
        // assert(divisor.size >= 2);

        // D1. Normalize
        // TODO: left shift such that v0 >= radix/2 instead of the times approach
        value m = dividend.size - divisor.size;
        value b = wordRadix;
        value d = b / ((divisor[0] else 0) + 1);
        Array<Integer> u;
        List<Integer> v;
        if (d == 1) {
            u = Array { 0, *dividend };
            v = divisor;
        }
        else {
            u = multiplyWord(dividend, d); // u.size == dividend.size + 1
            v = multiplyWord(divisor, d, arrayOfSize(divisor.size, 0));
        }
        Array<Integer> q = arrayOfSize(m + 1, 0); // quotient
        assert(exists v0 = v[0], v0 != 0); // most significant, can't be 0
        assert(exists v1 = v[1]); // second most significant must also exist

        // D2. Initialize j
        for (j in 0..m) {
            // D3. Compute qj
            assert(exists uj0 = u[j]);
            assert(exists uj1 = u[j+1]);
            assert(exists uj2 = u[j+2]);
            value uj01 = uj0.leftLogicalShift(wordSize) + uj1;
            variable Integer qj;
            variable Integer rj;
            if (uj01 >= 0) {
                qj = uj01 / v0;
                rj = uj01 % v0;
            } else {
                value qrj = unsignedDivide(uj01, v0);
                qj = qrj.rightLogicalShift(wordSize);
                rj = qrj.and(wordMask);
            }

            while (qj >= b || unsignedCompare(qj * v1, b * rj + uj2) == larger) {
                // qj is too big
                qj -= 1;
                rj += v0;
                if (rj >= b) {
                    break;
                }
            }

            // D4. Multiply, Subtract
            if (qj != 0) {
                value borrow = multiplyAndSubtract(u, v, qj, j);
                if (borrow != uj0) {
                    // assert borrow > uj0;
                    throw Exception("case not handled");
                }
                u.set(j, 0);
                q.set(j, qj);
            }
        }

        // D8. Unnormalize Remainder Due to Step D1
        variable List<Integer> remainder = normalized(u);
        if (!remainder.empty && d != 1) {
            remainder = divideWord(remainder, d)[0];
        }
        return [q, remainder];
    }

    [List<Integer>, List<Integer>] divideWord(List<Integer> u, Integer v) {
        assert(u.size >= 1);
        assert(v.and(wordMask) == v);
        variable value r = 0;
        value q = arrayOfSize(u.size, 0);
        for (j in 0..u.size-1) {
            assert (exists uj = u[j]);
            value x = r * wordRadix + uj;
            if (x >= 0) {
                q.set(j, x / v);
                r = x % v;
            } else {
                value qr = unsignedDivide(x, v);
                q.set(j, qr.rightLogicalShift(wordSize));
                r = qr.and(wordMask);
            }
        }
        return [q, if (r.zero)
                   then empty
                   else Array<Integer> { r }];
    }

    Whole leftLogicalShift(Integer shift) => nothing;

    Comparison compareMagnitude(List<Integer> x, List<Integer> y) {
        // leading words are most significant, but may be 0
        variable Integer xZeros = 0;
        variable Integer yZeros = 0;

        while (x[xZeros]?.zero else false) {
            xZeros++;
        }

        while (y[yZeros]?.zero else false) {
            yZeros++;
        }

        value xRealSize = x.size - xZeros;
        value yRealSize = y.size - yZeros;

        if (xRealSize != yRealSize) {
            return xRealSize <=> yRealSize;
        }
        else {
            for (i in 0:xRealSize) {
                assert(exists xi = x[xZeros + i]);
                assert(exists yi = y[yZeros + i]);
                if (xi != yi) {
                    return xi <=> yi;
                }
            }
            return equal;
        }
    }
}


/*
"The greatest common divisor of the arguments."
shared Whole gcd(Whole a, Whole b) {
    // TODO return Whole(a.val.gcd(b.val));
    throw;
}

"The least common multiple of the arguments."
shared Whole lcm(Whole a, Whole b) {
    return (a*b) / gcd(a, b);
}

"The factorial of the argument."
shared Whole factorial(Whole a) {
    if (a <= Whole(0)) {
        throw;
    }
    variable Whole b = a;
    variable Whole result = a;
    while (b >= Whole(2)) {
        b = b.predecessor;
        result *= b;
    }
    return result;
}
*/
