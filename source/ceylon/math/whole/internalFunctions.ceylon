import ceylon.math.integer {
    largest,
    smallest
}

Integer realSize(Words words, variable Integer maxSize) {
    variable value lastIndex =
            if (maxSize >= 0)
            then smallest(sizew(words), maxSize) - 1
            else sizew(words) - 1;

    while (lastIndex >= 0, getw(words, lastIndex) == 0) {
        lastIndex--;
    }
    return lastIndex + 1;
}

Integer calculateTrailingZeroWords(Integer wordsSize, Words words) {
    for (i in 0:wordsSize) {
        if (getw(words, i) != 0) {
            return i;
        }
    } else {
        assert(wordsSize == 0);
        return 0;
    }
}

"Minimal length to represent words in two's complement, excluding a sign bit."
Integer calculateBitLength(Integer wordsSize, Words words, Integer? trailingZeroWords) {
    if (wordsSize == 0) {
        return 0;
    }
    variable Integer length;
    value highWord = getw(words, wordsSize - 1);
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

Words logicOperation(
        Integer firstSize, Words firstWords,
        Integer firstBitLength, Integer? firstTrailingZeroWords,
        Integer secondSize, Words secondWords,
        Integer secondBitLength, Integer? secondTrailingZeroWords,
        Integer(Integer)(Integer) op,
        Words? rWords = null) {

    // must be large enough for at least 1 sign bit
    value count = largest(firstBitLength / wordBits + 1,
                          secondBitLength / wordBits + 1);

    Words result = if (exists rWords, sizew(rWords) >= count)
                   then rWords
                   else wordsOfSize(count);

    for (i in 0:sizew(result)) {
        // iterate all elements of the result in order to fully
        // extend the sign bit
        value a = getWordInTwos(firstSize, firstWords, i, firstTrailingZeroWords);
        value b = getWordInTwos(secondSize, secondWords, i, secondTrailingZeroWords);
        setw(result, i, op(a)(b));
    }
    return result;
}

"Inputs and outputs are unsigned, operation occurs in two's complement"
Words setBit(Integer wordsSize, Words words,
          Integer wordsBitLength, Integer? trailingZeroWords,
          Integer index, Boolean bit,
          Words? rWords = null) {

    value newLength = largest(wordsBitLength / wordBits + 1,
                              (index + 1) / wordBits + 1);
    value result = if (exists rWords, sizew(rWords) >= newLength)
                   then rWords
                   else wordsOfSize(newLength);
    for (rIndex in 0:sizew(result)) {
        setw(result, rIndex, getWordInTwos(wordsSize, words, rIndex, trailingZeroWords));
    }
    value wordNum = index / wordBits;
    value bitNum = index % wordBits;
    setw(result, wordNum, getw(result, wordNum).set(bitNum, bit));
    return if (exists trailingZeroWords) // if negative
           then twosToUnsigned(sizew(result), result, result)
           else result;
}

"Inputs and outputs are unsigned, operation occurs in two's complement"
Words flipBit(Integer wordsSize, Words words,
          Integer wordsBitLength, Integer? trailingZeroWords,
          Integer index,
          Words? rWords = null) {

    value newLength = largest(wordsBitLength / wordBits + 1,
                              (index + 1) / wordBits + 1);
    value result = if (exists rWords, sizew(rWords) >= newLength)
                   then rWords
                   else wordsOfSize(newLength);
    for (rIndex in 0:sizew(result)) {
        setw(result, rIndex, getWordInTwos(wordsSize, words, rIndex, trailingZeroWords));
    }
    value wordNum = index / wordBits;
    value bitNum = index % wordBits;
    setw(result, wordNum, getw(result, wordNum).flip(bitNum));
    return if (exists trailingZeroWords) // if negative
           then twosToUnsigned(sizew(result), result, result)
           else result;
}

Integer getWordInTwos(Integer wordsSize, Words words,
                      Integer wordIndex, Integer? trailingZeroWords)
    =>  if (exists trailingZeroWords)
        then getWordInTwosNegative(wordsSize, words, wordIndex, trailingZeroWords)
        else getWordInTwosPositive(wordsSize, words, wordIndex);

// logically extend to infinite length
Integer getWordInTwosPositive(Integer wordsSize, Words words, Integer wordIndex)
    =>  if (!(0 <= wordIndex < wordsSize))
        then 0
        else getw(words, wordIndex);

// logically extend to infinite length
Integer getWordInTwosNegative(Integer wordsSize, Words words, Integer wordIndex,
                              Integer trailingZeroWords)
    =>  let (wMask = wordMask)
        if (wordIndex < trailingZeroWords) then
            0
        else if (wordIndex >= wordsSize) then
            wMask
        else
           let (rawWord = getw(words, wordIndex))
           if (wordIndex == trailingZeroWords)
           then rawWord.negated.and(wMask) // first non-zero word
           else rawWord.not.and(wMask); // wordNum > zeros

Boolean getBitPositive(Integer wordsSize, Words words, Integer index)
    =>  let (wBits = wordBits,
             word = getWordInTwosPositive(wordsSize, words, index / wBits),
             mask = 1.leftLogicalShift(index % wBits))
        word.and(mask) != 0;

Boolean getBitNegative(Integer wordsSize, Words words, Integer index,
                       Integer trailingZeroWords)
    =>  if (index == 0) then
            getw(words, 0).get(0)
        else
            let (wBits = wordBits,
                 mask = 1.leftLogicalShift(index % wBits),
                 word = getWordInTwosNegative(
                            wordsSize,
                            words,
                            index / wBits,
                            trailingZeroWords))
            word.and(mask) != 0;

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
        if (!(u === r)) {
            copyWords(u, r, i, i, uSize - i);
        }
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
        if (!(u === r)) {
            copyWords(u, r, i, i, uSize - i);
        }
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

"If provided, quotient must be at least dividendSize and zero filled."
Words|Absent divide<Absent=Null>(
            Integer dividendSize, Words dividend,
            Integer divisorSize, Words divisor,
            Words? quotient = null)
            given Absent satisfies Null {

    if (divisorSize < 2) {
        value first = getw(divisor, 0);
        return divideWord<Absent>(dividendSize, dividend, first, quotient);
    }

    // Knuth 4.3.1 Algorithm D
    // assert(size(divisor) >= 2);
    value wMask = wordMask;
    value wBits = wordBits;

    // D1. Normalize (v's highest bit must be set)
    value b = wordRadix;
    value shift = let (highWord = getw(divisor, divisorSize - 1),
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
            if (exists quotient) {
                setw(quotient, j - vSize, qj);
            }
        }
        // D7. Loop
        j--;
    }

    // D8. Unnormalize Remainder Due to Step D1
    if (is Absent null) {
        return null;
    }
    else {
        return rightShiftInplace(false, realSize(u, uSize), u, shift);
    }
}

