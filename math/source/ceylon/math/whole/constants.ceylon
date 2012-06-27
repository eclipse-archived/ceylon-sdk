import java.lang{
    JInt=Integer {maxInt=\iMAX_VALUE}
}
import java.math{
    BigInteger{
        jzero=\iZERO,
        jone=\iONE}
}

Whole maxIntImpl = wholeNumber(maxInt);
Whole twoImpl = wholeNumber(2);

WholeImpl zeroImpl = WholeImpl(jzero);
doc "A `Whole` instance representing zero."
shared Whole zero = zeroImpl;

WholeImpl oneImpl = WholeImpl(jone);
doc "A `Whole` instance representing one."
shared Whole one = oneImpl;
