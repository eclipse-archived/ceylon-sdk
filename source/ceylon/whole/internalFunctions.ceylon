/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Returns the actual number words contained in [[words]], up to [[maxSize]].
 Given that words are stored in little-endian order, trailing zero words
 do not contribute to the numeric value of [[words]]. It is presumed that
 all words at index [[maxSize]] and beyond are zero."
Integer realSize(words, maxSize) {

    "The words, in unsigned notation."
    Words words;

    "The maximum size to return; may be greater than size(words),
     or `-1` to indicate no maximum."
    variable Integer maxSize;

    variable value lastIndex =
            if (maxSize >= 0)
            then smallest(words.size, maxSize) - 1
            else words.size - 1;

    while (lastIndex >= 0, words.get(lastIndex) == 0) {
        lastIndex--;
    }
    return lastIndex + 1;
}

"Minimal length necessary to represent words in two's complement,
 excluding a sign bit. The passed in value is considered to be
 positive if [[trailingZeroWords]] is null, and negative otherwise."
Integer calculateBitLength(wordsSize, words, trailingZeroWords) {

    "The number of words contained in the cooresponding words argument.
     If greater than zero, `words[wordsSize-1]` must be non-zero."
    Integer wordsSize;

    "The words, in unsigned notation, to be converted to two's complement
     using the sign indicated by [[trailingZeroWords]]."
    Words words;

    "Indicates that [[words]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? trailingZeroWords;

    if (wordsSize == 0) {
        return 0;
    }
    variable Integer length;
    value highWord = words.get(wordsSize - 1);
    length = (wordsSize - 1) * wordBits;
    if (exists trailingZeroWords, wordsSize - 1 == trailingZeroWords) {
        // one bit shorter for negative numbers that are
        // an exact power of two
        length += unsignedHighestNonZeroBit(highWord - 1) + 1;
    }
    else {
        length += unsignedHighestNonZeroBit(highWord) + 1;
    }
    return length;
}

"Perform a bitwise operation, such as AND, on the given [[Words]],
 returning either [[rWords]] for the result if provided and of
 sufficient size, or a new [[Words]] object. *Note:* the result
 will be in two's complement notation."
Words logicOperation(
        Integer firstSize, Words firstWords,
        firstBitLength, firstTrailingZeroWords,
        Integer secondSize, Words secondWords,
        secondBitLength, secondTrailingZeroWords,
        Integer(Integer)(Integer) op, rWords = null) {

    "The pre-calculated number of bits required to represent [[firstWords]]
     in two's complement, excluding a sign bit, with the sign
     indicated by [[firstTrailingZeroWords]]."
    Integer firstBitLength;

    "Indicates that [[firstWords]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? firstTrailingZeroWords;

    "The pre-calculated number of bits required to represent [[secondWords]]
     in two's complement, excluding a sign bit, with the sign
     indicated by [[secondTrailingZeroWords]]."
    Integer secondBitLength;

    "Indicates that [[secondWords]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? secondTrailingZeroWords;

    "Storage for the result, if large enough. It *is* permissible
     for [[rWords]] to be the same instance as [[firstWords]]
     or [[secondWords]]. The sign bit will be extended to fill the
     entirety of [[rWords]]."
    Words? rWords;

    // must be large enough for at least 1 sign bit
    value count = largest(firstBitLength / wordBits + 1,
                          secondBitLength / wordBits + 1);

    Words result = if (exists rWords, rWords.size >= count)
                   then rWords
                   else wordsOfSize(count);

    for (i in 0:result.size) {
        // iterate all elements of the result in order to fully
        // extend the sign bit
        value a = getWordInTwos(firstSize, firstWords, i, firstTrailingZeroWords);
        value b = getWordInTwos(secondSize, secondWords, i, secondTrailingZeroWords);
        result.set(i, op(a)(b));
    }
    return result;
}

"Sets the bit as specified, returning either [[rWords]] for the result
 if provided and of sufficient size, or a new [[Words]] object. *Note:*
 the result will be in unsigned notation notation; the caller is responsible
 for determining the sign of the result based on the input value."
