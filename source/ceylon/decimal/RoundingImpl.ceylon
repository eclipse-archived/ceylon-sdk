import java.lang {
    ThreadLocal
}
import java.math {
    JRoundingMode=RoundingMode,
    MathContext
}

class RoundingImpl(Integer precision, Mode mode) 
        extends Rounding(precision, mode) {
    
    JRoundingMode jmode;
    switch(mode)
    case (floor) { jmode = JRoundingMode.floor; }
    case (ceiling) { jmode = JRoundingMode.ceiling; }
    case (up) { jmode = JRoundingMode.up; }
    case (down) { jmode = JRoundingMode.down; }
    case (halfUp) { jmode = JRoundingMode.halfUp; }
    case (halfDown) { jmode = JRoundingMode.halfDown; }
    case (halfEven) { jmode = JRoundingMode.halfEven; }
    case (unnecessary) { jmode = JRoundingMode.unnecessary; }

    shared actual MathContext implementation = 
            MathContext(precision, jmode);
}

ThreadLocal<Rounding?> defaultRounding = ThreadLocal<Rounding?>();
