import java.math {
    BigInteger
}
by("John Vasileff")
final class WholeImpl satisfies Whole {

    shared Words words;

    shared Integer wordsSize;

    shared actual Integer sign;

    variable Integer trailingZeroWordsMemo = -1;

    variable Integer bitLengthMemo = -1;

    variable Integer? integerMemo = null;

    variable String? stringMemo = null;

    shared new OfWords(Integer sign, Words words, Integer maxSize = -1) {
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
        this.wordsSize = mutableWhole.wordsSize;
        if (this.wordsSize == sizew(mutableWhole.words)) {
            this.words = clonew(mutableWhole.words);
        }
        else {
            this.words = wordsOfSize(this.wordsSize);
            copyWords(mutableWhole.words, this.words,
                      0, 0, this.wordsSize);
        }
    }

    "Create whole from [[words]] in two's complement notation. This constructor
     *does not* always make a defensive copy of [[words]], and is designed for
     internal use only."
    shared new OfBits(words) {
        "words in two's complement"
        variable Words words;

        if (sizew(words) == 0) {
            this.words = words;
            this.wordsSize = 0;
            this.sign = 0;
        }
        else {
            value negative = getw(words, sizew(words) - 1).get(wordBits - 1);
            if (!negative) {
                this.words = words;
                this.wordsSize = realSize(words, -1);
                this.sign = if (wordsSize == 0) then 0 else 1;
            }
            else {
                this.words = twosToUnsigned(sizew(words), words, words);
                this.wordsSize = realSize(words, -1);
                this.sign = -1;
            }
        }
    }

    shared actual Boolean get(Integer index)
        =>  if (index < 0 || zero) then
                false
            else if (index > wordBits * wordsSize) then
                // infinite ones in two's complement
                negative
            else if (positive) then
                getBitPositive(wordsSize, words, index)
            else
                getBitNegative(wordsSize, words, index,
                               trailingZeroWords);

    shared actual Whole set(Integer index, Boolean bit)
        =>  if (index < 0) then
                this
            else
                OfWords(if(zero) then 1 else sign,
                        setBit(wordsSize, words, bitLength,
                               negative then trailingZeroWords,
                               index, bit));

    shared actual Whole flip(Integer index)
        =>  if (index < 0) then
                this
            else
                OfWords(if(zero) then 1 else sign,
                        flipBit(wordsSize, words, bitLength,
                               negative then trailingZeroWords,
                               index));

    shared actual Whole plus(Whole other)
        =>  addSigned(this, other, other.sign);

    shared actual Whole minus(Whole other)
        =>  addSigned(this, other, other.sign.negated);

    shared actual Whole plusInteger(Integer integer)
        =>  plus(wholeNumber(integer));

    shared actual Whole times(Whole other) {
        assert (is WholeImpl other);
        return if (this.zero || other.zero) then
                package.zero
            else if (this.unit) then
                other
            else if (this.negativeOne) then
                other.negated
            else if (other.unit) then
                this
            else if (other.negativeOne) then
                this.negated
            else
                OfWords(this.sign * other.sign,
                        multiply(this.wordsSize, this.words,
                                 other.wordsSize, other.words));
    }

    shared actual Whole timesInteger(Integer integer)
        =>  if (zero || integer == 0) then
                package.zero
            else if (0 < integer < wordRadix) then
                OfWords(sign, multiplyWord(wordsSize, words, integer))
            else
                times(wholeNumber(integer));

