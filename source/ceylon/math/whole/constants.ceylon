import java.lang {
    JInt=Integer {
        maxInt=MAX_VALUE
    }
}
import java.math {
    BigInteger
}

"A `Whole` instance representing zero."
shared Whole zero => zeroImpl;
WholeImpl zeroImpl = WholeImpl(BigInteger.\iZERO);

"A `Whole` instance representing one."
shared Whole one => oneImpl;
WholeImpl oneImpl = WholeImpl(BigInteger.\iONE);

"A `Whole` instance representing two."
shared Whole two = wholeNumber(2);

Whole intMax = wholeNumber(maxInt);
