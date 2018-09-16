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
    import ceylon.decimal { Mode {...} }
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
