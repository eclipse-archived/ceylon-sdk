import java.math {
    BigInteger {
        fromLong=valueOf
    }
}

"The `number.integer` converted to a `Whole`."
shared Whole wholeNumber(Number number) {
    Integer int = number.integer;
    if (int == 0) {
        return zeroImpl;
    } else if (int == 1) {
        return oneImpl;
    } else {
        return WholeImpl(fromLong(int));
    }
}