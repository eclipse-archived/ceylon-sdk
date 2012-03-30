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
shared abstract class Mode(JRoundingMode jMode) of floor | ceiling | halfUp | halfDown | halfEven | down | up | unnecessary {
    doc "The equivalent `java.math.RoundingMode`"
    shared JRoundingMode jMode = jMode;
}

doc "Round towards negative infinity."
shared object floor extends Mode(jDown) {}

doc "Round towards positive infinity."
shared object ceiling extends Mode(jCeiling) {}

doc "Round towards the nearest neighbour, or round up if there are two nearest
     neighbours."
shared object halfUp extends Mode(jHalfUp) {}

doc "Round towards the nearest neighbour, or round down if there are two 
     nearest neighbours."
shared object halfDown extends Mode(jHalfDown) {}

doc "Round towards the nearest neighbour, or round towards the even neighbour 
     if there are two nearest neighbours."
shared object halfEven extends Mode(jHalfEven) {}

doc "Round towards zero."
shared object down extends Mode(jHalfDown) {}

doc "Round away from zero."
shared object up extends Mode(jUp) {}

doc "Asserts that rounding will not be required causing an exception to be 
     thrown if it is."
shared object unnecessary extends Mode(jUnnecessary) {}

doc "Holds precision and rounding information for use in decimal arithmetic.
     A precision of 0 means unlimited precision."
throws(Exception, "The precision is negative.")
see(Decimal)
shared class Rounding(Integer precision, Mode mode) {
    if (precision < 0) { 
        throw Exception("Precision cannot be negative");
    }
    
    doc "The precision to apply when rounding."
    shared Integer precision = precision;
    
    doc "The kind of rounding to apply."
    shared Mode mode = mode;
    
    shared MathContext jContext {
        return MathContext(precision, mode.jMode);
    }
    
    shared JRoundingMode jMode {
        return mode.jMode;
    }
    
    shared actual String string {
        if (precision == 0) {
            return "unlimited";
        }
        return "" precision " " mode "";
    } 
}