Words setBit(Integer wordsSize, Words words,
          wordsBitLength, trailingZeroWords,
          Integer index, Boolean bit, rWords = null) {

    "The pre-calculated number of bits required to represent [[words]]
     in two's complement, excluding a sign bit, with the sign
     indicated by [[trailingZeroWords]]."
    Integer wordsBitLength;

    "Indicates that [[words]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? trailingZeroWords;

    "Storage for the result, if large enough. It *is* permissible
     for [[rWords]] to be the same instance as [[words]].
     Unused portions of [[rWords]] will be filled with zeros."
    Words? rWords;

    value newLength = largest(wordsBitLength / wordBits + 1,
                              (index + 1) / wordBits + 1);

    value result = if (exists rWords, rWords.size >= newLength)
                   then rWords
                   else wordsOfSize(newLength);

    // copy into the result, translating to two's complement
    for (rIndex in 0:result.size) {
        result.set(rIndex, getWordInTwos(wordsSize, words, rIndex, trailingZeroWords));
    }

    // set the bit
    value wordNum = index / wordBits;
    value bitNum = index % wordBits;
    result.set(wordNum, result.get(wordNum).set(bitNum, bit));

    // convert to unsigned and return
    return if (exists trailingZeroWords) // if negative
           then twosToUnsigned(result, result)
           else result;
}

"Flips the bit as specified, returning either [[rWords]] for the result
 if provided and of sufficient size, or a new [[Words]] object. *Note:*
 the result will be in unsigned notation notation; the caller is responsible
 for determining the sign of the result based on the input value."
Words flipBit(Integer wordsSize, Words words,
          wordsBitLength, trailingZeroWords,
          Integer index, rWords = null) {

    "The pre-calculated number of bits required to represent [[words]]
     in two's complement, excluding a sign bit, with the sign
     indicated by [[trailingZeroWords]]."
    Integer wordsBitLength;

    "Indicates that [[words]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? trailingZeroWords;

    "Storage for the result, if large enough. It *is* permissible
     for [[rWords]] to be the same instance as [[words]].
     Unused portions of [[rWords]] will be filled with zeros."
    Words? rWords;

    value newLength = largest(wordsBitLength / wordBits + 1,
                              (index + 1) / wordBits + 1);

    value result = if (exists rWords, rWords.size >= newLength)
                   then rWords
                   else wordsOfSize(newLength);

    // copy into the result, translating to two's complement
    for (rIndex in 0:result.size) {
        result.set(rIndex, getWordInTwos(wordsSize, words, rIndex, trailingZeroWords));
    }

    // flip the bit
    value wordNum = index / wordBits;
    value bitNum = index % wordBits;
    result.set(wordNum, result.get(wordNum).flip(bitNum));

    // convert to unsigned and return
    return if (exists trailingZeroWords) // if negative
           then twosToUnsigned(result, result)
           else result;
}

"Return the value of [[words]] at [[wordIndex]], after converting to two's
 complement notation. [[wordIndex]] may be larger than the last index of
 [[words]]; the sign bit is used to logically extend the value to
 infinite length."
Integer getWordInTwos(

    "The number of words in [[words]]."
    Integer wordsSize,

    "The words, in unsigned notation, to be converted to two's complement
     using the sign indicated by [[trailingZeroWords]]."
    Words words,

    "The index of the desired word."
    Integer wordIndex,

    "Indicates that [[words]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? trailingZeroWords)

    =>  if (exists trailingZeroWords)
        then getWordInTwosNegative(wordsSize, words, wordIndex, trailingZeroWords)
        else getWordInTwosPositive(wordsSize, words, wordIndex);

see(`function getWordInTwos`)
Integer getWordInTwosPositive(Integer wordsSize, Words words, Integer wordIndex)
    =>  if (!(0 <= wordIndex < wordsSize))
        then 0
        else words.get(wordIndex);

see(`function getWordInTwos`)
Integer getWordInTwosNegative(Integer wordsSize, Words words, Integer wordIndex,
                              Integer trailingZeroWords)
    =>  let (wMask = wordMask)
        if (wordIndex < trailingZeroWords) then
            0
        else if (wordIndex >= wordsSize) then
            wMask
        else
           let (rawWord = words.get(wordIndex))
           if (wordIndex == trailingZeroWords)
           then rawWord.negated.and(wMask) // first non-zero word
           else rawWord.not.and(wMask); // wordNum > zeros

"Return the value of the bit of [[words]] at [[index]], after converting
 to two's complement notation. [[index]] may be larger than the number of
 bits contained in [[words]]; the sign bit is used to logically extend the
 value to infinite length."
Boolean getBit(

    "The number of words in [[words]]."
    Integer wordsSize,

    "The words, in unsigned notation, to be converted to two's complement
     using the sign indicated by [[trailingZeroWords]]."
    Words words,

    "The index of the desired bit."
    Integer index,

    "Indicates that [[words]] should be interpreted as a positive
     number if null; otherwise, the pre-calculated number of trailing
     (least significant) zero words."
    Integer? trailingZeroWords)

    =>  if (exists trailingZeroWords)
        then getBitNegative(wordsSize, words, index, trailingZeroWords)
        else getBitPositive(wordsSize, words, index);

see(`function getBit`)
Boolean getBitPositive(Integer wordsSize, Words words, Integer index)
    =>  let (wBits = wordBits,
             word = getWordInTwosPositive(wordsSize, words, index / wBits),
             mask = 1.leftLogicalShift(index % wBits))
        word.and(mask) != 0;

see(`function getBit`)
Boolean getBitNegative(Integer wordsSize, Words words, Integer index,
                       Integer trailingZeroWords)
    =>  if (index == 0) then
            words.get(0).get(0)
        else
            let (wBits = wordBits,
                 mask = 1.leftLogicalShift(index % wBits),
                 word = getWordInTwosNegative(
                            wordsSize,
                            words,
                            index / wBits,
                            trailingZeroWords))
            word.and(mask) != 0;

"Returns the result of adding [[first]] to [[second]]. All values are unsigned.
 [[firstSize]] and [[secondSize]] must both be greater then 0, although it may
 make sense to drop this restriction."
Words add(Integer firstSize, Words first,
          Integer secondSize, Words second,
          rSize = largest(firstSize, secondSize) + 1,
          r = wordsOfSize(rSize)) {

    "The currently occupied size of [[r]], if provided."
    Integer rSize;

    "The result object, which *may* be the same as [[first]] or [[second]].
     If provided, this object must be large enough to hold the result;
     that is, at least `firstSize + secondSize` words, plus an additional word
     for the carry, if necessary. This method will zero-out unused portions
     of [[r]] up to the index `rSize - 1`."
    Words r;

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
        value sum =   u.get(i)
                    + v.get(i)
                    + carry;
        r.set(i, sum.and(wMask));
        carry = sum.rightLogicalShift(wBits);
        i++;
    }

    while (i < uSize && carry != 0) {
        value sum =   u.get(i)
                    + carry;
        r.set(i, sum.and(wMask));
        carry = sum.rightLogicalShift(wBits);
        i++;
    }

    if (i < uSize) {
        if (!(u === r)) {
            u.copyTo(r, i, i, uSize - i);
        }
        i = uSize;
    }

    if (carry != 0) {
        r.set(i++, carry);
    }

    // zero out remaining words of provided array
    while (i < rSize) {
        r.set(i++, 0);
    }

    return r;
}

