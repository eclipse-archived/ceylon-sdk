import ceylon.math.integer {
    largest,
    smallest
}
"An arbitrary precision integer."
shared final class Whole
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    Words words;

    Integer wordsSize;

    shared actual Integer sign;

    variable Integer trailingZeroWordsMemo = -1;

    variable Integer? integerMemo = null;

    variable String? stringMemo = null;

    function realSize(Words words, variable Integer maxSize) {
        variable value lastIndex =
                if (maxSize >= 0)
                then maxSize - 1
                else sizew(words) - 1;

        while (lastIndex >= 0, getw(words, lastIndex) == 0) {
            lastIndex--;
        }
        return lastIndex + 1;
    }

    shared new Internal(Integer sign, variable Words words, Integer maxSize = -1) {
        // FIXME should be package private when available
        // TODO shorten length of array if way oversized?
        // TODO zero out unused portion to avoid info leaks?

        // valid sign range
        assert (-1 <= sign <= 1);

        // sign must not be 0 if magnitude != 0
        this.wordsSize = realSize(words, maxSize);
        assert (!sign == 0 || this.wordsSize == 0);

        this.sign = if (this.wordsSize == 0) then 0 else sign;
        this.words = words;
    }

    shared Boolean get(Integer index) {
        if (index < 0) {
            return false;
        }
        else if (zero) {
            return false;
        }
        else if (index > wordBits * wordsSize) {
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
        =>  if (this.zero) then
                other
            else if (other.zero) then
                this
            else if (this.sign == other.sign) then
                Internal(this.sign,
                         add(this.wordsSize, this.words,
                             other.wordsSize, other.words))
            else
               (switch (compareMagnitude(this.wordsSize, this.words,
                                         other.wordsSize, other.words))
                case (equal)
                    package.zero
                case (larger)
                    Internal(this.sign,
                             subtract(this.wordsSize, this.words,
                                      other.wordsSize, other.words))
                case (smaller)
                    Internal(this.sign.negated,
                             subtract(other.wordsSize, other.words,
                                      this.wordsSize, this.words)));

    shared actual Whole minus(Whole other)
        =>  if (this.zero) then
                -other
            else if (other.zero) then
                this
            else if (this.sign != other.sign) then
                Internal(this.sign,
                         add(this.wordsSize, this.words,
                             other.wordsSize, other.words))
            else
               (switch (compareMagnitude(this.wordsSize, this.words,
                                         other.wordsSize, other.words))
                case (equal)
                    package.zero
                case (larger)
                    Internal(this.sign,
                             subtract(this.wordsSize, this.words,
                                      other.wordsSize, other.words))
                case (smaller)
                    Internal(this.sign.negated,
                             subtract(other.wordsSize, other.words,
                                      this.wordsSize, this.words)));

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
                Internal(this.sign * other.sign,
                         multiply(this.wordsSize, this.words,
                                  other.wordsSize, other.words));

    shared actual Whole timesInteger(Integer integer)
        =>  times(wholeNumber(integer));

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
            switch (compareMagnitude(this.wordsSize, this.words,
                                     other.wordsSize, other.words))
            case (equal)
                [if (sign == other.sign)
                    then package.one
                    else package.negativeOne,
                 package.zero]
            case (smaller)
                [package.zero, this]
            case (larger)
                (let (resultWords = divide(this.wordsSize, this.words,
                                           other.wordsSize, other.words))
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
                Whole.Internal(sign, rightShift(wordsSize, words, -shift, sign))
            else
                Whole.Internal(sign, leftShift(wordsSize, words, shift));

    shared Whole rightArithmeticShift(Integer shift)
        =>  if (shift == 0) then
                this
            else if (shift < 0) then
                Whole.Internal(sign, leftShift(wordsSize, words, -shift))
            else
                Whole.Internal(sign, rightShift(wordsSize, words, shift, sign));

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
            throw Exception("modulus must be positive");
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
        //assert (modulus > package.zero, this != package.zero);

        variable value base = this;

        if (exponent.negative) {
            base = modInverse(modulus);
        }
        else if (base.negative || base >= modulus) {
            base = base.mod(modulus);
        }

        return modPowerPositive(base, exponent.magnitude, modulus);
    }

    shared Whole modInverse(Whole modulus) {
        if (!modulus.positive) {
            throw Exception("modulus must be positive");
        }
        else if (this.even && modulus.even) {
            throw Exception("no inverse exists");
        }
        else if (modulus.unit) {
            return package.zero;
        }
        //assert (modulus > package.one);

        return let (inverse = modInversePositive(this.magnitude, modulus))
               if (this.negative)
               then modulus - inverse
               else inverse;
    }

    "The greatest common divisor."
    shared Whole gcd(Whole other) {
        if (this.zero) {
            return other.magnitude;
        }
        else if (other.zero) {
            return this.magnitude;
        }
        return gcdPositive(this.magnitude, other.magnitude);
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

            value wBits = wordBits;
            value wMask = wordMask;

            variable Integer result = 0;

            // result should have up to integerAddressableSize bits (32 or 64)
            value count = runtime.integerAddressableSize/wBits;

            variable value nonZeroSeen = false;

            // least significant first
            for (i in 0:count) {
                Integer x;
                if (i < wordsSize) {
                    if (negative) {
                        if (!nonZeroSeen) {
                            // negate the least significant non-zero word
                            x = getw(words, i).negated;
                            nonZeroSeen = x != 0;
                        }
                        else {
                            // flip the rest
                            x = getw(words, i).not;
                        }
                    }
                    else {
                        x = getw(words, i);
                    }
                }
                else {
                    x = if (negative) then -1 else 0;
                }
                value newBits = x.and(wMask).leftLogicalShift(i * wBits);
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
            else Internal(sign.negated, words); // TODO pass along memos

    shared actual Whole wholePart => this;

    shared actual Whole fractionalPart => package.zero;

    shared actual Boolean positive => sign == 1;

    shared actual Boolean negative => sign == -1;

    shared actual Boolean zero => sign == 0;

    shared actual Boolean unit => this == one;

    shared Boolean even => wordsSize > 0 && getw(words, 0).and(1) == 0;

    "The platform-specific implementation object, if any.
     This is provided for interoperation with the runtime
     platform."
    see(`function fromImplementation`)
    shared Object? implementation => nothing;

    shared actual Integer hash {
        variable Integer result = 0;
        for (i in 0:wordsSize) {
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
            value toRadix = package.ten;
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
                compareMagnitude(this.wordsSize, this.words,
                                 other.wordsSize, other.words)
            else
                compareMagnitude(other.wordsSize, other.words,
                                 this.wordsSize, this.words);

    shared actual Boolean equals(Object that)
        =>  if (is Whole that) then
                (this === that) ||
                (this.sign == that.sign &&
                 wordsEqual(this.wordsSize, this.words,
                            that.wordsSize, that.words))
            else
                false;

    Integer trailingZeroWords
        =>  if (trailingZeroWordsMemo >= 0)
            then trailingZeroWordsMemo
            else (trailingZeroWordsMemo =
                  calculateTrailingZeroWords());

    Integer trailingZeroBits
        =>  if (this.zero)
            then 0
            else (let (zeroWords = trailingZeroWords,
                       word = getw(words, zeroWords))
                  zeroWords * wordBits + numberOfTrailingZeros(word));

    Integer calculateTrailingZeroWords() {
        for (i in 0:wordsSize) {
            if (getw(words, i) != 0) {
                return i;
            }
        } else {
            assert(wordsSize == 0);
            return 0;
        }
    }

    Boolean getBitPositive(Integer index) {
        value wBits = wordBits;
        value word = getw(words, index / wBits);
        value mask = 1.leftLogicalShift(index % wBits);
        return word.and(mask) != 0;
    }

    Boolean getBitNegative(Integer index) {
        if (index == 0) {
            return getw(words, 0) != 0;
        }

        value wBits = wordBits;
        value zeros = trailingZeroWords;
        value wordNum = index / wBits;

        if (wordNum < zeros) {
            return false;
        }

        value word = let (rawWord = getw(words, wordNum))
                     if (wordNum == zeros)
                     then rawWord.negated // first non-zero word
                     else rawWord.not; // wordNum > zeros

        value mask = 1.leftLogicalShift(index % wBits);
        return word.and(mask) != 0;
    }

    Words add(Integer firstSize, Words first,
              Integer secondSize, Words second,
              Integer rSize = largest(firstSize, secondSize) + 1,
              Words r = wordsOfSize(rSize)) {

        // Knuth 4.3.1 Algorithm A
        //assert(firstSize > 0 && secondSize > 0);

        Words u;
        Words v;
        Integer uSize;
        Integer vSize;
        if (firstSize >= secondSize) {
            u = first;
            v = second;
            uSize = firstSize;
            vSize = secondSize;
        } else {
            u = second;
            v = first;
            uSize = secondSize;
            vSize = firstSize;
        }

        value wMask = wordMask;
        value wBits = wordBits;

        // start from the first element (least-significant)
        variable value i = 0;
        variable value carry = 0;

        while (i < vSize) {
            value sum =   getw(u, i)
                        + getw(v, i)
                        + carry;
            setw(r, i, sum.and(wMask));
            carry = sum.rightLogicalShift(wBits);
            i++;
        }

        while (i < uSize && carry != 0) {
            value sum =   getw(u, i)
                        + carry;
            setw(r, i, sum.and(wMask));
            carry = sum.rightLogicalShift(wBits);
            i++;
        }

        if (i < uSize) {
            copyWords(u, r, i, i, uSize - i);
            i = uSize;
        }

        if (carry != 0) {
            setw(r, i++, carry);
        }

        // zero out remaining words of provided array
        while (i < rSize) {
            setw(r, i++, 0);
        }

        return r;
    }

    Words subtract(Integer uSize, Words u,
                   Integer vSize, Words v,
                   Integer rSize = uSize,
                   Words r = wordsOfSize(rSize)) {

        // Knuth 4.3.1 Algorithm S
        //assert(compareMagnitude(u, v) == larger);

        value wMask = wordMask;
        value wBits = wordBits;

        // start from the first element (least-significant)
        variable value i = 0;
        variable value borrow = 0;

        while (i < vSize) {
            value difference =   getw(u, i)
                               - getw(v, i)
                               + borrow;
            setw(r, i, difference.and(wMask));
            borrow = difference.rightArithmeticShift(wBits);
            i++;
        }

        while (i < uSize && borrow != 0) {
            value difference =   getw(u, i)
                               + borrow;
            setw(r, i, difference.and(wMask));
            borrow = difference.rightArithmeticShift(wBits);
            i++;
        }

        if (i < uSize) {
            copyWords(u, r, i, i, uSize - i);
            i = uSize;
        }

        // zero out remaining words of provided array
        while (i < rSize) {
            setw(r, i++, 0);
        }

        return r;
    }

    Words multiply(Integer uSize, Words u,
                   Integer vSize, Words v,
                   Integer rSize = uSize + vSize,
                   Words r = wordsOfSize(rSize)) {

        if (uSize == 1) {
            return multiplyWord(vSize, v, getw(u, 0), rSize, r);
        }
        else if (vSize == 1) {
            return multiplyWord(uSize, u, getw(v, 0), rSize, r);
        }

        // Knuth 4.3.1 Algorithm M
        value wMask = wordMask;
        value wBits = wordBits;

        // result is all zeros the first time through
        variable value carry = 0;
        variable value vIndex = 0;
        value uLow = getw(u, 0);
        while (vIndex < vSize) {
            value product =   uLow
                            * getw(v, vIndex)
                            + carry;
            setw(r, vIndex, product.and(wMask));
            carry = product.rightLogicalShift(wBits);
            vIndex++;
        }
        setw(r, vSize, carry);

        // we already did the first one
        variable value uIndex = 1;
        while (uIndex < uSize) {
            value uValue = getw(u, uIndex);
            carry = 0;
            vIndex = 0;
            while (vIndex < vSize) {
                value rIndex = uIndex + vIndex;
                value product =   uValue
                                * getw(v, vIndex)
                                + getw(r, rIndex)
                                + carry;
                setw(r, rIndex, product.and(wMask));
                carry = product.rightLogicalShift(wBits);
                vIndex++;
            }
            setw(r, vSize + uIndex, carry);
            uIndex++;
        }

        // zero out remaining words of provided array
        for (i in (uSize + vSize):(rSize - uSize - vSize)) {
            setw(r, i, 0);
        }

        return r;
    }

    Words multiplyWord(Integer uSize, Words u, Integer v,
                       Integer rSize = uSize + 1,
                       Words r = wordsOfSize(rSize)) {

        value wMask = wordMask;
        value wBits = wordBits;

        //assert(v.and(wMask) == v);

        variable value carry = 0;
        variable value i = 0;
        while (i < uSize) {
            value product = getw(u, i) * v + carry;
            setw(r, i, product.and(wMask));
            carry = product.rightLogicalShift(wBits);
            i++;
        }

        if (!carry == 0) {
            setw(r, i, carry);
            i++;
        }

        while (i < rSize) {
            setw(r, i, 0);
            i++;
        }

        return r;
    }

    "`u[j-vsize..j-1] <- u[j-vsize..j-1] - v * q`, returning the absolute value
     of the final borrow that would normally be subtracted against u[j]."
    Integer multiplyAndSubtract(Words u, Integer vSize, Words v, Integer q, Integer j) {
        value wMask = wordMask;
        value wBits = wordBits;

        value offset = j - vSize;
        variable value borrow = 0;
        variable value vIndex = 0;
        while (vIndex < vSize) {
            value uIndex = vIndex + offset;
            value product = q * getw(v, vIndex);
            value difference =    getw(u, uIndex)
                                - product.and(wMask)
                                - borrow;
            setw(u, uIndex, difference.and(wMask));
            borrow =   product.rightLogicalShift(wBits)
                     - difference.rightArithmeticShift(wBits);
            vIndex++;
        }

        return borrow;
    }

    "`u[j-vSize..j-1] <- u[j-vSize..j-1] + v`, discarding the final carry."
    void addBack(Words u, Integer vSize, Words v, Integer j) {
        value wMask = wordMask;
        value wBits = wordBits;

        value offset = j - vSize;
        variable value carry = 0;
        variable value vIndex = 0;
        while (vIndex < vSize) {
            value uIndex = vIndex + offset;
            value sum =   getw(u, uIndex)
                        + getw(v, vIndex)
                        + carry;
            setw(u, uIndex, sum.and(wMask));
            carry = sum.rightLogicalShift(wBits);
            vIndex++;
        }
    }

    [Words, Words] divide(Integer dividendSize, Words dividend,
                          Integer divisorSize, Words divisor) {
        if (divisorSize < 2) {
            value first = getw(divisor, 0);
            return divideWord(dividendSize, dividend, first);
        }

        // Knuth 4.3.1 Algorithm D
        // assert(size(divisor) >= 2);

        value wMask = wordMask;
        value wBits = wordBits;

        // D1. Normalize (v's highest bit must be set)
        value m = dividendSize - divisorSize;
        value b = wordRadix;
        value shift = let (highWord = getw(divisor, divisorSize - 1),
                           highBit = unisignedHighestNonZeroBit(highWord))
                      wBits - 1 - highBit;
        Words u;
        Words v;
        Integer uSize = dividendSize + 1;
        Integer vSize = divisorSize;
        if (shift == 0) {
            // u must be longer than dividend by one word
            u = copyAppend(dividendSize, dividend, 0);
            v = divisor;
        }
        else {
            // u must be longer than dividend by one word
            u = leftShift(dividendSize, dividend, shift, true);
            v = leftShift(divisorSize, divisor, shift);
        }
        Words q = wordsOfSize(m + 1); // quotient
        value v0 = getw(v, vSize - 1); // most significant, can't be 0
        value v1 = getw(v, vSize - 2); // second most significant must exist

        // D2. Initialize j
        variable value j = uSize - 1;
        while (j >= vSize) {
            // D3. Compute qj
            value uj0 = getw(u, j);
            value uj1 = getw(u, j-1);
            value uj2 = getw(u, j-2);

            value uj01 = uj0.leftLogicalShift(wBits) + uj1;
            variable Integer qj;
            variable Integer rj;
            if (uj01 >= 0) {
                qj = uj01 / v0;
                rj = uj01 % v0;
            } else {
                value qrj = unsignedDivide(uj01, v0);
                qj = qrj.rightLogicalShift(wBits);
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
                value borrow = multiplyAndSubtract(u, vSize, v, qj, j);
                // D5. Test Remainder
                if (borrow != uj0) {
                    // D6. Add Back
                    // estimate for qj was too high
                    qj -= 1;
                    addBack(u, vSize, v, j);
                }
                setw(u, j, 0);
                setw(q, j - vSize, qj);
            }
            // D7. Loop
            j--;
        }

        // D8. Unnormalize Remainder Due to Step D1
        value remainder = if (shift == 0 || uSize == 0)
                          then u
                          else rightShift(uSize, u, shift, 1);

        return [q, remainder];
    }

    [Words, Words] divideWord(Integer uSize, Words u, Integer v) {
        value wMask = wordMask;
        value wBits = wordBits;

        // assert(uSize >= 1);
        // assert(v.and(wMask) == v);

        value q = wordsOfSize(uSize);
        variable value r = 0;
        variable value uIndex = uSize - 1;
        while (uIndex >= 0) {
            value x = r.leftLogicalShift(wBits) + getw(u, uIndex);
            if (x >= 0) {
                setw(q, uIndex, x / v);
                r = x % v;
            } else {
                value qr = unsignedDivide(x, v);
                setw(q, uIndex, qr.rightLogicalShift(wBits));
                r = qr.and(wMask);
            }
            uIndex--;
        }
        return [q, if (r.zero)
                   then wordsOfSize(0)
                   else wordsOfOne(r)];
    }

    Words leftShift(Integer uSize, Words u, Integer shift, Boolean alwaysPad = false) {
        assert (shift > 0);

        value wBits = wordBits;
        value wMask = wordMask;

        value shiftBits = shift % wBits;
        value shiftWords = shift / wBits;

        Words r;

        if (shiftBits == 0) {
            value extraWord = if (alwaysPad) then 1 else 0;
            r = wordsOfSize(uSize + shiftWords + extraWord);
            copyWords(u, r, 0, shiftWords);
        }
        else {
            value shiftBitsRight = wBits - shiftBits;
            value uHighWord = getw(u, uSize - 1);
            value rHighWord = uHighWord.rightLogicalShift(shiftBitsRight);
            if (alwaysPad || rHighWord != 0) {
                r = wordsOfSize(uSize + shiftWords + 1);
                setw(r, uSize + shiftWords, rHighWord);
            }
            else {
                r = wordsOfSize(uSize + shiftWords);
            }
            variable value prev = uHighWord;
            variable value uIndex = uSize - 2;
            while (uIndex >= 0) {
                value curr = getw(u, uIndex);
                value hPart = prev.leftLogicalShift(shiftBits).and(wMask);
                value lPart = curr.rightLogicalShift(shiftBitsRight);
                setw(r, uIndex + shiftWords + 1, hPart + lPart);
                prev = curr;
                uIndex--;
            }
            setw (r,
                  shiftWords,
                  getw(u, 0).leftLogicalShift(shiftBits).and(wMask));
        }
        return r;
    }

    // it is ok for w[size-1] to be 0
    function increment(Integer size, Words w) {
        value wMask = wordMask;
        variable value previous = 0;
        variable value i = -1;
        while (++i < size && previous == 0) {
            previous = (getw(w, i) + 1).and(wMask);
            setw(w, i, previous);
        }

        if (previous == 0) { // w was all ones
            value result = wordsOfSize(size + 1);
            setw(result, size, 1);
            return result;
        }
        else {
            return w;
        }
    }

    Boolean nonZeroBitsDropped(Words u,
                               Integer shiftWords,
                               Integer shiftBits) {
        variable value i = 0;
        while (i < shiftWords) {
            if (getw(u, i) != 0) {
                return true;
            }
            i++;
        }

        return (shiftBits > 0) &&
                getw(u, shiftWords)
                .leftLogicalShift(wordBits - shiftBits)
                .and(wordMask) != 0;
    }

    Words rightShift(Integer uSize, Words u, Integer shift, Integer sign) {
        assert (shift > 0);

        value wBits = wordBits;
        value wMask = wordMask;

        value shiftBits = shift % wBits;
        value shiftWords = shift / wBits;

        Words r;
        Integer rSize;

        if (shiftWords >= uSize) {
            return if (sign < 0) then wordsOfOne(1) else wordsOfSize(0);
        }

        if (shiftBits == 0) {
            rSize = uSize - shiftWords;
            r = wordsOfSize(rSize);
            copyWords(u, r, shiftWords, 0, rSize);
        }
        else {
            value uHighWord = getw(u, uSize - 1);
            value rHighWord = uHighWord.rightLogicalShift(shiftBits);
            if (rHighWord != 0) {
                rSize = uSize - shiftWords;
                r = wordsOfSize(rSize);
                setw(r, rSize - 1, rHighWord);
            }
            else {
                rSize = uSize - shiftWords - 1;
                r = wordsOfSize(rSize);
            }
            value shiftBitsLeft = wBits - shiftBits;

            variable value prev = uHighWord;
            variable value uIndex = uSize - 2;
            while (uIndex >= shiftWords) {
                value curr = getw(u, uIndex);
                value hPart = prev.leftLogicalShift(shiftBitsLeft).and(wMask);
                value lPart = curr.rightLogicalShift(shiftBits);
                setw(r, uIndex - shiftWords, hPart + lPart);
                prev = curr;
                uIndex--;
            }
        }

        // for negative numbers, if any one bits were lost,
        // add one to the magnitude to simulate two's
        // complement arithmetic right shift
        return
        if (sign < 0 &&
            nonZeroBitsDropped(u, shiftWords, shiftBits))
        then increment(rSize, r)
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
        base = base % modulus; // is this redundant?
        while (exponent > package.zero) {
            if (exponent % package.two == package.one) {
                result = (result * base) % modulus;
            }
            exponent = exponent.rightArithmeticShift(1);
            base = (base * base) % modulus;
        }
        return result;
    }

    Whole modInversePositive("base" Whole u, "modulus" Whole v) {
        // Knuth 4.5.2 Algorithm X
        // http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm

        variable value u1 = package.one;
        variable value u3 = u;

        variable value v1 = package.zero;
        variable value v3 = v;

        while (!v3.zero) {
            value q = u3 / v3;
            value t1 = u1 - v1 * q;
            value t3 = u3 - v3 * q;
            u1 = v1;
            u3 = v3;
            v1 = t1;
            v3 = t3;
        }

        if (!u3.unit) {
            throw Exception("no inverse exists");
        }

        return if (u1.negative)
               then v - u1
               else u1;
    }

    Whole gcdPositive(variable Whole u, variable Whole v) {
        // TODO: use inplace shift and subtraction for performance
        //assert (u.positive, !v.negative);

        // Knuth 4.5.2 Algorithm A
        // (Euclidean algorithm while u & v are very different in size)
        while (!v.zero && !(-2 < u.wordsSize - v.wordsSize < 2)) {
            // gcd(u, v) = gcd(v, u - qv)
            value r = u % v; // r will be >= 0
            u = v;
            v = r;
        }

        if (v.zero) {
            return u;
        }

        // Knuth 4.5.2 Algorithm B
        // (Binary method to find the gcd)
        value uZeroBits = u.trailingZeroBits;
        value vZeroBits = v.trailingZeroBits;

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

        while (!v.zero) {
            // TODO: optimize when both u and v are single word
            // u & v are both odd
            while (true) {
                // gcd(u, v) = gcd(u - v, v)
                u = u - v; // u will be even and >= 0
                // if u is even and v is odd, gcd(u, v) = gcd(u/2, v)
                u = u.rightArithmeticShift(u.trailingZeroBits);
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

    Comparison compareMagnitude(Integer xSize, Words x,
                                Integer ySize, Words y) {

        //assert(xSize == 0 || getw(x, xSize - 1) != 0);
        //assert(ySize == 0 || getw(y, ySize - 1) != 0);

        if (xSize != ySize) {
            return if (xSize < ySize)
            then smaller
            else larger;
        }
        else {
            variable value i = xSize;
            while (--i >= 0) {
                value xi = getw(x, i);
                value yi = getw(y, i);
                if (xi != yi) {
                    return if (xi < yi)
                    then smaller
                    else larger;
                }
            }
            return equal;
        }
    }
}
