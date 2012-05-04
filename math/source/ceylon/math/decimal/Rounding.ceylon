import java.math{
    JRoundingMode=RoundingMode{
        jDown=\iDOWN,
        jUp=\iUP,
        jFloor=\iFLOOR,
        jCeiling=\iCEILING,
        jHalfDown=\iHALF_DOWN,
        jHalfUp=\iHALF_UP,
        jHalfEven=\iHALF_EVEN,
        jUnnecessary=\iUNNECESSARY
    },
    MathContext
}

doc "The ways of rounding a result"
shared abstract class Mode() of floor | ceiling | halfUp | halfDown | halfEven | down | up | unnecessary {
}

doc "Round towards negative infinity."
shared object floor extends Mode() {}

doc "Round towards positive infinity."
shared object ceiling extends Mode() {}

doc "Round towards the nearest neighbour, or round up if there are two nearest
     neighbours."
shared object halfUp extends Mode() {}

doc "Round towards the nearest neighbour, or round down if there are two
     nearest neighbours."
shared object halfDown extends Mode() {}

doc "Round towards the nearest neighbour, or round towards the even neighbour
     if there are two nearest neighbours."
shared object halfEven extends Mode() {}

doc "Round towards zero."
shared object down extends Mode() {}

doc "Round away from zero."
shared object up extends Mode() {}

doc "Asserts that rounding will not be required causing an exception to be
     thrown if it is."
shared object unnecessary extends Mode() {}

doc "Holds precision and rounding information for use in decimal arithmetic.
     A precision of 0 means unlimited precision."
throws(Exception, "The precision is negative.")
see(Decimal)
see(rounding)
see(unlimitedPrecision)
shared abstract class Rounding(precision, mode) of RoundingImpl {
    if (precision < 0) {
        throw Exception("Precision cannot be negative");
    }

    doc "The precision to apply when rounding."
    shared Integer precision;

    doc "The kind of rounding to apply."
    shared Mode mode;

    shared actual String string {
        if (precision == 0) {
            return "unlimited";
        }
        return "" precision " " mode "";
    }

    shared formal Object? implementation;
}

class RoundingImpl(Integer precision, Mode mode) extends Rounding(precision, mode) {
    JRoundingMode jmode;
    switch(mode)
    case (floor) {jmode = jFloor;}
    case (ceiling) {jmode = jCeiling;}
    case (up) {jmode = jUp;}
    case (down) {jmode = jDown;}
    case (halfUp) {jmode = jHalfUp;}
    case (halfDown) {jmode = jHalfDown;}
    case (halfEven) {jmode = jHalfEven;}
    case (unnecessary) {jmode = jUnnecessary;}

    shared actual MathContext implementation = MathContext(precision, jmode);
}

doc "Creates a rounding with the given precision and mode."
shared Rounding rounding(Integer precision, Mode mode) {
    return RoundingImpl(precision, mode);
}

doc "Unlimited precision"
shared Rounding unlimitedPrecision = RoundingImpl(0, halfUp);