"Returns the result of subtracting [[v]] from [[u]]. All values are unsigned.
 [[u]] *must* be greater than or equal to [[v]], ensuring a non-negative
 result."
Words subtract(Integer uSize, Words u,
               Integer vSize, Words v,
               rSize = uSize,
               r = wordsOfSize(rSize)) {

    "The currently occupied size of [[r]], if provided."
    Integer rSize;

    "The result object, which *may* be the same as [[u]] or [[v]].
     If provided, this object must be large enough to hold the result;
     that is, at least `uSize` words. This method will zero-out unused
     portions of [[r]] up to the index `rSize - 1`."
    Words r;

    // Knuth 4.3.1 Algorithm S
    //assert(compareMagnitude(u, v) == larger);

    value wMask = wordMask;
    value wBits = wordBits;

    // start from the first element (least-significant)
    variable value i = 0;
    variable value borrow = 0;

    // subtract v from u
    while (i < vSize) {
        value difference =   u.get(i)
                           - v.get(i)
                           + borrow;
        r.set(i, difference.and(wMask));
        borrow = difference.rightArithmeticShift(wBits);
        i++;
    }

    // continue unit there is no borrow
    while (i < uSize && borrow != 0) {
        value difference =   u.get(i)
                           + borrow;
        r.set(i, difference.and(wMask));
        borrow = difference.rightArithmeticShift(wBits);
        i++;
    }

    // simply copy any remaining words from u
    if (i < uSize) {
        if (!(u === r)) {
            u.copyTo(r, i, i, uSize - i);
        }
        i = uSize;
    }

    // zero out remaining words of provided array
    while (i < rSize) {
        r.set(i++, 0);
    }

    return r;
}

