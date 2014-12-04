"The given [[number]] converted to a [[Whole]]."
shared Whole wholeNumber(variable Integer number) {
    Sign sign;

    // 0th element is non-zero and most-significant
    Array<Integer> words;

    if (number == 0) {
        sign = zeroSign;
        words = Array<Integer> {};
    }
    else {
        if (number < 0) {
            number = -number;
            sign = negativeSign;
        }
        else {
            sign = positiveSign;
        }

        words = arrayOfSize(64/wordSize, 0);
        for (i in 0..(64/wordSize-1)) {
            // FIXME avoid shift on JS (but make sure 2^63 works on Java)
            words.set(64/wordSize - i - 1, number.rightLogicalShift(i*wordSize).and(wordMask));
        }
    }
    return Whole(sign, normalized(words));
}
