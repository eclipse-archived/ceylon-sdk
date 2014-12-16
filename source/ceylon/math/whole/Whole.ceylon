"An arbitrary precision integer."
shared final class Whole
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    Words words;

    shared actual Integer sign;

    variable Integer leadingZeroWordCountMemo = -1;

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
        assert (!sign == 0 || sizew(words) == 0);

        this.sign = if (sizew(words) == 0) then 0 else sign;
        this.words = words;
    }

    shared Boolean get(Integer index) {
        if (index < 0) {
            return false;
        }
        else if (zero) {
            return false;
        }
        else if (index > wordSize * sizew(words)) {
            // infinite leading ones in two's complement
            return if (negative) then true else false;
        }
        else if (positive) {
            return getBitPositive(index);
        }
        else {
            return getBitNegative(index);
        }
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

    shared Whole mod(Whole modulus) {
        if (!modulus.positive) {
            throw AssertionError("modulus must be positive");
        }
        return let (result = remainder(modulus))
               if (result.negative)
               then result + modulus
               else result;
    }

    "The result of `(this**exponent) mod modulus`."
    throws(`class Exception`, "If passed a negative modulus")
    shared Whole modPower(Whole exponent,
                          Whole modulus) {
        if (!modulus.positive) {
            throw AssertionError("modulus must be positive");
        }
        else if (modulus.unit) {
            return package.zero;
        }
        else if (this.zero && exponent.positive) {
            return package.zero;
        }
        else if (this.zero && exponent.zero) {
            return package.one;
        }
        else if (exponent.negative) {
            throw Exception("case not handled");
        }
        //assert (modulus > package.zero,
        //        exponent >= package.zero,
        //        this != package.zero);

        value base = if (negative || this >= modulus)
                     then this.mod(modulus)
                     else this;

        return modPowerPositive(base, exponent, modulus);
    }

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

            value numWords = sizew(words);
            variable value nonZeroSeen = false;

            for (i in 0:count) {
                // least significant first
                Integer index = numWords - i - 1;

                Integer x;
                if (0 <= index < numWords) {
                    if (negative) {
                        if (!nonZeroSeen) {
                            // negate the least significant non-zero word
                            x = getw(words, index).negated;
                            nonZeroSeen = x != 0;
                        }
                        else {
                            // flip the rest
                            x = getw(words, index).not;
                        }
                    }
                    else {
                        x = getw(words, index);
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
        =>  let (wordCount = sizew(words))
            if (wordCount > 0)
            then getw(words, wordCount - 1).even
            else false;

    "The platform-specific implementation object, if any.
     This is provided for interoperation with the runtime
     platform."
    see(`function fromImplementation`)
    // TODO remove once decimal allows
    shared Object? implementation => nothing;

    shared actual Integer hash {
        variable Integer result = 0;
        for (i in 0:sizew(words)) {
            result = result * 31 + getw(words, i);
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

    Boolean getBitPositive(Integer index) {
        value wSize = wordSize;
        value word = getw(words, sizew(words) - index / wSize - 1);
        value mask = 1.leftLogicalShift(index % wSize);
        return word.and(mask) != 0;
    }

    Boolean getBitNegative(Integer index) {
        if (index == 0) {
            return getw(words, sizew(words) - 1) != 0;
        }

        value wSize = wordSize;
        value zeros = leadingZeroWordCount;
        value wordNum = index / wSize;

        if (wordNum < zeros) {
            return false;
        }

        value word = let (rawWord = getw(words, sizew(words) - 1 - wordNum))
                     if (wordNum == zeros) then
                        rawWord.negated
                     else // wordNum > zeros
                        rawWord.not;

        value mask = 1.leftLogicalShift(index % wSize);
        return word.and(mask) != 0;
    }

    Integer leadingZeroWordCount =>
            if (leadingZeroWordCountMemo >= 0)
            then leadingZeroWordCountMemo
            else (leadingZeroWordCountMemo =
                   calculateLeadingZeroWordCount());

    Integer calculateLeadingZeroWordCount() {
        variable value result = 0;
        variable value i = sizew(words);
        while (--i >= 0) {
            if (getw(words, i) == 0) {
                result += 1;
            }
            else {
                break;
            }
        }
        return result;
    }

    Words add(Words first, Words second) {
        // Knuth 4.3.1 Algorithm A

        // assert(!first.empty && !second.empty);

        Words u;
        Words v;
        if (sizew(first) >= sizew(second)) {
            u = first;
            v = second;
        } else {
            u = second;
            v = first;
        }

        value wMask = wordMask;
        value wSize = wordSize;
        value r = wordsOfSize(sizew(u));

        // start from the last element (least-significant)
        variable value uIndex = sizew(u) - 1;
        variable value vIndex = sizew(v) - 1;
        variable value carry = 0;

        while (vIndex >= 0) {
            value sum =   getw(u, uIndex)
                        + getw(v, vIndex)
                        + carry;
            setw(r, uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wSize);
            uIndex -= 1;
            vIndex -= 1;
        }

        while (carry != 0 && uIndex >= 0) {
            value sum =   getw(u, uIndex)
                        + carry;
            setw(r, uIndex, sum.and(wMask));
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
        value r = wordsOfSize(sizew(u));

        // start from the last element (least-significant)
        variable value uIndex = sizew(u) - 1;
        variable value vIndex = sizew(v) - 1;
        variable value borrow = 0;

        while (vIndex >= 0) {
            value difference =   getw(u, uIndex)
                               - getw(v, vIndex)
                               + borrow;
            setw(r, uIndex, difference.and(wMask));
            borrow = difference.rightArithmeticShift(wSize);
            uIndex -= 1;
            vIndex -= 1;
        }

        while (borrow != 0 && uIndex >= 0) {
            value difference =   getw(u, uIndex)
                               + borrow;
            setw(r, uIndex, difference.and(wMask));
            borrow = difference.rightArithmeticShift(wSize);
            uIndex -= 1;
        }

        if (uIndex >= 0) {
            copyWords(u, r, 0, 0, uIndex + 1);
        }

        return r;
    }

    Words multiply(Words u, Words v) {
        value uSize = sizew(u);
        value vSize = sizew(v);

        if (uSize == 1) {
            return multiplyWord(v, getw(u, 0));
        }
        else if (vSize == 1) {
            return multiplyWord(u, getw(v, 0));
        }

        // Knuth 4.3.1 Algorithm M
        value wMask = wordMask;
        value wSize = wordSize;

        value rSize = uSize + vSize;
        value r = wordsOfSize(rSize);

        // result is all zeros the first time through
        variable value vIndex = vSize - 1;
        variable value carry = 0;
        value uLow = getw(u, uSize - 1);
        while (vIndex >= 0) {
            value rIndex = uSize + vIndex;
            value product =   uLow
                            * getw(v, vIndex)
                            + carry;
            setw(r, rIndex, product.and(wMask));
            carry = product.rightLogicalShift(wSize);
            vIndex -= 1;
        }
        setw(r, uSize + vIndex, carry);

        variable value uIndex = uSize - 2; // we already did the first one
        while (uIndex >= 0) {
            value uValue = getw(u, uIndex);
            carry = 0;
            vIndex = vSize - 1;
            while (vIndex >= 0) {
                value rIndex = uIndex + vIndex + 1;
                value product =   uValue
                                * getw(v, vIndex)
                                + getw(r, rIndex)
                                + carry;
                setw(r, rIndex, product.and(wMask));
                carry = product.rightLogicalShift(wSize);
                vIndex -= 1;
            }
            setw(r, uIndex + vIndex + 1, carry);
            uIndex -= 1;
        }
        return r;
    }

    Words multiplyWord(Words u, Integer v, Words r = wordsOfSize(sizew(u) + 1)) {
        value wMask = wordMask;
        value wSize = wordSize;

        // assert(v.and(wMask) == v);

        variable value carry = 0;
        variable value uIndex = sizew(u) - 1;
        variable value rIndex = sizew(r) - 1;

        while (uIndex >= 0) {
            value product =   getw(u, uIndex)
                            * v
                            + carry;
            setw(r, rIndex, product.and(wMask));
            carry = product.rightLogicalShift(wSize);
            uIndex -= 1;
            rIndex -= 1;
        }

        if (!carry.zero) {
            setw(r, rIndex, carry);
            rIndex -= 1;
        }

        while (rIndex >= 0) {
            setw(r, rIndex, 0);
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
        variable value uIndex = sizew(v) + j;
        variable value vIndex = sizew(v) - 1;

        while (vIndex >= 0) {
            // the product is subtracted, so absBorrow adds to it
            value product =   q
                            * getw(v, vIndex)
                            + absBorrow;

            value difference =   getw(u, uIndex)
                               - product.and(wMask);

            setw(u, uIndex, difference.and(wMask));

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
        variable value uIndex = sizew(v) + j;
        variable value vIndex = sizew(v) - 1;

        while (vIndex >= 0) {
            value sum =   getw(u, uIndex)
                        + getw(v, vIndex)
                        + carry;
            setw(u, uIndex, sum.and(wMask));
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
        if (sizew(divisor) < 2) {
            value first = getw(divisor, 0);
            return divideWord(dividend, first);
        }

        // Knuth 4.3.1 Algorithm D
        // assert(size(divisor) >= 2);

        value wMask = wordMask;
        value wSize = wordSize;

        // D1. Normalize (v's highest bit must be set)
        value m = sizew(dividend) - sizew(divisor);
        value b = wordRadix;
        value shift = wSize - 1 - highestNonZeroBit(getw(divisor, 0));
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
        Words q = wordsOfSize(m + 1); // quotient
        value v0 = getw(v, 0); // most significant, can't be 0
        value v1 = getw(v, 1); // second most significant must also exist

        // D2. Initialize j
        for (j in 0..m) {
            // D3. Compute qj
            value uj0 = getw(u, j);
            value uj1 = getw(u, j+1);
            value uj2 = getw(u, j+2);
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
                setw(u, j, 0);
                setw(q, j, qj);
            }
            // D7. Loop
        }

        // D8. Unnormalize Remainder Due to Step D1
        value remainder = if (shift == 0 || sizew(u) == 0)
                          then u
                          else rightShift(u, shift, 1);

        return [q, remainder];
    }

    [Words, Words] divideWord(Words u, Integer v) {
        value wMask = wordMask;
        value wSize = wordSize;

        value uSize = sizew(u);

        // assert(uSize >= 1);
        // assert(v.and(wMask) == v);

        value q = wordsOfSize(uSize);
        variable value r = 0;
        for (uIndex in 0:uSize) {
            value x = r.leftLogicalShift(wSize) + getw(u, uIndex);
            if (x >= 0) {
                setw(q, uIndex, x / v);
                r = x % v;
            } else {
                value qr = unsignedDivide(x, v);
                setw(q, uIndex, qr.rightLogicalShift(wSize));
                r = qr.and(wMask);
            }
        }
        return [q, if (r.zero)
                   then wordsOfSize(0)
                   else wordsOfOne(r)];
    }

    Words leftShift(Words u, Integer shift, Boolean alwaysPad = false) {
        assert (shift > 0);

        value wSize = wordSize;
        value wMask = wordMask;

        value uSize = sizew(u);
        value shiftBits = shift % wSize;
        value shiftWords = shift / wSize;

        Words r;

        if (shiftBits == 0) {
            value extraWord = if (alwaysPad) then 1 else 0;
            r = wordsOfSize(uSize + shiftWords + extraWord);
            copyWords(u, r, 0, extraWord);
        }
        else {
            value shiftBitsRight = wSize - shiftBits;
            value highWord = getw(u, 0).rightLogicalShift(shiftBitsRight);
            variable value rIndex = 0;
            if (alwaysPad || highWord != 0) {
                r = wordsOfSize(uSize + shiftWords + 1);
                setw(r, 0, highWord);
                rIndex += 1;
            }
            else {
                r = wordsOfSize(uSize + shiftWords);
            }
            variable value prev = getw(u, 0);
            for (i in 1:uSize-1) {
                value curr = getw(u, i);
                setw(r, rIndex, prev.leftLogicalShift(shiftBits)
                                   .or(curr.rightLogicalShift(shiftBitsRight))
                                   .and(wMask));
                prev = curr;
                rIndex += 1;
            }
            setw (r, rIndex, getw(u, uSize-1)
                             .leftLogicalShift(shiftBits)
                             .and(wMask));
        }
        return r;
    }

    function increment(Words w) {
        value wMask = wordMask;
        variable value last = 0;
        variable value uIndex = sizew(w);
        while (--uIndex >= 0 && last == 0) {
            last = (getw(w, uIndex) + 1).and(wMask);
            setw(w, uIndex, last);
        }

        if (last == 0) {
            value result = wordsOfSize(sizew(w) + 1);
            setw(result, 0, 1);
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
        value uSize = sizew(u);

        for (i in 1:shiftWords) {
            if (getw(u, uSize - i) != 0) {
                return true;
            }
        }

        return (shiftBits > 0) &&
                getw(u, uSize - shiftWords - 1)
                .leftLogicalShift(32 - shiftBits)
                .and(wMask) != 0;
    }

    Words rightShift(Words u, Integer shift, Integer sign) {
        assert (shift > 0);

        value wSize = wordSize;
        value wMask = wordMask;

        value uSize = sizew(u);
        value shiftBits = shift % wSize;
        value shiftWords = shift / wSize;

        Words r;

        if (shiftWords >= uSize) {
            return if (sign < 0) then wordsOfOne(1) else wordsOfSize(0);
        }

        if (shiftBits == 0) {
            value rSize = uSize - shiftWords;
            r = wordsOfSize(rSize);
            copyWords(u, r, 0, 0, rSize);
        }
        else {
            value highWord = getw(u, 0).rightLogicalShift(shiftBits);
            variable value rIndex = 0;
            if (highWord != 0) {
                r = wordsOfSize(uSize - shiftWords);
                setw(r, 0, highWord);
                rIndex += 1;
            }
            else {
                r = wordsOfSize(uSize - shiftWords - 1);
            }
            value shiftBitsLeft = wSize - shiftBits;
            variable value prev = getw(u, 0);
            for (i in 1:uSize - shiftWords - 1) {
                value curr = getw(u, i);
                setw(r, rIndex, prev.leftLogicalShift(shiftBitsLeft)
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

    Whole modPowerPositive(variable Whole base,
                           variable Whole exponent,
                           Whole modulus) {
        //assert(modulus.positive,
        //       exponent.positive,
        //       base.positive);

        // http://en.wikipedia.org/wiki/Modular_exponentiation
        // based on Applied Cryptography by Bruce Schneier
        variable value result = package.one;
        base = base % modulus; // TODO is this redundant?
        while (exponent > package.zero) {
            if (exponent % package.two == package.one) {
                result = (result * base) % modulus;
            }
            exponent = exponent.rightArithmeticShift(1);
            base = (base * base) % modulus;
        }
        return result;
    }

    Comparison compareMagnitude(Words x, Words y) {
        // leading words are most significant, but may be 0
        variable Integer xZeros = 0;
        variable Integer yZeros = 0;

        value xSize = sizew(x);
        value ySize = sizew(y);

        while (xZeros < xSize && getw(x, xZeros) == 0) {
            xZeros++;
        }

        while (yZeros < ySize && getw(y, yZeros) == 0) {
            yZeros++;
        }

        value xRealSize = xSize - xZeros;
        value yRealSize = ySize - yZeros;

        if (xRealSize != yRealSize) {
            return if (xRealSize < yRealSize) then smaller else larger;
        }
        else {
            for (i in 0:xRealSize) {
                value xi = getw(x, xZeros + i);
                value yi = getw(y, yZeros + i);
                if (xi != yi) {
                    return if (xi < yi) then smaller else larger;
                }
            }
            return equal;
        }
    }
}