"Returns the product of [[u]] and [[v]]. All values are unsigned."
Words multiply(Integer uSize, Words u,
               Integer vSize, Words v,
               rSize = uSize + vSize,
               r = wordsOfSize(rSize)) {

    "The currently occupied size of [[r]], if provided."
    Integer rSize;

    "The result object, which *may not* be the same as [[u]] or [[v]].
     If provided, this object must be large enough to hold the result;
     that is, at least `uSize + vSize` words. This method will zero-out
     unused portions of [[r]] up to the index `rSize - 1`."
    Words r;

    if (uSize == 1) {
        return multiplyWord(vSize, v, u.get(0), rSize, r);
    }
    else if (vSize == 1) {
        return multiplyWord(uSize, u, v.get(0), rSize, r);
    }

    // Knuth 4.3.1 Algorithm M
    value wMask = wordMask;
    value wBits = wordBits;

    // result is all zeros the first time through
    variable value carry = 0;
    variable value vIndex = 0;
    value uLow = u.get(0);
    while (vIndex < vSize) {
        value product =   uLow
                        * v.get(vIndex)
                        + carry;
        r.set(vIndex, product.and(wMask));
        carry = product.rightLogicalShift(wBits);
        vIndex++;
    }
    r.set(vSize, carry);

    // we already did the first one
    variable value uIndex = 1;
    while (uIndex < uSize) {
        value uValue = u.get(uIndex);
        carry = 0;
        vIndex = 0;
        while (vIndex < vSize) {
            value rIndex = uIndex + vIndex;
            value product =   uValue
                            * v.get(vIndex)
                            + r.get(rIndex)
                            + carry;
            r.set(rIndex, product.and(wMask));
            carry = product.rightLogicalShift(wBits);
            vIndex++;
        }
        r.set(vSize + uIndex, carry);
        uIndex++;
    }

    // zero out remaining words of provided array
    for (i in (uSize + vSize):(rSize - uSize - vSize)) {
        r.set(i, 0);
    }

    return r;
}

"Returns the product of [[u]] and [[v]]. All values are unsigned."
Words multiplyWord(Integer uSize, Words u, Integer v,
                   rSize = uSize + 1,
                   r = wordsOfSize(rSize)) {

    "The currently occupied size of [[r]], if provided."
    Integer rSize;

    "The result object, which *may* be the same as [[u]].
     If provided, this object must be large enough to hold the result;
     that is, at least `uSize + 1` words, or, as a special case, just
     `uSize` words if there is no final carry. This method will zero-out
     unused portions of [[r]] up to the index `rSize - 1`."
    Words r;

    value wMask = wordMask;
    value wBits = wordBits;

    //assert(v.and(wMask) == v);

    variable value carry = 0;
    variable value i = 0;

    // multiply
    while (i < uSize) {
        value product = u.get(i) * v + carry;
        r.set(i, product.and(wMask));
        carry = product.rightLogicalShift(wBits);
        i++;
    }

    // only set the carry if we need to
    if (!carry == 0) {
        r.set(i, carry);
        i++;
    }

    // zero out remaining words of provided array
    while (i < rSize) {
        r.set(i, 0);
        i++;
    }

    return r;
}

"Used for division, this method sets:

     u[j-vsize..j-1] <- u[j-vsize..j-1] - v * q

 and returns the absolute value of the final borrow that would normally
 be subtracted against `u[j]`."
Integer multiplyAndSubtract(Words u, Integer vSize, Words v, Integer q, Integer j) {
    value wMask = wordMask;
    value wBits = wordBits;

    value offset = j - vSize;
    variable value borrow = 0;
    variable value vIndex = 0;
    while (vIndex < vSize) {
        value uIndex = vIndex + offset;
        value product = q * v.get(vIndex);
        value difference =    u.get(uIndex)
                            - product.and(wMask)
                            - borrow;
        u.set(uIndex, difference.and(wMask));
        borrow =   product.rightLogicalShift(wBits)
                 - difference.rightArithmeticShift(wBits);
        vIndex++;
    }

    return borrow;
}

"Used for division when the estimated `q` used in [[multiplyAndSubtract]] was
 too large, this method sets:

     u[j-vSize..j-1] <- u[j-vSize..j-1] + v

 discarding the final carry."
void addBack(Words u, Integer vSize, Words v, Integer j) {
    value wMask = wordMask;
    value wBits = wordBits;

    value offset = j - vSize;
    variable value carry = 0;
    variable value vIndex = 0;
    while (vIndex < vSize) {
        value uIndex = vIndex + offset;
        value sum =   u.get(uIndex)
                    + v.get(vIndex)
                    + carry;
        u.set(uIndex, sum.and(wMask));
        carry = sum.rightLogicalShift(wBits);
        vIndex++;
    }
}

"Divides [[dividend]] by [[divisor]], possibly returning the remainder, and
 storing the quotient in [[quotient]], if provided. All values are unsigned.

 The remainder will be returned if [[calculateRemainder]] is true. Otherwise,
 a unusable dummy value will be returned."
