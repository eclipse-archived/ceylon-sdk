Comparison unsignedCompare(Integer first, Integer second)
    =>  if (first == second) then
            equal
        else if (first + minAddressableInteger >
                 second + minAddressableInteger) then
            larger
        else
            smaller;

"The lowest wordsize bits of the return value will contain the remainder,
 the next lowest wordsize bits will contain the quotient.

 *Warning*: the quotient and remainder must both fit within 32 bits,
 so the following must hold:

     assert(d > n.rightLogicalShift(wordBits));
 "
Integer unsignedDivide(Integer n, Integer d) {
    // assert(d > n.rightLogicalShift(wordBits));

    variable Integer quotient;
    variable Integer remainder;

    // easy way
    if (n >= 0) {
        quotient = n / d;
        remainder = n % d;
    }
    else {
        // approximate
        quotient = n.rightLogicalShift(1) / d.rightLogicalShift(1);
        remainder = n - quotient * d;

        // correct overshoot
        while (remainder < 0) {
            quotient -= 1;
            remainder += d;
        }

        // correct undershoot
        while (remainder >= d) {
            quotient += 1;
            remainder -= d;
        }
    }
    return quotient * wordRadix + remainder;
}

Integer numberOfTrailingZeros(variable Integer x) {
    x = x.leftLogicalShift(0); // convert to Int32 on JS
    if (x == 0) {
        return runtime.integerAddressableSize;
    }
    else {
        variable value result = 0;
        while (x.and(1) == 0) {
            x = x.rightLogicalShift(1);
            result++;
        }
        return result;
    }
}

Integer unsignedHighestNonZeroBit(variable Integer x) {
    // more convenient than leadingZeros, since
    // integerAddressableSize can vary.
    variable value result = -1;
    while (x != 0) {
        result++;
        x /= 2;
    }
    return result;
}
