/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
by("John Vasileff")
final
class MutableWhole extends Object
        satisfies Integral<MutableWhole> &
                  Exponentiable<MutableWhole, MutableWhole> {

    variable Integer signValue;

    shared variable Words words;

    shared variable Integer wordsSize;

    shared
    new ofWords(Integer sign, Words words, Integer size = -1)
            extends Object() {
        assert (-1 <= sign <= 1);
        this.wordsSize = realSize(words, size);
        this.words = words;
        this.signValue = if (this.wordsSize == 0) then 0 else sign;
    }

    shared
    new copyOfWords(Integer sign, Words words, Integer size = -1)
            extends Object() {
        assert (-1 <= sign <= 1);
        this.wordsSize = realSize(words, size);
        this.words = words.clone();
        this.signValue = if (this.wordsSize == 0) then 0 else sign;
    }

    shared
    new copyOfWhole(Whole whole) extends Object() {
        assert (is WholeImpl whole);
        this.wordsSize = realSize(whole.words, whole.wordsSize);
        this.words = whole.words.clone();
        this.signValue = whole.sign;
    }

    shared actual
    MutableWhole plus(MutableWhole other)
        =>  addSigned(this, other, other.sign);

    shared actual
    MutableWhole minus(MutableWhole other)
        =>  addSigned(this, other, other.sign.negated);

    shared actual
    MutableWhole plusInteger(Integer integer)
        =>  plus(mutableWholeNumber(integer));

    shared actual
    MutableWhole times(MutableWhole other)
        =>  if (this.zero || other.zero) then
                mutableZero()
            else if (this.unit) then
                other.copy()
            else if (this.negativeOne) then
                other.negated
            else if (other.unit) then
                this.copy()
            else if (other.negativeOne) then
                this.negated
            else
                ofWords(this.sign * other.sign,
                        multiply(this.wordsSize, this.words,
                                 other.wordsSize, other.words));

    shared actual
    MutableWhole timesInteger(Integer integer)
        =>  if (zero || integer == 0) then
                mutableZero()
            else if (0 < integer < wordRadix) then
                ofWords(sign, multiplyWord(wordsSize, words, integer))
            else
                times(mutableWholeNumber(integer));

    shared actual
    MutableWhole divided(MutableWhole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            mutableZero()
        else if (other.unit) then
            copy()
        else if (other.negativeOne) then
            negated
        else (
            switch (compareMagnitude(
                        this.wordsSize, this.words,
                        other.wordsSize, other.words))
            case (equal)
                (if (sign == other.sign)
                 then mutableOne()
                 else mutableNegativeOne())
            case (smaller)
                mutableZero()
            case (larger)
                (let (quotient = wordsOfSize(this.wordsSize),
                      _ = divide(this.wordsSize, this.words,
                                 other.wordsSize, other.words,
                                 false, quotient))
                 ofWords(sign * other.sign, quotient)));
    }

    shared actual
    MutableWhole remainder(MutableWhole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        }
        return if (zero) then
            mutableZero()
        else if (other.absUnit) then
            mutableZero()
        else (
            switch (compareMagnitude(
                    this.wordsSize, this.words,
                    other.wordsSize, other.words))
            case (equal)
                mutableZero()
            case (smaller)
                copy()
            case (larger)
                (let (remainder = divide(this.wordsSize, this.words,
                                         other.wordsSize, other.words, true))
                 ofWords(sign, remainder)));
    }

    shared
    MutableWhole leftLogicalShift(Integer shift)
        =>  rightArithmeticShift(-shift);

    shared
    MutableWhole rightArithmeticShift(Integer shift)
        =>  if (shift == 0) then
                copy()
            else if (shift < 0) then
                ofWords(sign, leftShift(wordsSize, words, -shift))
            else
                ofWords(sign, rightShift(negative, wordsSize, words, shift));

    throws(`class Exception`, "If passed a negative exponent")
    throws(`class OverflowException`, "If passed an exponent > runtime.maxIntegerValue")
    shared actual
    MutableWhole power(MutableWhole exponent) {
        if (this.unit) {
            return copy();
        }
        else if (exponent.zero) {
            return package.mutableOne();
        }
        else if (this.negativeOne) {
            return if (exponent.even)
            then package.mutableOne()
            else copy();
        }
        else if (exponent.unit) {
            return copy();
        }
        else if (exponent.compareWhole(package.integerMax) == larger) {
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

    throws(`class Exception`, "If passed a negative exponent")
    throws(`class OverflowException`, "If passed an exponent > runtime.maxIntegerValue")
    shared actual
    MutableWhole powerOfInteger(Integer exponent) {
        if (this.unit) {
            return copy();
        }
        else if (exponent.zero) {
            return package.mutableOne();
        }
        else if (this.negativeOne) {
            return if (exponent.even)
            then package.mutableOne()
            else copy();
        }
        else if (exponent.unit) {
            return copy();
        }
        else if (exponent.positive) {
            return powerBySquaringInteger(exponent);
        }
        else {
            throw Exception(
                "``string``^``exponent`` negative exponents not supported");
        }
    }

    shared actual
    MutableWhole neighbour(Integer offset)
        => plusInteger(offset);

    shared actual
    Integer offset(MutableWhole other) {
        value diff = WholeImpl.copyOfMutableWhole(this - other);
        if (integerMin <= diff <= integerMax) {
            return diff.integer;
        }
        else {
            throw OverflowException();
        }
    }

    shared
    Integer integer
        => integerForWords(wordsSize, words, negative);

    shared actual
    MutableWhole negated
        =>  if (zero) then
                mutableZero()
            else if (unit) then
                mutableNegativeOne()
            else if (negativeOne) then
                mutableOne()
            else
                copyOfWords(sign.negated, words, wordsSize);

    shared
    MutableWhole copy() => copyOfWords(sign, words, wordsSize);

    shared
    Whole whole => WholeImpl.copyOfMutableWhole(this);

    shared actual
    MutableWhole wholePart => copy();

    shared actual
    MutableWhole fractionalPart => mutableZero();

    shared actual
    Boolean positive => sign == 1;

    shared actual
    Boolean negative => sign == -1;

    shared actual
    Boolean zero => sign == 0;

    Boolean absUnit => wordsSize == 1 && words.get(0) == 1;

    Boolean negativeOne => negative && absUnit;

    shared actual
    Boolean unit => positive && absUnit;

    shared
    Boolean even => wordsSize > 0 && words.get(0).and(1) == 0;

    shared actual
    Integer sign => signValue;

    shared actual
    Integer hash {
        variable Integer result = 0;
        for (i in 0:wordsSize) {
            result = result * 31 + words.get(i);
        }
        return sign * result;
    }

    shared actual
    String string
        =>  whole.string;

    shared actual
    Comparison compare(MutableWhole other)
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

    shared
    Comparison compareWhole(Whole other) {
        assert (is WholeImpl other);
        return  if (sign != other.sign) then
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

    shared actual
    Boolean equals(Object that)
        =>  if (is MutableWhole that) then
                (this.sign == that.sign &&
                 wordsEqual(this.wordsSize, this.words,
                            that.wordsSize, that.words))
            else
                false;

    shared
    void inPlaceLeftLogicalShift(Integer shift)
        =>  inPlaceRightArithmeticShift(-shift);

    shared
    void inPlaceRightArithmeticShift(Integer shift) {
        if (shift < 0) {
            words = leftShiftInPlace(wordsSize, words, -shift);
            wordsSize = realSize(words, -1);
        } else if (shift > 0) {
            words = rightShiftInPlace(
                        negative, wordsSize, words, shift);
            wordsSize = realSize(words, wordsSize);
            if (wordsSize == 0) {
                this.signValue = 0;
            }
        }
    }

    shared void inPlaceAdd(MutableWhole other)
        =>  inPlaceAddSigned(other, other.sign);

    shared void inPlaceSubtract(MutableWhole other)
        =>  inPlaceAddSigned(other, other.sign.negated);

    shared void inPlaceDecrement() {
        if (zero) {
            signValue = -1;
            words = successorInPlace(wordsSize, words);
            wordsSize = 1;
        }
        else if (negative) {
            words = successorInPlace(wordsSize, words);
            wordsSize = realSize(words, wordsSize + 1);
        }
        else {
            words = predecessorInPlace(wordsSize, words);
            wordsSize = realSize(words, wordsSize);
            if (wordsSize == 0) {
                signValue = 0;
            }
        }
    }

    shared
    void inPlaceIncrement() {
        if (zero) {
            signValue = 1;
            words = successorInPlace(wordsSize, words);
            wordsSize = 1;
        }
        else if (negative) {
            words = predecessorInPlace(wordsSize, words);
            wordsSize = realSize(words, wordsSize);
            if (wordsSize == 0) {
                signValue = 0;
            }
        }
        else {
            words = successorInPlace(wordsSize, words);
            wordsSize = realSize(words, wordsSize + 1);
        }
    }

    shared
    Integer trailingZeroWords {
        for (i in 0:wordsSize) {
            if (words.get(i) != 0) {
                return i;
            }
        } else {
            assert(wordsSize == 0);
            return 0;
        }
    }

    shared
    Integer trailingZeros
        =>  if (this.zero)
            then 0
            else (let (zeroWords = trailingZeroWords,
                       word = words.get(zeroWords))
                  zeroWords * wordBits + numberOfTrailingZeros(word));

    MutableWhole addSigned(MutableWhole first,
                           MutableWhole second,
                           Integer secondSign)
        =>  if (first.zero) then
                (if (secondSign == second.sign)
                 then second.copy()
                 else second.negated)
            else if (second.zero) then
                first.copy()
            else if (first.sign == secondSign) then
                ofWords(first.sign,
                        add(first.wordsSize, first.words,
                            second.wordsSize, second.words))
            else
                (switch (compareMagnitude(
                                first.wordsSize, first.words,
                                second.wordsSize, second.words))
                 case (equal)
                    mutableZero()
                 case (larger)
                    ofWords(first.sign,
                            subtract(first.wordsSize, first.words,
                                     second.wordsSize, second.words))
                 case (smaller)
                    ofWords(secondSign,
                            subtract(second.wordsSize, second.words,
                                     first.wordsSize, first.words)));

    void inPlaceAddSigned(MutableWhole other, Integer otherSign) {
        if (other.zero) {
            return;
        }
        else if (this.zero || this.sign == otherSign) {
            inPlaceAddUnsigned(other);
            this.signValue = otherSign;
        }
        else { // opposite signs
            switch (compareMagnitude(this.wordsSize, this.words,
                                     other.wordsSize, other.words))
            case (equal) {
                this.signValue = 0;
                while (wordsSize > 0) {
                    wordsSize--;
                    words.set(wordsSize, 0);
                }
            }
            case (larger) {
                subtract(this.wordsSize, this.words,
                         other.wordsSize, other.words,
                         this.wordsSize, this.words);
                wordsSize = realSize(words, wordsSize);
            }
            case (smaller) {
                if (words.size >= other.wordsSize) {
                    // inPlace can be done
                    subtract(other.wordsSize, other.words,
                             this.wordsSize, this.words,
                             this.wordsSize, this.words);
                    wordsSize = realSize(words, wordsSize);
                }
                else {
                    words = subtract(other.wordsSize, other.words,
                                     this.wordsSize, this.words);
                    wordsSize = realSize(words, -1);
                }
                this.signValue = this.sign.negated;
            }
        }
    }

    void inPlaceAddUnsigned(MutableWhole other) {
        // assert(!other.zero)

        Integer rSize =
                if (this.zero)
                    then other.wordsSize
                    else 1 + largest(this.wordsSize,
                                     other.wordsSize);

        if (words.size >= rSize) {
            add(this.wordsSize, this.words,
                other.wordsSize, other.words,
                rSize, this.words);
            wordsSize = realSize(words, rSize);
        }
        else {
            words = add(this.wordsSize, this.words,
                        other.wordsSize, other.words);
            wordsSize = realSize(words, -1);
        }
    }

    MutableWhole powerBySquaringInteger(variable Integer exponent) {
        variable value result = package.mutableOne();
        variable value x = this;
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

    shared
    Boolean safelyAddressable
        // slightly underestimate for performance
        =>  wordsSize < 2 ||
            (wordsSize == 2 &&
             words.get(1)
                 .rightLogicalShift(wordBits-1) == 0);
}
