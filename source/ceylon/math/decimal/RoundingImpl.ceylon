/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
