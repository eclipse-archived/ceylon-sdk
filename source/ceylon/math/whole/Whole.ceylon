"An arbitrary precision integer."
shared final class Whole
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    // FIXME should be package private when available
    shared Words words;

    shared Integer wordsSize;

    shared actual Integer sign;

    variable Integer trailingZeroWordsMemo = -1;

    variable Integer? integerMemo = null;

    variable String? stringMemo = null;

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

    shared new CopyOfMutableWhole(MutableWhole mutableWhole) {
        this.sign = mutableWhole.sign;
        this.wordsSize = realSize(mutableWhole.words,
                                  mutableWhole.wordsSize);
        this.words = wordsOfSize(this.wordsSize);
        mutableWhole.words.copyTo(this.words, 0, 0, this.wordsSize);
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
            return getBitPositive(wordsSize, words, index);
        }
        else {
            return getBitNegative(wordsSize, words, index, trailingZeroWords);
        }
    }

    // TODO combine plus() and minus()
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
            // TODO other.unit & negativeOne
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
                (let (quotient = wordsOfSize(this.wordsSize),
                      remainder = divide<Nothing>
                                        (this.wordsSize, this.words,
                                         other.wordsSize, other.words,
                                         quotient))
                 [Internal(sign * other.sign, quotient),
                  Internal(sign, remainder)]));
    }

    shared actual Whole divided(Whole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            package.zero
        else if (other.unit) then
            this
        else if (other == package.negativeOne) then
            this.negated
        else (
            switch (compareMagnitude(this.wordsSize, this.words,
                                     other.wordsSize, other.words))
            case (equal)
                (if (sign == other.sign)
                 then package.one
                 else package.negativeOne)
            case (smaller)
                package.zero
            case (larger)
                (let (quotient = wordsOfSize(this.wordsSize),
                      remainder = divide<Null>
                                        (this.wordsSize, this.words,
                                         other.wordsSize, other.words,
                                         quotient))
                 Internal(sign * other.sign, quotient)));
    }

    shared actual Whole remainder(Whole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            package.zero
        else if (other.unit) then
            package.zero
        else if (other == package.negativeOne) then
            package.zero
        else (
            switch (compareMagnitude(this.wordsSize, this.words,
                                     other.wordsSize, other.words))
            case (equal)
                package.zero
            case (smaller)
                this
            case (larger)
                (let (remainder = divide<Nothing>
                                         (this.wordsSize, this.words,
                                         other.wordsSize, other.words))
                 Internal(sign, remainder)));
    }

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
            // FIXME pass wordsSize?
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

    Integer trailingZeros
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
}
