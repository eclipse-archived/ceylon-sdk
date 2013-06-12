import java.lang { JInt=Integer { maxInt=\iMAX_VALUE } }
import java.math { BigInteger { jzero=\iZERO, jone=\iONE} }

Whole maxIntImpl = wholeNumber(maxInt);
Whole twoImpl = wholeNumber(2);

"A `Whole` instance representing zero."
shared Whole zero = zeroImpl;
WholeImpl zeroImpl = WholeImpl(jzero);

"A `Whole` instance representing one."
shared Whole one = oneImpl;
WholeImpl oneImpl = WholeImpl(jone);