"If provided, quotient must be at least dividendSize and zero filled."
Words|Absent divideWord<Absent=Null>(Integer uSize, Words u,
                                Integer v, Words? quotient = null)
                                given Absent satisfies Null {
    value wMask = wordMask;
    value wBits = wordBits;

    // assert(uSize >= 1);
    // assert(v.and(wMask) == v);

    variable value r = 0;
    variable value uIndex = uSize - 1;
    while (uIndex >= 0) {
        value x = r.leftLogicalShift(wBits) + getw(u, uIndex);
        if (x >= 0) {
            r = x % v;
            if (exists quotient) {
                setw(quotient, uIndex, x / v);
            }
        } else {
            value qr = unsignedDivide(x, v);
            r = qr.and(wMask);
            if (exists quotient) {
                setw(quotient, uIndex, qr.rightLogicalShift(wBits));
            }
        }
        uIndex--;
    }
    if (is Absent null) {
        return null;
    }
    else {
        return if (r.zero)
               then wordsOfSize(0)
               else wordsOfOne(r);
    }
}

Words predecessorInPlace(Integer wordsSize, Words words)
    =>  predecessor(wordsSize, words, wordsSize, words);

Words predecessor(Integer wordsSize, Words words,
                  Integer rSize = wordsSize,
                  Words r = wordsOfSize(rSize)) {
    // asert words > 0
    value wMask = wordMask;
    variable value rIndex = 0;
    while (rIndex < wordsSize) {
        value wi = getw(words, rIndex);
        if (wi == 0) {
            setw(r, rIndex, wMask);
        }
        else {
            setw(r, rIndex, wi - 1);
            if (!(words === r)) {
                // copy remaining words
                rIndex++;
                while (rIndex < wordsSize) {
                    setw(r, rIndex, getw(words, rIndex));
                    rIndex++;
                }
                // clear remaining parts of r
                while (rIndex < rSize) {
                    setw(r, rIndex, 0);
                    rIndex++;
                }
            }
            return r;
        }
        rIndex++;
    }
    assert(false);
}

