Comparison unsignedCompare(Integer first, Integer second)
    =>  if (first == second) then
            equal
        else if (first + minAddressableInteger >
                 second + minAddressableInteger) then
            larger
        else
            smaller;

"The lowest wordsize bits of the return value will contain the remainder,
 the next lowest wordsize bits will contain the quotient."
Integer unsignedDivide(Integer n, Integer d) {
    // Calculations like the following are very slow and unsupported:
    //
    //    divideAndRemainder(-1, $11)); // massive overshoot
    //
    // assert (wordRadix/2 <= d < wordRadix);
    // assert (n == n.and(wordMask.leftLogicalShift(wordSize) + wordMask));
    assert(d > 1);

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

Words normalized(Words xs) {
    variable value zeros = 0;
    while (zeros < size(xs) && get(xs, zeros) == 0) {
        zeros++;
    }
    return if (zeros == 0) then
        xs
    else if (zeros == xs.size) then
        newWords(0)
    else
        skipWords(xs, zeros);
}