    shared actual [Whole, Whole] quotientAndRemainder(Whole other) {
        assert(is WholeImpl other);
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            [package.zero, package.zero]
        else if (other.unit) then
            [this, package.zero]
        else if (other.negativeOne) then
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
                 [OfWords(sign * other.sign, quotient),
                  OfWords(sign, remainder)]));
    }

    shared actual Whole divided(Whole other) {
        assert(is WholeImpl other);
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            package.zero
        else if (other.unit) then
            this
        else if (other.negativeOne) then
            this.negated
        else (
            switch (compareMagnitude(
                        this.wordsSize, this.words,
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
                 OfWords(sign * other.sign, quotient)));
    }

    shared actual Whole remainder(Whole other) {
        assert(is WholeImpl other);
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            package.zero
        else if (other.unit) then
            package.zero
        else if (other.absUnit) then
            package.zero
        else (
            switch (compareMagnitude(
                        this.wordsSize, this.words,
                        other.wordsSize, other.words))
            case (equal)
                package.zero
            case (smaller)
                this
            case (larger)
                (let (remainder = divide<Nothing>
                                         (this.wordsSize, this.words,
                                         other.wordsSize, other.words))
                 OfWords(sign, remainder)));
    }

    shared actual Whole leftLogicalShift(Integer shift)
        =>  rightArithmeticShift(-shift);

    shared actual Whole rightArithmeticShift(Integer shift)
        =>  if (shift == 0) then
                this
            else if (shift < 0) then
                WholeImpl.OfWords(sign, leftShift(wordsSize, words, -shift))
            else
                WholeImpl.OfWords(sign, rightShift(negative, wordsSize, words, shift));

    shared actual Whole and(Whole other)
        =>  logicOperation(this, other, Integer.and);

    shared actual Whole or(Whole other)
        =>  logicOperation(this, other, Integer.or);

    shared actual Whole xor(Whole other)
        =>  logicOperation(this, other, Integer.xor);

    shared actual Whole power(Whole exponent) {
        assert (is WholeImpl exponent);
        if (this.unit) {
            return this;
        }
        else if (exponent.zero) {
            return package.one;
        }
        else if (this.negativeOne) {
            return if (exponent.even)
            then package.one
            else this;
        }
        else if (exponent.unit) {
            return this;
        }
        else if (exponent > package.integerMax) {
            throw OverflowException(
                "Exponent ``exponent`` > runtime.maxIntegerValue.");
        }
        else if (exponent.positive) {
            return powerBySquaringInteger(
                integerForWordsNaive(exponent.wordsSize,
                                     exponent.words));
        }
        else {
            throw Exception(
                "``string``^``exponent`` negative exponents not supported");
        }
    }

    shared actual Whole powerOfInteger(Integer exponent) {
        if (this.unit) {
            return this;
        }
        else if (exponent.zero) {
            return package.one;
        }
        else if (this.negativeOne) {
            return if (exponent.even)
            then package.one
            else this;
        }
        else if (exponent.unit) {
            return this;
        }
        else if (exponent.positive) {
            return powerBySquaringInteger(exponent);
        }
        else {
            throw Exception(
                "``string``^``exponent`` negative exponents not supported");
        }
    }

    shared actual Whole mod(Whole modulus) {
        if (!modulus.positive) {
            throw AssertionError("modulus must be positive");
        }
        return let (result = remainder(modulus))
               if (result.negative)
               then result + modulus
               else result;
    }

    shared actual Whole modPower(Whole exponent,
                                 Whole modulus) {
        if (!modulus.positive) {
            throw Exception("Modulus must be positive.");
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

        variable Whole base = this;

        if (exponent.negative) {
            base = modInverse(modulus);
        }
        else if (base.negative || base >= modulus) {
            base = base.mod(modulus);
        }

        return modPowerPositive(base, exponent.magnitude, modulus);
    }

    shared actual Whole modInverse(Whole modulus) {
        if (!modulus.positive) {
            throw Exception("Modulus must be positive.");
        }
        else if (this.even && modulus.even) {
            throw Exception("No inverse exists.");
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
    shared actual Integer integer
        =>  integerMemo else (integerMemo =
                integerForWords(wordsSize, words, negative));

    shared actual Float float {
        if (zero) {
            return 0.0;
        }
        else if (wordsSize == 1 ||
                 bitLengthUnsigned <= 53) {
            value abs = integerForWordsNaive(wordsSize, words).float;
            return if (negative)
                   then -abs
                   else abs;
        }
        else {
            throw OverflowException(
                "The value ``string`` cannot be represented " +
                "as a Float without loss of precision.");
        }
    }

    shared actual Whole not
        =>  if (zero) then
                package.negativeOne
            else if (negativeOne) then
                package.zero
            else if (positive) then
                // add one, flip sign
                OfWords(-1, package.successor(wordsSize, words))
            else
                // subtract one, flip sign
                OfWords(1, package.predecessor(wordsSize, words));

    shared actual Whole negated
        =>  if (zero) then
                package.zero
            else if (this.unit) then
                package.negativeOne
            else if (this.negativeOne) then
                package.one
            else OfWords(sign.negated, words, wordsSize);

    shared actual Whole wholePart => this;

    shared actual Whole fractionalPart => package.zero;

    shared actual Boolean positive => sign == 1;

    shared actual Boolean negative => sign == -1;

    shared actual Boolean zero => sign == 0;

    Boolean absUnit => wordsSize == 1 && getw(words, 0) == 1;

    Boolean negativeOne => negative && absUnit;

    shared actual Boolean unit => positive && absUnit;

    shared actual Boolean even => wordsSize > 0 && getw(words, 0).and(1) == 0;

    "The platform-specific implementation object, if any.
     This is provided for interoperation with the runtime
     platform."
    see(`function fromImplementation`)
    shared actual Object? implementation {
        if (safelyAddressable) {
            return BigInteger.valueOf(integer);
        }
        else {
            return BigInteger(string);
        }
    }

    shared actual Integer hash {
        variable Integer result = 0;
        for (i in 0:wordsSize) {
            result = result * 31 + getw(words, i);
        }
        return sign * result;
    }

    shared actual String string
        =>  if (exists memo = stringMemo)
            then memo
            else (stringMemo = formatWhole(this));

    shared actual Comparison compare(Whole other) {
        assert (is WholeImpl other);
        return if (sign != other.sign) then
                sign.compare(other.sign)
            else if (zero) then
                equal
            else if (positive) then
                compareMagnitude(this.wordsSize, this.words,
                                 other.wordsSize, other.words)
            else
                compareMagnitude(other.wordsSize, other.words,
                                 this.wordsSize, this.words);
    }

    shared actual Boolean equals(Object that)
        =>  if (is WholeImpl that) then
                (this.sign == that.sign &&
                 wordsEqual(this.wordsSize, this.words,
                            that.wordsSize, that.words))
            else
                false;

    //Integer trailingZeros
    //    =>  if (this.zero)
    //        then 0
    //        else (let (zeroWords = trailingZeroWords,
    //                   word = getw(words, zeroWords))
    //              zeroWords * wordBits + numberOfTrailingZeros(word));

    Integer trailingZeroWords
        =>  if (trailingZeroWordsMemo >= 0)
            then trailingZeroWordsMemo
            else (trailingZeroWordsMemo =
                  calculateTrailingZeroWords());

    "Minimal length to represent this Whole in two's complement, excluding a sign bit."
    Integer bitLength
        =>  if (bitLengthMemo >= 0)
            then bitLengthMemo
            else (bitLengthMemo = calculateBitLength(
                wordsSize, words, negative then trailingZeroWords));

    "Minimal length to represent the magnitude of this Whole, excluding a sign bit."
    Integer bitLengthUnsigned
        =>  if (negative)
            then calculateBitLength(wordsSize, words, null)
            else bitLength;

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

    Whole addSigned(Whole first, Whole second, Integer secondSign) {
        assert (is WholeImpl first, is WholeImpl second);
        return if (first.zero) then
                (if (second.sign == secondSign)
                 then second
                 else second.negated)
            else if (second.zero) then
                first
            else if (first.sign == secondSign) then
                OfWords(first.sign,
                         add(first.wordsSize, first.words,
                             second.wordsSize, second.words))
            else
               (switch (compareMagnitude(
                            first.wordsSize, first.words,
                            second.wordsSize, second.words))
                case (equal)
                    package.zero
                case (larger)
                    OfWords(first.sign,
                            subtract(first.wordsSize, first.words,
                                     second.wordsSize, second.words))
                case (smaller)
                    OfWords(secondSign,
                            subtract(second.wordsSize, second.words,
                                     first.wordsSize, first.words)));
    }

    Whole logicOperation(Whole first, Whole second, Integer(Integer)(Integer) op) {
        assert (is WholeImpl first, is WholeImpl second);
        value bits = package.logicOperation(
            first.wordsSize, first.words, first.bitLength,
            first.negative then first.trailingZeroWords,
            second.wordsSize, second.words, second.bitLength,
            second.negative then second.trailingZeroWords,
            op);
        return OfBits(bits);
    }

    Whole powerBySquaringInteger(variable Integer exponent) {
        variable Whole result = package.one;
        variable Whole x = this;
        while (!exponent.zero) {
            if (!exponent.even) {
                result *= x;
                exponent--;
            }
            x *= x;
            exponent = exponent.rightArithmeticShift(1);
        }
        return result;
    }

    Whole modPowerPositive(variable Whole base,
                           Whole exponent,
                           Whole modulus) {
        //assert(modulus.positive,
        //       exponent.positive,
        //       base.positive);

        // http://en.wikipedia.org/wiki/Modular_exponentiation
        // based on Applied Cryptography by Bruce Schneier
        value exp = MutableWhole.CopyOfWhole(exponent);
        variable value result = package.one;
        base = base % modulus; // is this redundant?
        while (!exp.zero) {
            if (!exp.even) {
                result = (result * base) % modulus;
            }
            exp.inplaceRightArithmeticShift(1);
            base = (base * base) % modulus;
        }
        return result;
    }

    Whole modInversePositive("base" Whole u, "modulus" Whole v) {
        // Knuth 4.5.2 Algorithm X
        // http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm

        // TODO speed things up with MutableWhole, which should be enhanced
        // to have inPlaceDividedAndRemainder, among others
        variable value u1 = package.one;
        variable value u3 = u;

        variable value v1 = package.zero;
        variable value v3 = v;

        while (!v3.zero) {
            value [q, t3] = u3.quotientAndRemainder(v3);
            value t1 = u1 - v1 * q;
            u1 = v1;
            u3 = v3;
            v1 = t1;
            v3 = t3;
        }

        if (!u3.unit) {
            throw Exception("No inverse exists.");
        }

        return if (u1.negative)
               then u1 + v
               else u1;
    }

    shared Boolean safelyAddressable
        // slightly underestimate for performance
        =>  wordsSize < 2 ||
            (wordsSize == 2 &&
             getw(words, 1)
                 .rightLogicalShift(wordBits-1) == 0);

}
