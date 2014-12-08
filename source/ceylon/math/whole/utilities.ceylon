Comparison unsignedCompare(Integer first, Integer second)
    =>  if (first == second) then
            equal
        else if (first + minAddressableInteger >
                 second + minAddressableInteger) then
            larger
        else
            smaller;

[Integer, Integer] unsignedDivide(Integer n, Integer d) {
    // Calculations like the following are very slow and unsupported:
    //
    //    divideAndRemainder(-1, $11)); // massive overshoot
    //
    // assert (wordRadix/2 <= d < wordRadix);
    // assert (n == n.and(wordMask.leftLogicalShift(wordSize) + wordMask));
    assert(d > 1);

    // easy way
    if (n >= 0) {
        return [n / d, n % d];
    }

    // approximate
    variable value q = n.rightLogicalShift(1) / d.rightLogicalShift(1);
    variable value r = n - q * d;

    // correct overshoot
    while (r < 0) {
        q -= 1;
        r += d;
    }

    // correct undershoot
    while (r >= d) {
        q += 1;
        r -= d;
    }

    return [q, r];
}

List<Integer> normalized(List<Integer> xs)
    =>  let (firstNonZero = xs.firstIndexWhere((Integer element) => !element.zero))
        if (!exists firstNonZero) then
            Array<Integer> {}
        else if (firstNonZero == 0) then
            xs
        else
            xs[firstNonZero..xs.size-1];
