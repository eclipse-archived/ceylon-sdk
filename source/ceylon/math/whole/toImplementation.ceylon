import java.math {
    BigInteger
}

BigInteger toImplementation(Whole whole) {
    if (whole.zero) {
        return BigInteger.\iZERO;
    }
    else if (whole.unit) {
        return BigInteger.\iONE;
    }
    else {
        variable value wholeMagnitude = whole.magnitude;
        variable value result = BigInteger.\iZERO;
        variable value shift = 0;
        while (!wholeMagnitude.zero) {
            value x = BigInteger.valueOf(
                wholeMagnitude.integer.and(#ffffffff)).shiftLeft(shift);
            result = result.or(x);
            wholeMagnitude = wholeMagnitude.rightArithmeticShift(32);
            shift += 32;
        }
        if (whole.negative) {
            result = result.negate();
        }
        return result;
    }
}