// it is ok for w[size-1] to be 0
Words successorInPlace(Integer wordsSize, Words words) {
    value wMask = wordMask;
    variable value previous = 0;
    variable value i = -1;
    while (++i < wordsSize && previous == 0) {
        previous = (getw(words, i) + 1).and(wMask);
        setw(words, i, previous);
    }

    if (previous == 0) { // w was all ones
        if (sizew(words) > wordsSize) {
            // there's extra room in 'words', use it
            setw(words, wordsSize, 1);
            return words;
        }
        else {
            value result = wordsOfSize(wordsSize + 1);
            setw(result, wordsSize, 1);
            return result;
        }
    }
    else {
        return words;
    }
}

// it is ok for w[size-1] to be 0
Words successor(Integer wordsSize, Words words)
    =>  successorInPlace(wordsSize, clonew(words));

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
        value highWord = getw(u, uSize - 1)
                         .rightLogicalShift(shiftBits);
        value saveWord = if (highWord == 0) then 1 else 0;
        rSize = uSize - shiftWords - saveWord;
        r = wordsOfSize(rSize);
    }

    return rightShiftImpl(negative, uSize, u, rSize, r,
                  shiftWords, shiftBits);
}

Words rightShiftInplace(
            Boolean negative, Integer uSize, Words u, Integer shift)
    =>  let (wBits = wordBits,
             shiftBits = shift % wBits,
             shiftWords = shift / wBits)
        if (uSize != 0 && (shiftBits != 0 || shiftWords != 0))
        then rightShiftImpl(
                    negative, uSize, u, uSize, u,
                    shiftWords, shiftBits)
        else u;

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
            copyWords(u, r, shiftWords, 0, uSize - shiftWords);
        }
        // clear remaining high words of r
        variable value rIndex = uSize - shiftWords;
        while (rIndex < rSize) {
            setw(r, rIndex++, 0);
        }
    }
    else {
        value shiftBitsLeft = wBits - shiftBits;
        variable value rIndex = 0;
        variable value uIndex = shiftWords;
        variable value corrWord = getw(u, uIndex);
        while (++uIndex < uSize) {
            value higherWord = getw(u, uIndex);
            value l = corrWord.rightLogicalShift(shiftBits);
            value h = higherWord.leftLogicalShift(shiftBitsLeft).and(wMask);
            setw(r, rIndex, l + h);
            corrWord = higherWord;
            rIndex++;
        }
        // process last word only if non-zero
        value highWord = corrWord.rightLogicalShift(shiftBits);
        if (highWord != 0) {
            setw(r, rIndex, highWord);
            rIndex++;
        }
        // clear remaining high words of r
        while (rIndex < rSize) {
            setw(r, rIndex++, 0);
        }
    }

    // for negative numbers, if any one bits were lost,
    // add one to the magnitude to simulate two's
    // complement arithmetic right shift
    return if (nonZerosDropped)
           then successorInPlace(rSize, r)
           else r;
}

