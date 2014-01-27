import ceylon.math.whole { Whole, wrapBigInteger=fromImplementation }

import java.lang { ThreadLocal }
import java.math { MathContext, BigDecimal { bdzero=ZERO }, 
                   JRoundingMode=RoundingMode { jDown=DOWN } }

ThreadLocal<Rounding?> defaultRounding = ThreadLocal<Rounding?>();

class DecimalImpl(BigDecimal num)
        satisfies //Castable<Decimal> &
                  Decimal {

    shared actual BigDecimal implementation = num;

    shared actual Decimal dividedTruncated(Decimal other, 
                                           Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(implementation
                        .divideToIntegralValue(other.implementation, 
                                rounding.implementation));
            } else if (!rounding exists) {
                return DecimalImpl(implementation
                        .divideToIntegralValue(other.implementation));
            }
        }
        throw;
    }
    
    shared actual Decimal remainderRounded(Decimal other, 
                                           Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(implementation
                        .remainder(other.implementation, 
                                rounding.implementation));
            } else if (!rounding exists) {
                return DecimalImpl(implementation
                        .remainder(other.implementation));
            }
        }
        throw;
    }

    shared actual DividedWithRemainder dividedAndRemainder(Decimal other, 
                                                           Rounding? rounding) {
        if (is DecimalImpl other) {
            Array<BigDecimal?> array;
            if (is RoundingImpl rounding) {
                array = implementation
                        .divideAndRemainder(other.implementation, 
                                rounding.implementation).array;
            } else if (!rounding exists) {
                array = implementation
                        .divideAndRemainder(other.implementation).array;
            } else {
                throw;
            }
            return DividedWithRemainder(DecimalImpl(array[0] else bdzero), 
                    DecimalImpl(array[1] else bdzero));
        }
        throw;
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
        if (is RoundingImpl rounding) {
            return DecimalImpl(implementation
                    .round(rounding.implementation));
        }
        throw;
    }
    shared actual Comparison compare(Decimal other) {
        if (is DecimalImpl other) {
            Integer cmp = implementation
                    .compareTo(other.implementation);
            if (cmp < 0) {
                return smaller;
            } else if (cmp > 0) {
                return larger;
            }
            return equal;
        }
        throw;
    }
    shared actual Decimal divided(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return dividedRounded(other, rounding);
            }
            return DecimalImpl(implementation
                    .divide(other.implementation));
        }
        throw;
    }
    shared actual Decimal dividedRounded(Decimal other, 
                                         Rounding? rounding) {
         if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(implementation
                        .divide(other.implementation, 
                                rounding.implementation));
            } else if (!rounding exists) {
                return DecimalImpl(implementation
                        .divide(other.implementation));
            }
        }
        throw;
    }
    shared actual Boolean equals(Object that) {
        if (is DecimalImpl that) {
            return implementation===that.implementation
                || implementation.compareTo(that.implementation)==0;
        }
        return false;
    }
    shared actual Boolean strictlyEquals(Decimal that) {
        if (is DecimalImpl that) {
              return implementation===that.implementation
                  || implementation==that.implementation;
        }
        throw;
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
    shared actual Decimal magnitude {
        return DecimalImpl(implementation
                .round(MathContext(implementation.scale(), jDown)));
    }
    shared actual Decimal minus(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return minusRounded(other, rounding);
            }
            return DecimalImpl(implementation
                    .subtract(other.implementation));
        }
        throw;
    }
    shared actual Decimal minusRounded(Decimal other, 
                                       Rounding? rounding) {
         if (is DecimalImpl other) {
             if (is RoundingImpl rounding) {
                 return DecimalImpl(implementation
                         .subtract(other.implementation, 
                                 rounding.implementation));
             } else if (!rounding exists) {
                 return DecimalImpl(implementation
                         .subtract(other.implementation));
             }
        }
        throw;
    }
    shared actual Decimal fractionalPart {
        return minus(this.magnitude);
    }
    shared actual Boolean negative {
        return implementation.signum() < 0;
    }
    shared actual Decimal negativeValue {
        return DecimalImpl(implementation.negate());
    }
    shared actual Decimal plus(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return plusRounded(other, rounding);
            }
            return DecimalImpl(implementation
                    .add(other.implementation));
        }
        throw;
    }
    shared actual Decimal plusRounded(Decimal other, 
                                      Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(implementation
                        .add(other.implementation, 
                                rounding.implementation));
            } else if (!rounding exists) {
                return DecimalImpl(implementation
                        .add(other.implementation));
            }
        }
        throw;
    }
    shared actual Boolean positive {
        return implementation.signum() > 0;
    }
    shared actual Decimal positiveValue {
        return this;
    }
    shared actual Decimal power(Integer other) {
        Rounding? rounding = defaultRounding.get();
        if (exists rounding) {
            return powerRounded(other, rounding);
        }
        if (other.sign < 0) {
            throw Exception("Negative powers are not supported with unlimited precision");
        }
        // TODO Special cases
        return DecimalImpl(implementation.pow(other));
    }
    shared actual Decimal powerRounded(Integer other, 
                                       Rounding? rounding) {
        if (is RoundingImpl rounding) {
            return DecimalImpl(implementation
                    .pow(other, rounding.implementation));
        } else if (!rounding exists) {
            return DecimalImpl(implementation.pow(other));
        }
        throw;
    }
    shared actual Integer sign {
        return this.implementation.signum();
    }
    shared actual String string {
        return this.implementation.string;
    }
    shared actual Decimal times(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return timesRounded(other, rounding);
            }
            return DecimalImpl(implementation
                    .multiply(other.implementation));
        }
        throw;
    }
    shared actual Decimal timesRounded(Decimal other, 
                                       Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(implementation
                        .multiply(other.implementation, 
                                rounding.implementation));
            } else if (!rounding exists) {
                return DecimalImpl(implementation
                        .multiply(other.implementation));
            }
        }
        throw;
    }
    
    shared actual Decimal wholePart {
        return DecimalImpl(BigDecimal(this.implementation.toBigInteger()));
    }
    
    "The result of multiplying this number by the given 
     [[Integer]]."
    shared actual Decimal timesInteger(Integer integer) {
        return DecimalImpl(this.implementation.multiply(BigDecimal(integer)));
    }
    
    "The result of adding this number to the given 
     [[Integer]]."
    shared actual Decimal plusInteger(Integer integer) {
        return DecimalImpl(this.implementation.add(BigDecimal(integer)));
    }
    
    
    /*shared actual Decimal castTo<Decimal>() {
        // TODO What do I do here return this;
        throw;
    }*/
}