Words divide(
            Integer dividendSize, Words dividend,
            Integer divisorSize, Words divisor,
            Boolean calculateRemainder,
            quotient = null) {

    "The object to hold the quotient, or null if the quotient is not needed.
     This *may not* be the same as [[dividend]] or [[divisor]], and *must*
     be at least [[dividendSize]] and *must* be zero filled."
    Words? quotient;

    if (divisorSize < 2) {
        value first = divisor.get(0);
        return divideWord(dividendSize, dividend, first, calculateRemainder, quotient);
    }

    // Knuth 4.3.1 Algorithm D
    // assert(size(divisor) >= 2);
    value wMask = wordMask;
    value wBits = wordBits;

    // D1. Normalize (v's highest bit must be set)
    value b = wordRadix;
    value shift = let (highWord = divisor.get(divisorSize - 1),
                       highBit = unsignedHighestNonZeroBit(highWord))
                  wBits - 1 - highBit;
    Words u;
    Words v;
    Integer uSize = dividendSize + 1;
    Integer vSize = divisorSize;
    if (shift == 0) {
        u = copyAppend(dividendSize, dividend, 0);
        v = divisor;
    }
    else {
        u = leftShift(dividendSize, dividend, shift, dividendSize + 1);
        v = leftShift(divisorSize, divisor, shift);
    }
    value v0 = v.get(vSize - 1); // most significant, can't be 0
    value v1 = v.get(vSize - 2); // second most significant must exist

    // D2. Initialize j
    variable value j = uSize - 1;
    while (j >= vSize) {
        // D3. Compute qj
        value uj0 = u.get(j);

        variable Integer qj;
        if (uj0 == v0) {
            // most significant divisor word and
            // most significant dividend word are equal
            // so, guess the largest possible quotient
            // (a decimal example would be 100/11)
            qj = wMask;
        } else {
            // most significant divisor word is greater than
            // the most significant dividend word, so the
            // unsignedDivide below will not overflow
            // wSize/2 for the quotient.
            // (a decimal example would be 899/90)

            // Note that uj01 may be negative if larger than
            // 2^wBits-1 (due to two's complement overflow),
            // which is why 'unsignedDivide' may be used below.

            variable Integer rj;
            value uj1 = u.get(j-1);
            value uj2 = u.get(j-2);
            value uj01 = uj0.leftLogicalShift(wBits) + uj1;

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
            u.set(j, 0);
            if (exists quotient) {
                quotient.set(j - vSize, qj);
            }
        }
        // D7. Loop
        j--;
    }

    // D8. Unnormalize Remainder Due to Step D1
    if (calculateRemainder) {
        return rightShiftInPlace(false, realSize(u, uSize), u, shift);
    }
    else {
        return dummyWords;
    }
}

"Divides [[u]] by [[v]], possibly returning the remainder, and
 storing the quotient in [[quotient]], if provided. All values are unsigned.

 The remainder will be returned if [[calculateRemainder]] is true. Otherwise,
 a unusable dummy value will be returned."
Words divideWord(Integer uSize, Words u, Integer v,
        Boolean calculateRemainder, quotient = null) {

    "The object to hold the quotient, or null if the quotient is not needed.
     This *may not* be the same as [[u]], and *must* be at least [[uSize]]
     and *must* be zero filled."
    Words? quotient;

    value wMask = wordMask;
    value wBits = wordBits;

    // assert(uSize >= 1);
    // assert(v.and(wMask) == v);

    variable value r = 0;
    variable value uIndex = uSize - 1;
    while (uIndex >= 0) {
        value x = r.leftLogicalShift(wBits) + u.get(uIndex);
        if (x >= 0) {
            r = x % v;
            if (exists quotient) {
                quotient.set(uIndex, x / v);
            }
        } else {
            // resultant q will never be larger than one word,
            // so unsignedDivide here is safe
            value qr = unsignedDivide(x, v);
            r = qr.and(wMask);
            if (exists quotient) {
                quotient.set(uIndex, qr.rightLogicalShift(wBits));
            }
        }
        uIndex--;
    }
    if (calculateRemainder) {
        return if (r.zero)
               then wordsOfSize(0)
               else wordsOfOne(r);
    }
    else {
        return dummyWords;
    }
}

see (`function predecessor`)
Words predecessorInPlace(Integer wordsSize, Words words)
    =>  predecessor(wordsSize, words, wordsSize, words);

"Return the value of [[words]] decremented by one. [[words]] must not be zero.
 All values are unsigned.

 The returned value will always be [[r]]."
Words predecessor(Integer wordsSize, Words words,
                  Integer rSize = wordsSize,
                  r = wordsOfSize(rSize)) {

    "The result object, which *may* be the same as [[words]].
     If provided, this object must be large enough to hold the result;
     that is, at least `wordsSize` words. This method will zero-out unused
     portions of [[r]] up to the index `rSize - 1`."
    Words r;

    // asert words > 0
    value wMask = wordMask;
    variable value rIndex = 0;
    while (rIndex < wordsSize) {
        value wi = words.get(rIndex);
        if (wi == 0) {
            r.set(rIndex, wMask);
        }
        else {
            r.set(rIndex, wi - 1);
            if (!(words === r)) {
                // copy remaining words
                rIndex++;
                if (rIndex < wordsSize) {
                    words.copyTo(r, rIndex, rIndex, wordsSize - rIndex);
                    rIndex = wordsSize;
                }
                // clear remaining parts of r
                while (rIndex < rSize) {
                    r.set(rIndex, 0);
                    rIndex++;
                }
            }
            return r;
        }
        rIndex++;
    }
    // will only happen if words is zero, which is not allowed
    assert(false);
}

