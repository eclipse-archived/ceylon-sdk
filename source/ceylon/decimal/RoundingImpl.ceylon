import java.lang {
    ThreadLocal
}
import java.math {
    JRoundingMode=RoundingMode,
    MathContext
}

class RoundingImpl(Integer precision, Mode mode) 
        extends Rounding(precision, mode) {
    value jmode
            = switch(mode)
            case (floor) JRoundingMode.floor
            case (ceiling) JRoundingMode.ceiling
            case (up) JRoundingMode.up
            case (down) JRoundingMode.down
            case (halfUp) JRoundingMode.halfUp
            case (halfDown) JRoundingMode.halfDown
            case (halfEven) JRoundingMode.halfEven
            case (unnecessary) JRoundingMode.unnecessary;

    shared actual MathContext implementation = 
            MathContext(precision, jmode);
}

ThreadLocal<Rounding?> defaultRounding = ThreadLocal<Rounding?>();
