import java.math {
    JRoundingMode=RoundingMode {
        jDown=DOWN,
        jUp=UP,
        jFloor=FLOOR,
        jCeiling=CEILING,
        jHalfDown=HALF_DOWN,
        jHalfUp=HALF_UP,
        jHalfEven=HALF_EVEN,
        jUnnecessary=UNNECESSARY
    },
    MathContext
}
import java.lang { ThreadLocal }

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

ThreadLocal<Rounding?> defaultRounding = ThreadLocal<Rounding?>();
