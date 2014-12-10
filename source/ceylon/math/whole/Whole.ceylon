"An arbitrary precision integer."
shared final class Whole
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    shared actual Integer sign;

    Words words;

    variable Integer? integerMemo = null;

    variable String? stringMemo = null;

    variable Integer lastNonZeroIndexMemo = -99;

    shared new Internal(Integer sign, variable Words words) {
        // FIXME should be package private when available
        words = normalized(words);

        // words must fit with word-size bits
        //if (words.any((word) => word != word.and(wordMask))) {
        //    throw OverflowException("Invalid word");
        //}

        // sign must not be 0 if magnitude != 0
        assert (-1 <= sign <= 1);
        assert (!sign == 0 || size(words) == 0);

        this.sign = if (size(words) == 0) then 0 else sign;
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
                 [Internal(sign * other.sign, resultWords.first),
                  Internal(sign, resultWords.last)]));
    }

    shared actual Whole divided(Whole other)
        =>  quotientAndRemainder(other).first;

    shared actual Whole remainder(Whole other)
        =>  quotientAndRemainder(other).last;

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
            for (i in (size(words) - count):count) {
                // most significant first
                Integer x;

                if (0 <= i < size(words)) {
                    if (negative) {
                        x = if (i >= lastNonZeroIndex)
                            then get(words, i).negated // negate the least significant non-zero
                            else get(words, i).not;    // flip the other non-zeros
                    }
                    else {
                        x = get(words, i);
                    }
                } else {
                    x = if (negative) then -1 else 0;
                }
                result = result.leftLogicalShift(wordSize);
                result = result.plus(x.and(wordMask));
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

    shared actual Boolean positive => sign == 1;

    shared actual Boolean negative => sign == -1;

    shared actual Boolean zero => sign == 0;

    shared actual Boolean unit => this == one;

    // TODO doc
    shared Boolean even
        =>  let (wordCount = size(words))
            if (wordCount > 0)
            then get(words, wordCount - 1).even
            else false;

    "The platform-specific implementation object, if any.
     This is provided for interoperation with the runtime
     platform."
    see(`function fromImplementation`)
    shared Object? implementation => nothing;  // TODO remove once decimal allows

    shared actual Integer hash {
        variable Integer result = 0;
        for (i in 0:size(words)) {
            result = result * 31 + get(words, i);
        }
        return sign * result;
    }

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
                x = qr.first;
                sb.append (qr.last.integer.string);
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
                 wordsEqual(this.words, that.words))
            else
                false;

    Integer lastNonZeroIndex
        =>  if (lastNonZeroIndexMemo != -99)
            then lastNonZeroIndexMemo
            else (lastNonZeroIndexMemo =
                    lastIndexWhere(words, (word) => word != 0)
                    else -1);

    Words add(Words first, Words second) {
        // Knuth 4.3.1 Algorithm A
        //assert(!first.empty && !second.empty);

        Words u;
        Words v;
        if (size(first) >= size(second)) {
            u = first;
            v = second;
        } else {
            u = second;
            v = first;
        }
        value wMask = wordMask;
        value wSize = wordSize;
        value result = newWords(size(u));

        // start from the last element (least-significant)
        variable value uIndex = size(u) - 1;
        variable value vIndex = size(v) - 1;
        variable value carry = 0;

        while (vIndex >= 0) {
            value sum = get(u, uIndex) + get(v, vIndex) + carry;
            result.set(uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wSize);
            uIndex -= 1;
            vIndex -= 1;
        }

        while (uIndex >= 0) {
            if (carry == 0) {
                // simply copy the remaining words from u
                copyWords(u, result, 0, 0, uIndex + 1);
                break;
            }
            value sum = get(u, uIndex) + carry;
            result.set(uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wSize);
            uIndex -= 1;
        }

        // remaining carry, if any
        return if (carry != 0)
               then consWord(1, result)
               else result;
    }

    Words subtract(Words u, Words v, Words? r = null) {
        // Knuth 4.3.1 Algorithm S
        // assert(compareMagnitude(u, v) == larger);
        value result = r else newWords(size(u));
        value resultSize = size(result);
        variable value borrow = 0;

        // start from the last element (least-significant)
        for (j in 0:size(u)) {
            value uj = get(u, size(u) - j - 1); // never null
            value vj = if (j < size(v)) then get(v, size(v) - j - 1) else 0; // null when index < 0
            value difference = uj - vj + borrow;
            result.set(resultSize - j - 1, difference.and(wordMask));
            borrow = difference.rightArithmeticShift(wordSize);
        }

        // zero out the leading portion of the result array
        // if an oversized array was provided
        for (i in 0:resultSize-size(u)) {
            result.set(i, 0);
        }

        return result;
    }

    Words multiply(Words u, Words v) {
        // Knuth 4.3.1 Algorithm M
        value wMask = wordMask;
        value wSize = wordSize;
        
        value result = newWords(size(u) + size(v));
        value resultSize = size(result);

        variable value carry = 0;
        for (i in 0:size(u)) {
            carry = 0;
            for (j in 0:size(v)) {
                value k = resultSize - j - i - 1;
                value ui = get(u, size(u) - i - 1);
                value vj = get(v, size(v) - j - 1);
                value wk = get(result, k);
                value product = ui * vj + wk + carry;
                result.set(k, product.and(wMask));
                carry = product.rightLogicalShift(wSize);
            }
            result.set(resultSize - size(v) - i - 1, carry);
        }
        return result;
    }

    Words multiplyWord(Words u, Integer v, Words? r = null) {
        assert(v.and(wordMask) == v);

        value result = r else newWords(size(u) + 1);
        value resultSize = size(result);

        variable value carry = 0;
        for (i in 0:size(u)) {
            value ui = get(u, size(u) - i - 1);
            value product = ui * v + carry;
            result.set(resultSize - i - 1, product.and(wordMask));
            carry = product.rightLogicalShift(wordSize);
        }
        if (!carry.zero) {
            // provided array may be _exactly_ the right size
            result.set(resultSize - size(u) - 1, carry);
        }
        else if (resultSize >= (size(u) + 1)) {
            // but zero it out if it did have room for a carry word
            result.set(resultSize - size(u) - 1, 0);
        }

        // zero out the leading portion of the result array
        // if an oversized array was provided
        for (i in 0:resultSize - size(u) - 1) {
            result.set(i, 0);
        }

        return result;
    }

    "`u[j+1..j+vSize] <- u[j+1..j+vSize] - v * q`, returning the absolute value
     of the final borrow that would normally be subtracted against u[j]."
    Integer multiplyAndSubtract(Words u,
                                Words v,
                                Integer q,
                                Integer j) {
        assert(size(u) > size(v) + j);
        variable Integer absBorrow = 0;
        for (i in size(v)..1) {
            value vi = get(v, i - 1);
            value ui = get(u, j + i);

            // the product is subtracted, so absBorrow adds to it
            value product = q * vi + absBorrow;
            value difference = ui - product.and(wordMask);
            u.set(j + i, difference.and(wordMask));
            absBorrow = product.rightLogicalShift(wordSize) -
                        difference.rightArithmeticShift(wordSize);
        }
        return absBorrow;
    }

    [Words, Words] divide(
            Words dividend, Words divisor) {
        if (size(divisor) < 2) {
            value first = get(divisor, 0);
            return divideWord(dividend, first);
        }

        // Knuth 4.3.1 Algorithm D
        // assert(size(divisor) >= 2);

        // D1. Normalize
        // TODO: left shift such that v0 >= radix/2 instead of the times approach
        value m = size(dividend) - size(divisor);
        value b = wordRadix;
        value d = b / (get(divisor, 0) + 1);
        Words u;
        Words v;
        if (d == 1) {
            u = consWord(0, words);
            v = divisor;
        }
        else {
            u = multiplyWord(dividend, d); // size(u) == size(dividend) + 1
            v = multiplyWord(divisor, d, newWords(size(divisor)));
        }
        Words q = newWords(m + 1); // quotient
        value v0 = get(v, 0); // most significant, can't be 0
        value v1 = get(v, 1); // second most significant must also exist

        // D2. Initialize j
        for (j in 0..m) {
            // D3. Compute qj
            value uj0 = get(u, j);
            value uj1 = get(u, j+1);
            value uj2 = get(u, j+2);
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
        variable Words remainder = normalized(u);
        if (!remainder.size == 0 && d != 1) {
            remainder = divideWord(remainder, d).first;
        }
        return [q, remainder];
    }

    [Words, Words] divideWord(Words u, Integer v) {
        assert(size(u) >= 1);
        assert(v.and(wordMask) == v);
        variable value r = 0;
        value q = newWords(size(u));
        for (j in 0..size(u)-1) {
            value uj = get(u, j);
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
                   then newWords(0)
                   else wordsOfOne(r)];
    }

    Whole leftLogicalShift(Integer shift) => nothing;

    Comparison compareMagnitude(Words x, Words y) {
        // leading words are most significant, but may be 0
        variable Integer xZeros = 0;
        variable Integer yZeros = 0;

        while (xZeros < size(x) then get(x, xZeros).zero else false) {
            xZeros++;
        }

        while (yZeros < size(y) then get(y, yZeros).zero else false) {
            yZeros++;
        }

        value xRealSize = size(x) - xZeros;
        value yRealSize = size(y) - yZeros;

        if (xRealSize != yRealSize) {
            return xRealSize <=> yRealSize;
        }
        else {
            for (i in 0:xRealSize) {
                value xi = get(x, xZeros + i);
                value yi = get(y, yZeros + i);
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
