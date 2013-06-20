import java.math { JRoundingMode=RoundingMode { jDown=\iDOWN, jUp=\iUP,
                                                jFloor=\iFLOOR, 
                                                jCeiling=\iCEILING,
                                                jHalfDown=\iHALF_DOWN, 
                                                jHalfUp=\iHALF_UP,
                                                jHalfEven=\iHALF_EVEN,
                                                jUnnecessary=\iUNNECESSARY },
                   MathContext }

"A strategy for rounding the result of an operation
 on two `Decimal`s."
shared abstract class Mode() 
        of floor | ceiling | 
           halfUp | halfDown | halfEven | 
           down | up | unnecessary {
}

"Round towards negative infinity."
shared object floor extends Mode() {}

"Round towards positive infinity."
shared object ceiling extends Mode() {}

"Round towards the nearest neighbour, or round up if 
 there are two nearest neighbours."
shared object halfUp extends Mode() {}

"Round towards the nearest neighbour, or round down if 
 there are two nearest neighbours."
shared object halfDown extends Mode() {}

"Round towards the nearest neighbour, or round towards 
 the even neighbour if there are two nearest neighbours."
shared object halfEven extends Mode() {}

"Round towards zero."
shared object down extends Mode() {}

"Round away from zero."
shared object up extends Mode() {}

"Asserts that rounding will not be required causing an 
 exception to be thrown if it is."
shared object unnecessary extends Mode() {}

"Holds precision and rounding information for use in 
 decimal arithmetic. A precision of `0` means unlimited 
 precision."
throws(Exception, "The precision is negative.")
//TODO see(Decimal)
//TODO see(round)
//TODO see(unlimitedPrecision)
shared abstract class Rounding(precision, mode) of RoundingImpl {
    if (precision < 0) {
        throw Exception("Precision cannot be negative");
    }

    "The precision to apply when rounding."
    shared Integer precision;

    "The kind of rounding to apply."
    shared Mode mode;

    shared actual String string {
        if (precision == 0) {
            return "unlimited";
        }
        return "`` precision `` `` mode ``";
    }

    shared formal Object? implementation;
}

class RoundingImpl(Integer precision, Mode mode) 
        extends Rounding(precision, mode) {
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

    shared actual MathContext implementation = 
            MathContext(precision, jmode);
}

"Creates a rounding with the given precision and mode."
shared Rounding round(Integer precision, Mode mode) {
    return RoundingImpl(precision, mode);
}

"Unlimited precision"
shared Rounding unlimitedPrecision = RoundingImpl(0, halfUp);