"Return the value of [[words]] incremented by one. It is explicitly
 allowed for `words[size-1]` to be zero. All values are unsigned.

 *Note:* the returned value will be the same object as [[words]]
 if and only if [[words]] is large enough for the result."
Words successorInPlace(Integer wordsSize, Words words) {
    value wMask = wordMask;
    variable value previous = 0;
    variable value i = -1;
    while (++i < wordsSize && previous == 0) {
        previous = (words.get(i) + 1).and(wMask);
        words.set(i, previous);
    }

    if (previous == 0) { // w was all ones
        if (words.size > wordsSize) {
            // there's extra room in 'words', use it
            words.set(wordsSize, 1);
            return words;
        }
        else {
            value result = wordsOfSize(wordsSize + 1);
            result.set(wordsSize, 1);
            return result;
        }
    }
    else {
        return words;
    }
}

"Return a new [[Words]]s object containing the value of [[words]] incremented
 by one. It is explicitly allowed for `words[size-1]` to be zero. All values
 are unsigned."
Words successor(Integer wordsSize, Words words)
    =>  successorInPlace(wordsSize, words.clone());

"Used by [[rightShiftImpl]] to help with two's complement concerns. Returns
 true if any `one` bits are present in the given shift range."
Boolean nonZeroBitsDropped(Words u,
                           Integer shiftWords,
                           Integer shiftBits) {
    variable value i = 0;
    while (i < shiftWords) {
        if (u.get(i) != 0) {
            return true;
        }
        i++;
    }

    return (shiftBits > 0) &&
            u.get(shiftWords)
            .leftLogicalShift(wordBits - shiftBits)
            .and(wordMask) != 0;
}

"Return a new [[Words]] object holding result of [[u]] shifted right [[shift]]
 bits. Both [[u]] and the result are unsigned, but the shift is performed in
 two's complement, using [[negative]] for the conversions as necessary.

 This is, in effect, an arithmetic right shift, so the caller should
 consider the sign to be preserved."
Words rightShift(Boolean negative, Integer uSize, Words u, Integer shift) {
    //assert (shift >= 0);

    value wBits = wordBits;
    value shiftBits = shift % wBits;
    value shiftWords = shift / wBits;

    Words r;
    Integer rSize;

    if (shiftWords >= uSize) {
        return if (negative) then wordsOfOne(1) else wordsOfSize(0);
    }

    if (shiftBits == 0) {
        rSize = uSize - shiftWords;
        r = wordsOfSize(rSize);
    }
    else {
        // anticipate size
        value highWord = u.get(uSize - 1)
                         .rightLogicalShift(shiftBits);
        value saveWord = if (highWord == 0) then 1 else 0;
        rSize = uSize - shiftWords - saveWord;
        r = wordsOfSize(rSize);
    }

    return rightShiftImpl(negative, uSize, u, rSize, r,
                  shiftWords, shiftBits);
}

"Return the result of [[u]] shifted right [[shift]] bits. Both [[u]] and
 the result are unsigned, but the shift is performed in two's complement,
 using [[negative]] for the conversions as necessary.

 The returned object will always be the same as [[u]].

 This is, in effect, an arithmetic right shift, so the caller should
 consider the sign to be preserved."
Words rightShiftInPlace(
            Boolean negative, Integer uSize, Words u, Integer shift)
    =>  let (wBits = wordBits,
             shiftBits = shift % wBits,
             shiftWords = shift / wBits)
        if (uSize != 0 && (shiftBits != 0 || shiftWords != 0))
        then rightShiftImpl(
                    negative, uSize, u, uSize, u,
                    shiftWords, shiftBits)
        else u;

