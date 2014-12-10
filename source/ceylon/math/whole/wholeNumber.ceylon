"The given [[number]] converted to a [[Whole]]."
throws (`class OverflowException`,
    "if the number is greater than [[runtime.maxIntegerValue]]
     or less than [[runtime.minIntegerValue]]")
shared Whole wholeNumber(variable Integer number)
    =>   if (number == -1) then negativeOne
    else if (number == 0)  then zero
    else if (number == 1)  then one
    else if (number == 2)  then two
    else Whole.Internal(number.sign, integerToWordsAbs(number));

Words integerToWordsAbs(variable Integer integer) {
    // * Bitwise operations are not used; JavaScript's min/max Integer range
    //   is greater than what is supported by runtime.integerAddressableSize
    //
    // * The absolute value is not calculated as an initial step; on the JVM,
    //   runtime.minIntegerValue.magnitude == runtime.minIntegerValue
    //
    // * These min/max limits were chosen as sane, justifiable, and
    //   easily documented values. A 64-bit range would require additional
    //   constants. Using runtime.integerAddressableSize would seem punitive
    //   on JavaScript, and would also require new constants.
    //
    // * Having no limits at all would allow numbers as large as 1.79E+308,
    //   and would require a different conversion method.
    if (! runtime.minIntegerValue <= integer <= runtime.maxIntegerValue) {
        throw OverflowException();
    }
    value words = Words(64/wordSize);
    value numWords = 64/wordSize;
    for (i in 1:numWords) {
        words.set(numWords - i, (integer % wordRadix).magnitude);
        integer /= wordRadix;
    }
    return words;
}
