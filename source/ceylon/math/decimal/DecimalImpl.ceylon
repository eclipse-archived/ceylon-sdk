/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.math.whole {
    Whole,
    wrapBigInteger=fromImplementation
}

import java.math {
    BigDecimal
}


final class DecimalImpl(BigDecimal num)
        satisfies Decimal {

    shared actual BigDecimal implementation = num;

    shared actual Decimal dividedTruncated(Decimal other, 
                                           Rounding? rounding) {
        assert (is DecimalImpl other);
        switch (rounding)
        case (RoundingImpl) {
            return DecimalImpl(implementation
                    .divideToIntegralValue(other.implementation, 
                            rounding.implementation));
        } case (null) {
            return DecimalImpl(implementation
                    .divideToIntegralValue(other.implementation));
        } else {
            assert (false);
        }
    }
    
    shared actual Decimal remainderRounded(Decimal other, 
                                           Rounding? rounding) {
        assert (is DecimalImpl other);
        switch (rounding)
        case (RoundingImpl) {
            return DecimalImpl(implementation
                    .remainder(other.implementation, 
                            rounding.implementation));
        } case (null) {
            return DecimalImpl(implementation
                    .remainder(other.implementation));
        } else {
            assert (false);
        }
    }

    shared actual DividedWithRemainder dividedAndRemainder(Decimal other, 
                                                           Rounding? rounding) {
        assert (is DecimalImpl other);
        Array<BigDecimal?> array;
        switch (rounding)
        case (RoundingImpl) {
            array = implementation
                    .divideAndRemainder(other.implementation, 
            rounding.implementation).array;
        } case (null) {
            array = implementation
                    .divideAndRemainder(other.implementation).array;
        } else {
            assert (false);
        }
        return DividedWithRemainder(DecimalImpl(array[0] else BigDecimal.zero),
                DecimalImpl(array[1] else BigDecimal.zero));
    }

    "The precision of this decimal."
    shared actual Integer precision {
        return implementation.precision();
    }
    "The scale of this decimal."
    shared actual Integer scale {
        return implementation.scale();
    }
    "The unscaled value."
    shared actual Whole unscaled {
        return wrapBigInteger(implementation.unscaledValue());
    }
    "This value rounded according to the given context."
    shared actual Decimal round(Rounding rounding) {
        assert (is RoundingImpl rounding);
        return DecimalImpl(implementation
                .round(rounding.implementation));
    }
    shared actual Comparison compare(Decimal other) {
        assert (is DecimalImpl other);
        Integer cmp = implementation
                .compareTo(other.implementation)
                .sign;
        switch (cmp)
        case (-1) {
            return smaller;
        } case (1) {
            return larger;
        } else {
            return equal;
        }
    }
    shared actual Decimal divided(Decimal other) {
        assert (is DecimalImpl other);
        if (exists rounding = defaultRounding.get()) {
            return dividedRounded(other, rounding);
        } else {
            return DecimalImpl(implementation
                    .divide(other.implementation));
        }
    }
    shared actual Decimal dividedRounded(Decimal other, 
                                         Rounding? rounding) {
        assert (is DecimalImpl other);
        switch (rounding)
        case (RoundingImpl) {
            return DecimalImpl(implementation
                    .divide(other.implementation, 
            rounding.implementation));
        } case (null) {
            return DecimalImpl(implementation
                    .divide(other.implementation));
        } else {
            assert (false);
        }
    }
    shared actual Boolean equals(Object that) {
        assert (is DecimalImpl that);
        return implementation===that.implementation
                || implementation.compareTo(that.implementation)==0;
    }
    shared actual Boolean strictlyEquals(Decimal that) {
        assert (is DecimalImpl that);
        return implementation===that.implementation
                || implementation==that.implementation;
    }
    shared actual Float float {
        return implementation.doubleValue();
    }
    shared actual Integer hash {
        return implementation.stripTrailingZeros().hash;
    }
    shared actual Integer integer {
        return implementation.longValue();
    }
    shared actual Whole whole {
        return wrapBigInteger(implementation.toBigInteger());
    }
    shared actual Decimal minus(Decimal other) {
        assert (is DecimalImpl other);
        if (exists rounding = defaultRounding.get()) {
            return minusRounded(other, rounding);
        }
        else {
            return DecimalImpl(implementation
                    .subtract(other.implementation));
        }
    }
    shared actual Decimal minusRounded(Decimal other, 
                                       Rounding? rounding) {
         assert (is DecimalImpl other);
         switch (rounding)
         case (RoundingImpl) {
             return DecimalImpl(implementation
                     .subtract(other.implementation, 
                             rounding.implementation));
         } case (null) {
             return DecimalImpl(implementation
                     .subtract(other.implementation));
         } else {
             assert (false);
         }
    }
    shared actual Decimal fractionalPart {
        return minus(this.wholePart);
    }
    shared actual Boolean negative {
        return implementation.signum() < 0;
    }
    shared actual Decimal negated {
        return DecimalImpl(implementation.negate());
    }
    shared actual Decimal plus(Decimal other) {
        assert (is DecimalImpl other);
        if (exists rounding = defaultRounding.get()) {
            return plusRounded(other, rounding);
        }
        else {
            return DecimalImpl(implementation
                    .add(other.implementation));
        }
    }
    shared actual Decimal plusRounded(Decimal other, 
                                      Rounding? rounding) {
        assert (is DecimalImpl other);
        switch (rounding)
        case (RoundingImpl) {
            return DecimalImpl(implementation
                    .add(other.implementation, 
                            rounding.implementation));
        } case (null) {
            return DecimalImpl(implementation
                    .add(other.implementation));
        } else {
            assert (false);
        }
    }
    shared actual Boolean positive {
        return implementation.signum() > 0;
    }
    shared actual Decimal power(Integer other) {
        if (exists rounding = defaultRounding.get()) {
            return powerRounded(other, rounding);
        } else {
            "exponent must be non-negative"
            assert (other>=0);
            // TODO Special cases
            return DecimalImpl(implementation.pow(other));
        }
    }
    shared actual Decimal powerRounded(Integer other, 
                                       Rounding? rounding) {
        switch (rounding)
        case (RoundingImpl) {
            return DecimalImpl(implementation
                    .pow(other, rounding.implementation));
        } case (null) {
            return DecimalImpl(implementation.pow(other));
        } else {
            assert (false);
        }
    }
    shared actual Integer sign {
        return this.implementation.signum();
    }
    shared actual String string {
        return this.implementation.string;
    }
    shared actual Decimal times(Decimal other) {
        assert (is DecimalImpl other);
        if (exists rounding = defaultRounding.get()) {
            return timesRounded(other, rounding);
        }
        return DecimalImpl(implementation
                .multiply(other.implementation));
    }
    shared actual Decimal timesRounded(Decimal other, 
                                       Rounding? rounding) {
        assert (is DecimalImpl other);
        switch (rounding)
        case (RoundingImpl) {
            return DecimalImpl(implementation
                    .multiply(other.implementation, 
            rounding.implementation));
        } case (null) {
            return DecimalImpl(implementation
                    .multiply(other.implementation));
        } else {
            assert (false);
        }
    }
    
    shared actual Decimal wholePart {
        return DecimalImpl(BigDecimal(this.implementation.toBigInteger()));
    }
    
    shared actual Decimal plusInteger(Integer integer) {
        return DecimalImpl(implementation.add(BigDecimal.valueOf(integer)));
    }
    
    shared actual Decimal timesInteger(Integer integer) {
        return DecimalImpl(implementation.multiply(BigDecimal.valueOf(integer)));
    }
    
    shared actual Decimal powerOfInteger(Integer integer) {
        "exponent must be non-negative"
        assert (integer>=0);
        return DecimalImpl(implementation.pow(integer));
    }
    
}