"Used internally by [[rightShift]] and [[rightShiftInPlace]]."
Words rightShiftImpl(Boolean negative,
                     Integer uSize, Words u,
                     Integer rSize, Words r,
                     Integer shiftWords,
                     Integer shiftBits) {
    value wBits = wordBits;
    value wMask = wordMask;

    Boolean nonZerosDropped =
            negative &&
            (shiftBits > 0 || shiftWords > 0) &&
            nonZeroBitsDropped(u, shiftWords, shiftBits);

    if (shiftBits == 0 || uSize == 0) {
        if (shiftWords < uSize) {
            u.copyTo(r, shiftWords, 0, uSize - shiftWords);
        }
        // clear remaining high words of r
        variable value rIndex = uSize - shiftWords;
        while (rIndex < rSize) {
            r.set(rIndex++, 0);
        }
    }
    else {
        value shiftBitsLeft = wBits - shiftBits;
        variable value rIndex = 0;
        variable value uIndex = shiftWords;
        variable value corrWord = u.get(uIndex);
        while (++uIndex < uSize) {
            value higherWord = u.get(uIndex);
            value l = corrWord.rightLogicalShift(shiftBits);
            value h = higherWord.leftLogicalShift(shiftBitsLeft).and(wMask);
            r.set(rIndex, l + h);
            corrWord = higherWord;
            rIndex++;
        }
        // process last word only if non-zero
        value highWord = corrWord.rightLogicalShift(shiftBits);
        if (highWord != 0) {
            r.set(rIndex, highWord);
            rIndex++;
        }
        // clear remaining high words of r
        while (rIndex < rSize) {
            r.set(rIndex++, 0);
        }
    }

    // for negative numbers, if any one bits were lost,
    // add one to the magnitude to simulate two's
    // complement arithmetic right shift
    return if (nonZerosDropped)
           then successorInPlace(rSize, r)
           else r;
}

"Return a new [[Words]] object holding result of [[u]] shifted left [[shift]]
 bits."
Words leftShift(Integer uSize, Words u,
                Integer shift, minSize = uSize) {

    "The minimum size for the new [[Words]] object created to hold the
     result. This is useful for callers that need room for additional
     words for subsequent operations."
    Integer minSize;

    //assert (shift >= 0);

    value wBits = wordBits;
    value shiftBits = shift % wBits;
    value shiftWords = shift / wBits;

    Words r;
    Integer rSize;

    if (uSize == 0) {
        return wordsOfSize(minSize);
    }

    if (shiftBits == 0) {
        rSize = largest(minSize, uSize + shiftWords);
        r = wordsOfSize(rSize);
    }
    else {
        if (minSize > uSize + shiftWords) {
            rSize = minSize;
        }
        else {
            rSize = leftShiftAnticipateSize(
                uSize, u, shiftWords, shiftBits);
        }
        r = wordsOfSize(rSize);
    }

    return leftShiftImpl(uSize, u, rSize, r,
                         shiftWords, shiftBits);
}

"Return the result of shifting [[u]] left [[shift]] bits.

 *Note:* the returned value will be the same object as [[u]]
 if and only if [[u]] is large enough for the result."
Words leftShiftInPlace(Integer uSize, Words u, Integer shift) {
    value wBits = wordBits;
    value shiftBits = shift % wBits;
    value shiftWords = shift / wBits;

    Words r;
    Integer rSize;
    value requiredSize = leftShiftAnticipateSize(
            uSize, u, shiftWords, shiftBits);

    if (u.size >= requiredSize) {
        rSize = uSize;
        r = u;
    } else {
        rSize = requiredSize;
        r = wordsOfSize(rSize);
    }
    return leftShiftImpl(uSize, u, rSize, r, shiftWords, shiftBits);
}

"Used internally by [[leftShift]] and [[leftShiftInPlace]]."
Words leftShiftImpl(Integer uSize, Words u,
                    Integer rSize, Words r,
                    Integer shiftWords,
                    Integer shiftBits) {
    value wBits = wordBits;
    value wMask = wordMask;

    if (shiftBits == 0 || uSize == 0) {
        u.copyTo(r, 0, shiftWords, uSize);
        // clear low words of r
        variable value rIndex = 0;
        while (rIndex < shiftWords && rIndex < rSize) {
            r.set(rIndex++, 0);
        }
        // clear remaining high words of r
        rIndex = uSize + shiftWords;
        while (rIndex < rSize) {
            r.set(rIndex++, 0);
        }
    }
    else {
        value shiftBitsRight = wBits - shiftBits;
        variable value rIndex = shiftWords;
        variable value uIndex = 0;
        variable value lowerWord = 0;
        while (uIndex < uSize) {
            value corrWord = u.get(uIndex);
            value l = corrWord.leftLogicalShift(shiftBits).and(wMask);
            value h = lowerWord.rightLogicalShift(shiftBitsRight);
            r.set(rIndex, l + h);
            lowerWord = corrWord;
            rIndex++;
            uIndex++;
        }
        // process last word only if non-zero
        value highWord = lowerWord.rightLogicalShift(shiftBitsRight);
        if (highWord != 0) {
            r.set(rIndex, highWord);
            rIndex++;
        }
        // clear remaining high words of r
        while (rIndex < rSize) {
            r.set(rIndex++, 0);
        }
        // clear low words of r
        rIndex = 0;
        while (rIndex < shiftWords) {
            r.set(rIndex++, 0);
        }
    }
    return r;
}

