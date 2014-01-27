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
    case (floor) { jmode = JRoundingMode.\iFLOOR; }
    case (ceiling) { jmode = JRoundingMode.\iCEILING; }
    case (up) { jmode = JRoundingMode.\iUP; }
    case (down) { jmode = JRoundingMode.\iDOWN; }
    case (halfUp) { jmode = JRoundingMode.\iHALF_UP; }
    case (halfDown) { jmode = JRoundingMode.\iHALF_DOWN; }
    case (halfEven) { jmode = JRoundingMode.\iHALF_EVEN; }
    case (unnecessary) { jmode = JRoundingMode.\iUNNECESSARY; }

    shared actual MathContext implementation = 
            MathContext(precision, jmode);
}

ThreadLocal<Rounding?> defaultRounding = ThreadLocal<Rounding?>();