Words leftShift(Integer uSize, Words u,
                Integer shift, Integer minSize = uSize) {
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

Words leftShiftInplace(Integer uSize, Words u, Integer shift) {
    value wBits = wordBits;
    value shiftBits = shift % wBits;
    value shiftWords = shift / wBits;

    Words r;
    Integer rSize;
    value requiredSize = leftShiftAnticipateSize(
            uSize, u, shiftWords, shiftBits);

    if (sizew(u) >= requiredSize) {
        rSize = uSize;
        r = u;
    } else {
        rSize = requiredSize;
        r = wordsOfSize(rSize);
    }
    return leftShiftImpl(uSize, u, rSize, r, shiftWords, shiftBits);
}

Words leftShiftImpl(Integer uSize, Words u,
                    Integer rSize, Words r,
                    Integer shiftWords,
                    Integer shiftBits) {
    value wBits = wordBits;
    value wMask = wordMask;

    if (shiftBits == 0 || uSize == 0) {
        copyWords(u, r, 0, shiftWords, uSize);
        // clear low words of r
        variable value rIndex = 0;
        while (rIndex < shiftWords && rIndex < rSize) {
            setw(r, rIndex++, 0);
        }
        // clear remaining high words of r
        rIndex = uSize + shiftWords;
        while (rIndex < rSize) {
            setw(r, rIndex++, 0);
        }
    }
    else {
        value shiftBitsRight = wBits - shiftBits;
        variable value rIndex = shiftWords;
        variable value uIndex = 0;
        variable value lowerWord = 0;
        while (uIndex < uSize) {
            value corrWord = getw(u, uIndex);
            value l = corrWord.leftLogicalShift(shiftBits).and(wMask);
            value h = lowerWord.rightLogicalShift(shiftBitsRight);
            setw(r, rIndex, l + h);
            lowerWord = corrWord;
            rIndex++;
            uIndex++;
        }
        // process last word only if non-zero
        value highWord = lowerWord.rightLogicalShift(shiftBitsRight);
        if (highWord != 0) {
            setw(r, rIndex, highWord);
            rIndex++;
        }
        // clear remaining high words of r
        while (rIndex < rSize) {
            setw(r, rIndex++, 0);
        }
        // clear low words of r
        rIndex = 0;
        while (rIndex < shiftWords) {
            setw(r, rIndex++, 0);
        }
    }
    return r;
}

Integer leftShiftAnticipateSize(
        Integer uSize, Words u,
        Integer shiftWords, Integer shiftBits)
    =>  if (uSize == 0) then
            0
        else if (shiftBits == 0) then
            uSize + shiftWords
        else
            let (highWord = getw(u, uSize - 1)
                    .rightLogicalShift(wordBits - shiftBits),
                addWord = if (highWord == 0) then 0 else 1)
            uSize + shiftWords + addWord;

"return magnitude in unsigned notation of the parameter words,
 provided in two's complement."
Words twosToUnsigned(Integer wordsSize, Words words,
                     Words r = wordsOfSize(wordsSize)) {
    if (!getw(words, wordsSize - 1).get(wordBits - 1)) {
        // words are positive, we shouldn't have been called...
        if (!words === r) {
            copyWords(words, r);
            // clear potentially oversized 'r'
            for (i in wordsSize..sizew(r) - 1) {
                setw(r, i, 0);
            }
        }
        return r;
    }
    else {
        // flip the bits and add one
        return successorInPlace(wordsSize, twosNot(wordsSize, words, r));
    }
}

"not operation, interpreting words in two's complement, despite
 the usual unsigned representation. The sign bit is extended to
 cover all words of [[r]]."
Words twosNot(Integer wordsSize,
              Words words,
              Words r = wordsOfSize(wordsSize)) {
    value wMask = wordMask;
    variable value rIndex = 0;
    while (rIndex < wordsSize) {
        setw(r, rIndex, getw(words, rIndex).not.and(wMask));
        rIndex++;
    }
    value rSize = sizew(r);
    if (rIndex < rSize) {
        // extend sign
        value signWord =
                if (getw(r, rIndex - 1).get(wordBits - 1))
                then wMask // negative
                else 0; // positive or zero
        while (rIndex < rSize) {
            setw(r, rIndex, signWord);
            rIndex++;
        }
    }
    return r;
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

Integer integerForWords(Integer wordsSize, Words words, Boolean negative) {
    // easy cases
    if (wordsSize == 0) {
        return 0;
    } else if (wordsSize == 1) {
        value magnitude = getw(words, 0);
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
    return result;
}