"Used internally by [[leftShift]] and [[leftShiftInPlace]]."
Integer leftShiftAnticipateSize(
        Integer uSize, Words u,
        Integer shiftWords, Integer shiftBits)
    =>  if (uSize == 0) then
            0
        else if (shiftBits == 0) then
            uSize + shiftWords
        else
            let (highWord = u.get(uSize - 1)
                    .rightLogicalShift(wordBits - shiftBits),
                addWord = if (highWord == 0) then 0 else 1)
            uSize + shiftWords + addWord;

"Return the magnitude, in unsigned notation, of [[words]]
 which is provided in two's complement.

 *Note:* the returned value will be the same object as [[r]]
 if and only if [[r]] is large enough for the result.

 *Note:* This method breaks from the normal convention of
 arguments being provided in unsigned form; [[words]] is
 interpreted in two's complement."
Words twosToUnsigned(Words words,
                     r = wordsOfSize(words.size)) {

    "The *proposed* result object, which *may* be the same as [[words]].
     This method will zero-out unused portions of [[r]]."
    Words r;

    value wordsSize = words.size;
    if (!words.get(wordsSize - 1).get(wordBits - 1)) {
        // words are positive, we shouldn't have been called...
        if (!words === r) {
            words.copyTo(r);
            // clear potentially oversized 'r'
            for (i in wordsSize..r.size - 1) {
                r.set(i, 0);
            }
        }
        return r;
    }
    else {
        // flip the bits and add one
        // We don't have to worry about sign extension, since the
        // returned value will always be positive, and in unsigned
        // notation. We also don't have to worry about zeroing 'r'
        // since twosNot will do that for us.
        return successorInPlace(wordsSize, twosNot(words, r));
    }
}

"Return the result, in two's complement, of performing the NOT
 operation on [[words]], which is provided in two's complement.

 The returned value will be the same object as [[r]], which must
 be large enough to hold the result. The sign bit will be extended
 to fill the entirety of [[r]].

 *Note:* This method breaks from the normal convention of
 arguments being provided in unsigned form; [[words]] is
 interpreted in two's complement.

 *Note:* This method further breaks from convention by returning
 a value of [[Words]] in two's complement notation."
Words twosNot(Words words,
              Words r = wordsOfSize(words.size)) {
    value wMask = wordMask;
    variable value rIndex = 0;
    value wordsSize = words.size;
    while (rIndex < wordsSize) {
        r.set(rIndex, words.get(rIndex).not.and(wMask));
        rIndex++;
    }
    value rSize = r.size;
    if (rIndex < rSize) {
        // extend sign
        value signWord =
                if (r.get(rIndex - 1).get(wordBits - 1))
                then wMask // negative
                else 0; // positive or zero
        while (rIndex < rSize) {
            r.set(rIndex, signWord);
            rIndex++;
        }
    }
    return r;
}

"All values are unsigned."
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
            value xi = x.get(i);
            value yi = y.get(i);
            if (xi != yi) {
                return if (xi < yi)
                then smaller
                else larger;
            }
        }
        return equal;
    }
}

"This is a narrowing operation, returning an [[Integer]] holding only the
 lower [[runtime.integerAddressableSize]] number of bits of the two's
 complement representation of [[words]]."
Integer integerForWords(Integer wordsSize, Words words, Boolean negative) {
    // easy cases
    if (wordsSize == 0) {
        return 0;
    } else if (wordsSize == 1) {
        value magnitude = words.get(0);
        return if (negative) then -magnitude else magnitude;
    }

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
                    x = words.get(i).negated;
                    nonZeroSeen = x != 0;
                }
                else {
                    // flip the rest
                    x = words.get(i).not;
                }
            }
            else {
                x = words.get(i);
            }
        }
        else {
            x = if (negative) then -1 else 0;
        }
        value newBits = x.and(wMask).leftLogicalShift(i * wBits);
        result = result.or(newBits);
    }
    return result;
}

"Convert words to an Integer, avoiding bitwise operations,
 and disregarding runtime.integerAddressableSize"
Integer integerForWordsNaive(Integer wordsSize, Words words) {
    // easy cases
    if (wordsSize == 0) {
        return 0;
    } else if (wordsSize == 1) {
        return words.get(0);
    }

    value wRadix = wordRadix;
    variable value factor = 1;
    variable value result = 0;
    for (i in 0:wordsSize) {
        result += words.get(i) * factor;
        factor *= wRadix;
    }
    return result;
}

Integer smallest(Integer x, Integer y)
    =>  if (x < y) then x else y;

Integer largest(Integer x, Integer y)
    =>  if (x > y) then x else y;
