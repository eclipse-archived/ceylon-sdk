"An arbitrary precision integer."
shared final class Whole
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    Words words;

    shared actual Integer sign;

    variable Integer? integerMemo = null;

    variable String? stringMemo = null;

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
                (let (resultWords = divide(this.words, other.words))
                 [Internal(sign * other.sign, resultWords.first),
                  Internal(sign, resultWords.last)]));
    }

    shared actual Whole divided(Whole other)
        =>  quotientAndRemainder(other).first;

    shared actual Whole remainder(Whole other)
        =>  quotientAndRemainder(other).last;

    shared Whole leftLogicalShift(Integer shift)
        =>  if (shift == 0) then
                this
            else if (shift < 0) then
                Whole.Internal(sign, rightShift(words, -shift, sign))
            else
                Whole.Internal(sign, leftShift(words, shift));

    shared Whole rightArithmeticShift(Integer shift)
        =>  if (shift == 0) then
                this
            else if (shift < 0) then
                Whole.Internal(sign, leftShift(words, -shift))
            else
                Whole.Internal(sign, rightShift(words, shift, sign));

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
            // the two's complement representation. For negative numbers,
            // flip the bits and add 1

            value wSize = wordSize;
            value wMask = wordMask;

            variable Integer result = 0;

            // result should have up to integerAddressableSize bits (32 or 64)
            value count = runtime.integerAddressableSize/wSize;

            value numWords = size(words);
            variable value nonZeroSeen = false;

            for (i in 0:count) {
                // least significant first
                Integer index = numWords - i - 1;

                Integer x;
                if (0 <= index < numWords) {
                    if (negative) {
                        if (!nonZeroSeen) {
                            // negate the least significant non-zero word
                            x = get(words, index).negated;
                            nonZeroSeen = x != 0;
                        }
                        else {
                            // flip the rest
                            x = get(words, index).not;
                        }
                    }
                    else {
                        x = get(words, index);
                    }
                }
                else {
                    x = if (negative) then -1 else 0;
                }
                value newBits = x.and(wMask).leftLogicalShift(i * wSize);
                result = result.or(newBits);
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
    // TODO remove once decimal allows
    shared Object? implementation => nothing;

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

    Words add(Words first, Words second) {
        // Knuth 4.3.1 Algorithm A

        // assert(!first.empty && !second.empty);

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
        value r = newWords(size(u));

        // start from the last element (least-significant)
        variable value uIndex = size(u) - 1;
        variable value vIndex = size(v) - 1;
        variable value carry = 0;

        while (vIndex >= 0) {
            value sum =   get(u, uIndex)
                        + get(v, vIndex)
                        + carry;
            set(r, uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wSize);
            uIndex -= 1;
            vIndex -= 1;
        }

        while (carry != 0 && uIndex >= 0) {
            value sum =   get(u, uIndex)
                        + carry;
            set(r, uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wSize);
            uIndex -= 1;
        }

        if (uIndex >= 0) {
            copyWords(u, r, 0, 0, uIndex + 1);
        }

        // remaining carry, if any
        return if (carry != 0)
               then prependWord(1, r)
               else r;
    }

    Words subtract(Words u, Words v) {
        // Knuth 4.3.1 Algorithm S

        // assert(compareMagnitude(u, v) == larger);

        value wMask = wordMask;
        value wSize = wordSize;
        value r = newWords(size(u));

        // start from the last element (least-significant)
        variable value uIndex = size(u) - 1;
        variable value vIndex = size(v) - 1;
        variable value borrow = 0;

        while (vIndex >= 0) {
            value difference =   get(u, uIndex)
                               - get(v, vIndex)
                               + borrow;
            set(r, uIndex, difference.and(wMask));
            borrow = difference.rightArithmeticShift(wSize);
            uIndex -= 1;
            vIndex -= 1;
        }

        while (borrow != 0 && uIndex >= 0) {
            value difference =   get(u, uIndex)
                               + borrow;
            set(r, uIndex, difference.and(wMask));
            borrow = difference.rightArithmeticShift(wSize);
            uIndex -= 1;
        }

        if (uIndex >= 0) {
            copyWords(u, r, 0, 0, uIndex + 1);
        }

        return r;
    }

    Words multiply(Words u, Words v) {
        // Knuth 4.3.1 Algorithm M

        value wMask = wordMask;
        value wSize = wordSize;
        
        value uSize = size(u);
        value vSize = size(v);
        value rSize = uSize + vSize;
        value r = newWords(rSize);

        // result is all zeros the first time through
        variable value vIndex = vSize - 1;
        variable value carry = 0;
        value uLow = get(u, uSize - 1);
        while (vIndex >= 0) {
            value rIndex = uSize + vIndex;
            value product =   uLow
                            * get(v, vIndex)
                            + carry;
            set(r, rIndex, product.and(wMask));
            carry = product.rightLogicalShift(wSize);
            vIndex -= 1;
        }
        set(r, uSize + vIndex, carry);

        variable value uIndex = uSize - 2; // we already did the first one
        while (uIndex >= 0) {
            value uValue = get(u, uIndex);
            carry = 0;
            vIndex = vSize - 1;
            while (vIndex >= 0) {
                value rIndex = uIndex + vIndex + 1;
                value product =   uValue
                                * get(v, vIndex)
                                + get(r, rIndex)
                                + carry;
                set(r, rIndex, product.and(wMask));
                carry = product.rightLogicalShift(wSize);
                vIndex -= 1;
            }
            set(r, uIndex + vIndex + 1, carry);
            uIndex -= 1;
        }
        return r;
    }

    Words multiplyWord(Words u, Integer v, Words r = newWords(size(u) + 1)) {
        value wMask = wordMask;
        value wSize = wordSize;

        // assert(v.and(wMask) == v);

        variable value carry = 0;
        variable value uIndex = size(u) - 1;
        variable value rIndex = size(r) - 1;

        while (uIndex >= 0) {
            value product =   get(u, uIndex)
                            * v
                            + carry;
            set(r, rIndex, product.and(wMask));
            carry = product.rightLogicalShift(wSize);
            uIndex -= 1;
            rIndex -= 1;
        }

        if (!carry.zero) {
            set(r, rIndex, carry);
            rIndex -= 1;
        }

        while (rIndex >= 0) {
            set(r, rIndex, 0);
            rIndex -= 1;
        }

        return r;
    }

    "`u[j+1..j+vSize] <- u[j+1..j+vSize] - v * q`, returning the absolute value
     of the final borrow that would normally be subtracted against u[j]."
    Integer multiplyAndSubtract(Words u, Words v, Integer q, Integer j) {
        // assert(size(u) > size(v) + j);

        value wMask = wordMask;
        value wSize = wordSize;

        variable value absBorrow = 0;
        variable value uIndex = size(v) + j;
        variable value vIndex = size(v) - 1;

        while (vIndex >= 0) {
            // the product is subtracted, so absBorrow adds to it
            value product =   q
                            * get(v, vIndex)
                            + absBorrow;

            value difference =   get(u, uIndex)
                               - product.and(wMask);

            set(u, uIndex, difference.and(wMask));

            absBorrow =   product.rightLogicalShift(wSize)
                        - difference.rightArithmeticShift(wSize);

            uIndex -= 1;
            vIndex -= 1;
        }
        return absBorrow;
    }

    "`u[j+1..j+vSize] <- u[j+1..j+vSize] + v`, discarding the final carry."
    void addBack(Words u, Words v, Integer j) {
        value wMask = wordMask;
        value wSize = wordSize;

        variable value carry = 0;
        variable value uIndex = size(v) + j;
        variable value vIndex = size(v) - 1;

        while (vIndex >= 0) {
            value sum =   get(u, uIndex)
                        + get(v, vIndex)
                        + carry;
            set(u, uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wSize);
            vIndex -= 1;
            uIndex -= 1;
        }
    }

    Integer highestNonZeroBit(variable Integer x) {
        // not the fastest method, but compatible with JavaScript
        // assert (x > 0);
        variable value result = -1;
        while (x != 0) {
            result++;
            x /= 2;
        }
        return result;
    }

    [Words, Words] divide(
            Words dividend, Words divisor) {
        if (size(divisor) < 2) {
            value first = get(divisor, 0);
            return divideWord(dividend, first);
        }

        // Knuth 4.3.1 Algorithm D
        // assert(size(divisor) >= 2);

        value wMask = wordMask;
        value wSize = wordSize;

        // D1. Normalize (v's highest bit must be set)
        value m = size(dividend) - size(divisor);
        value b = wordRadix;
        value shift = wSize - 1 - highestNonZeroBit(get(divisor, 0));
        Words u;
        Words v;
        if (shift == 0) {
            // u must be longer than dividend by one word
            u = prependWord(0, dividend);
            v = divisor;
        }
        else {
            // u must be longer than dividend by one word
            u = leftShift(dividend, shift, true);
            v = leftShift(divisor, shift);
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
            value uj01 = uj0.leftLogicalShift(wSize) + uj1;
            variable Integer qj;
            variable Integer rj;
            if (uj01 >= 0) {
                qj = uj01 / v0;
                rj = uj01 % v0;
            } else {
                value qrj = unsignedDivide(uj01, v0);
                qj = qrj.rightLogicalShift(wSize);
                rj = qrj.and(wMask);
            }

            while (qj >= b || unsignedCompare(qj * v1, b * rj + uj2) == larger) {
                // qj is too big
                qj -= 1;
                rj += v0;
                if (rj >= b) {
                    break;
                }
            }

            // D4. Multiply and Subtract
            if (qj != 0) {
                value borrow = multiplyAndSubtract(u, v, qj, j);
                // D5. Test Remainder
                if (borrow != uj0) {
                    // D6. Add Back
                    // estimate for qj was too high
                    qj -= 1;
                    addBack(u, v, j);
                }
                set(u, j, 0);
                set(q, j, qj);
            }
            // D7. Loop
        }

        // D8. Unnormalize Remainder Due to Step D1
        value remainder = if (shift == 0 || size(u) == 0)
                          then u
                          else rightShift(u, shift, 1);

        return [q, remainder];
    }

    [Words, Words] divideWord(Words u, Integer v) {
        value wMask = wordMask;
        value wSize = wordSize;

        value uSize = size(u);

        // assert(uSize >= 1);
        // assert(v.and(wMask) == v);

        value q = newWords(uSize);
        variable value r = 0;
        for (uIndex in 0:uSize) {
            value x = r.leftLogicalShift(wSize) + get(u, uIndex);
            if (x >= 0) {
                set(q, uIndex, x / v);
                r = x % v;
            } else {
                value qr = unsignedDivide(x, v);
                set(q, uIndex, qr.rightLogicalShift(wSize));
                r = qr.and(wMask);
            }
        }
        return [q, if (r.zero)
                   then newWords(0)
                   else wordsOfOne(r)];
    }

    Words leftShift(Words u, Integer shift, Boolean alwaysPad = false) {
        assert (shift > 0);

        value wSize = wordSize;
        value wMask = wordMask;

        value uSize = size(u);
        value shiftBits = shift % wSize;
        value shiftWords = shift / wSize;

        Words r;

        if (shiftBits == 0) {
            value extraWord = if (alwaysPad) then 1 else 0;
            r = newWords(uSize + shiftWords + extraWord);
            copyWords(u, r, 0, extraWord);
        }
        else {
            value shiftBitsRight = wSize - shiftBits;
            value highWord = get(u, 0).rightLogicalShift(shiftBitsRight);
            variable value rIndex = 0;
            if (alwaysPad || highWord != 0) {
                r = newWords(uSize + shiftWords + 1);
                set(r, 0, highWord);
                rIndex += 1;
            }
            else {
                r = newWords(uSize + shiftWords);
            }
            variable value prev = get(u, 0);
            for (i in 1:uSize-1) {
                value curr = get(u, i);
                set(r, rIndex, prev.leftLogicalShift(shiftBits)
                                   .or(curr.rightLogicalShift(shiftBitsRight))
                                   .and(wMask));
                prev = curr;
                rIndex += 1;
            }
            set (r, rIndex, get(u, uSize-1)
                             .leftLogicalShift(shiftBits)
                             .and(wMask));
        }
        return r;
    }

    function increment(Words w) {
        value wMask = wordMask;
        variable value last = 0;
        variable value uIndex = size(w);
        while (--uIndex >= 0 && last == 0) {
            last = (get(w, uIndex) + 1).and(wMask);
            set(w, uIndex, last);
        }

        if (last == 0) {
            value result = newWords(size(w) + 1);
            set(result, 0, 1);
            return result;
        }
        else {
            return w;
        }
    }

    Boolean nonZeroBitsDropped(Words u,
                               Integer shiftWords,
                               Integer shiftBits) {
        value wMask = wordMask;
        value uSize = size(u);

        for (i in 1:shiftWords) {
            if (get(u, uSize - i) != 0) {
                return true;
            }
        }

        return (shiftBits > 0) &&
                get(u, uSize - shiftWords - 1)
                .leftLogicalShift(32 - shiftBits)
                .and(wMask) != 0;
    }

    Words rightShift(Words u, Integer shift, Integer sign) {
        assert (shift > 0);

        value wSize = wordSize;
        value wMask = wordMask;

        value uSize = size(u);
        value shiftBits = shift % wSize;
        value shiftWords = shift / wSize;

        Words r;

        if (shiftWords >= uSize) {
            return if (sign < 0) then wordsOfOne(1) else newWords(0);
        }

        if (shiftBits == 0) {
            value rSize = uSize - shiftWords;
            r = newWords(rSize);
            copyWords(u, r, 0, 0, rSize);
        }
        else {
            value highWord = get(u, 0).rightLogicalShift(shiftBits);
            variable value rIndex = 0;
            if (highWord != 0) {
                r = newWords(uSize - shiftWords);
                set(r, 0, highWord);
                rIndex += 1;
            }
            else {
                r = newWords(uSize - shiftWords - 1);
            }
            value shiftBitsLeft = wSize - shiftBits;
            variable value prev = get(u, 0);
            for (i in 1:uSize - shiftWords - 1) {
                value curr = get(u, i);
                set(r, rIndex, prev.leftLogicalShift(shiftBitsLeft)
                                   .or(curr.rightLogicalShift(shiftBits))
                                   .and(wMask));
                prev = curr;
                rIndex += 1;
            }
        }

        // for negative numbers, if any one bits were lost,
        // add one to the magnitude to simulate two's
        // complement arithmetic right shift
        return
        if (sign < 0 &&
            nonZeroBitsDropped(u, shiftWords, shiftBits))
        then increment(r)
        else r;
    }

    Comparison compareMagnitude(Words x, Words y) {
        // leading words are most significant, but may be 0
        variable Integer xZeros = 0;
        variable Integer yZeros = 0;

        value xSize = size(x);
        value ySize = size(y);

        while (xZeros < xSize && get(x, xZeros) == 0) {
            xZeros++;
        }

        while (yZeros < ySize && get(y, yZeros) == 0) {
            yZeros++;
        }

        value xRealSize = xSize - xZeros;
        value yRealSize = ySize - yZeros;

        if (xRealSize != yRealSize) {
            return if (xRealSize < yRealSize) then smaller else larger;
        }
        else {
            for (i in 0:xRealSize) {
                value xi = get(x, xZeros + i);
                value yi = get(y, yZeros + i);
                if (xi != yi) {
                    return if (xi < yi) then smaller else larger;
                }
            }
            return equal;
        }
    }
}
